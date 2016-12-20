> copy from http://www.tcpdump.org/pcap.html

# Programming with pcap

>Tim Carstens
>
>timcarst at yahoo dot com
>
>Further editing and development by Guy Harris
>
>guy at alum dot mit dot edu


Ok, let's begin by defining who this document is written for. Obviously, some basic knowledge of C is required, unless you only wish to know the basic theory. You do not need to be a code ninja; for the areas likely to be understood only by more experienced programmers, I'll be sure to describe concepts in greater detail. Additionally, some basic understanding of networking might help, given that this is a packet sniffer and all. All of the code examples presented here have been tested on FreeBSD 4.3 with a default kernel.

> 好吧，让我们看看这个文档是写给谁的（读这篇文档的基础修养），显然，要知道一些C语言的基础知识，或者你是天才，懂得其中的原理。你可以不是一个编程忍者（极客）。在讲到一些比较深入的地方，我会很详细地去描述。此外，了解一些基本的网络原理更加利于理解
>
>这些代码是在 FreeBSD4.3 的默认内核上运行的

## Getting Started: The format of a pcap application

> 开始： 编写pcap的步骤

The first thing to understand is the general layout of a pcap sniffer. The flow of code is as follows:

> 首先要了解pcap sniffer的整体框架， 接下来的内容主要包括

1. We begin by determining which interface we want to sniff on. In Linux this may be something like eth0, in BSD it may be xl1, etc. We can either define this device in a string, or we can ask pcap to provide us with the name of an interface that will do the job.
1. Initialize pcap. This is where we actually tell pcap what device we are sniffing on. We can, if we want to, sniff on multiple devices. How do we differentiate between them? Using file handles. Just like opening a file for reading or writing, we must name our sniffing "session" so we can tell it apart from other such sessions.
1. In the event that we only want to sniff specific traffic (e.g.: only TCP/IP packets, only packets going to port 23, etc) we must create a rule set, "compile" it, and apply it. This is a three phase process, all of which is closely related. The rule set is kept in a string, and is converted into a format that pcap can read (hence compiling it.) The compilation is actually just done by calling a function within our program; it does not involve the use of an external application. Then we tell pcap to apply it to whichever session we wish for it to filter.
1. Finally, we tell pcap to enter it's primary execution loop. In this state, pcap waits until it has received however many packets we want it to. Every time it gets a new packet in, it calls another function that we have already defined. The function that it calls can do anything we want; it can dissect the packet and print it to the user, it can save it in a file, or it can do nothing at all.
1. After our sniffing needs are satisfied, we close our session and are complete.



> 1. 我们从定义那个网卡开始监听， 在linux中一般是eth0，在BSD 可能是xl1, 我们可以把这些设备定义成一个字符串，或者让pcap自己给他命名
> 2. 初始化pcap, 也就是告诉pcap，我们要嗅探什么。如果你想，我们可以嗅探一堆设备。然后我们又怎么区分他们呢？使用文件句柄，就像打开一个文件一样。我们必须为我们的每次“会话”命名，这样就可以区分每个会话了
> 3. 通常我们还会制定一些特别的规则用来过滤（比如 只接受TCP/IP 的包， 只接受23号端口的包），这是第三部分的内容。这些关系都很紧密。规则是用字符串的形式保存的，而且还要转换成pcap能读取的形式。这个过程也只是调用函数而已。
> 4. 最后，我们执行自己的处理函数去处理数据包，这个时候pcap是等待的，直到他收到我们想要的数据包。每当它得到一个新的数据包，它调用我们已经定义的另一个函数。 它调用的函数可以做任何我们想要的; 它可以解析数据包并将其打印到用户，它可以将其保存在文件中，或者它根本不做任何事情。
> 5. 嗅探完毕后，关闭我们的会话，然后就嗅探完成


This is actually a very simple process. Five steps total, one of which is optional (step 3, in case you were wondering.) Let's take a look at each of the steps and how to implement them.

> 这真的是一个很简单的程序，5个步骤，其中一个是设置（步骤3，取决于你自己的需要），那我们开干吧

## Setting the device

This is terribly simple. There are two techniques for setting the device that we wish to sniff on.

> 这个真是简单到可怕，两个操作就能得到我们想要嗅探的设备

The first is that we can simply have the user tell us. Consider the following program:

> 首先可以简单地由用户告诉我们（？没看懂什么意思，因该是指嗅探哪个设备）  自己看代码

```c
#include <stdio.h>
#include <pcap.h>

int main(int argc, char *argv[])
{
     char *dev = argv[1];       //从命令行读入参数（也就是设备名称）

     printf("Device: %s\n", dev);       //额，直接就输出。。。
     return(0);
}
```
The user specifies the device by passing the name of it as the first argument to the program. Now the string "dev" holds the name of the interface that we will sniff on in a format that pcap can understand (assuming, of course, the user gave us a real interface).

> 懒得翻译了，具体就是让用户自己输入这次会话的名字（通过命令行传参数的方法输入）

The other technique is equally simple. Look at this program:

> 接下来的操作也简单到爆，

```c
#include <stdio.h>
#include <pcap.h>

int main(int argc, char *argv[])
{
    char *dev, errbuf[PCAP_ERRBUF_SIZE];    //设置一个缓冲区，用来装错误信息的

    dev = pcap_lookupdev(errbuf);       //这个函数就是嗅探一个设备，并且返回这个设备的句柄，参数是用来装错误的 char[]

    // 错误检查
    if (dev == NULL) {
        fprintf(stderr, "Couldn't find default device: %s\n", errbuf);
        return(2);
    }
    printf("Device: %s\n", dev);
    return(0);
}
```

In this case, pcap just sets the device on its own. "But wait, Tim," you say. "What is the deal with the errbuf string?" Most of the pcap commands allow us to pass them a string as an argument. The purpose of this string? In the event that the command fails, it will populate the string with a description of the error. In this case, if pcap_lookupdev() fails, it will store an error message in errbuf. Nifty, isn't it? And that's how we set our device.

> 在这步，pcap自己设置并嗅探了一个设备，然后还要一个char[] 来装 错误，如果有错误信息就会放到这个字符数组里面



## Opening the device for sniffing

The task of creating a sniffing session is really quite simple. For this, we `use pcap_open_live()`. The prototype of this function (from the pcap man page) is as follows:


> 创建一个嗅探会话真心简单，只需要用`use_open_live()`就行了。这个函数的原型长这样：（最起码在 `man pcap` 文档里面是这么写的）

```c
pcap_t *pcap_open_live(char *device,        //上面指定嗅探的设备 
                    int snaplen,            //pcap抓取的最大字节数
                    int promisc,            //是否选择混杂模式（ture为是）（就算是假，在特性模式也可能是混杂模式）
                    int to_ms,              //设置超时（毫秒，0表示没有超时）
                    char *ebuf)             //存放错误信息的char[]

//返回值是 会话句柄
```

The first argument is the device that we specified in the previous section. snaplen is an integer which defines the maximum number of bytes to be captured by pcap. promisc, when set to true, brings the interface into promiscuous mode (however, even if it is set to false, it is possible under specific cases for the interface to be in promiscuous mode, anyway). to_ms is the read time out in milliseconds (a value of 0 means no time out; on at least some platforms, this means that you may wait until a sufficient number of packets arrive before seeing any packets, so you should use a non-zero timeout). Lastly, ebuf is a string we can store any error messages within (as we did above with errbuf). The function returns our session handler.

> 这段话的主要内容是介绍参数和返回值，已经写在代码注释中，下面是机翻
>
>> 第一个参数是我们在上一节中指定的设备。 snaplen是一个整数，定义了pcap捕获的最大字节数。 promisc，当设置为true时，使接口进入混杂模式（但是，即使设置为false，在特定情况下接口也可能处于混杂模式）。 to_ms是以毫秒为单位的读取超时（值为0表示没有超时;在至少一些平台上，这意味着您可以等到足够数量的数据包到达，然后才看到任何数据包，因此您应该使用非零 暂停）。 最后，ebuf是一个字符串，我们可以存储任何错误消息（如我们上面使用errbuf）。 该函数返回我们的会话句柄。

To demonstrate, consider this code snippet:

> 下面代码演示用

```c
#include <pcap.h>

pcap_t *handle;     //这个是个会话句柄类型

handle = pcap_open_live(dev, BUFSIZ, 1, 1000, errbuf);      //这个函数返回就是会话句柄
if (handle == NULL) {           //也要检查
    fprintf(stderr, "Couldn't open device %s: %s\n", dev, errbuf);
    return(2);
}
```


This code fragment opens the device stored in the strong "dev", tells it to read however many bytes are specified in BUFSIZ (which is defined in pcap.h). We are telling it to put the device into promiscuous mode, to sniff until an error occurs, and if there is an error, store it in the string errbuf; it uses that string to print an error message.

> 这段代码启用了设备，并且告诉他读取多少字节的数据（通过BUFSIZ参数），而且设置了混杂模式，并且一直嗅探直到发送错误。如果发生了错误，错误会被写在 errbuf的字符数组里面，最后还把errbuf里面的错误输出到stderr里面


A note about promiscuous vs. non-promiscuous sniffing: The two techniques are very different in style. In standard, non-promiscuous sniffing, a host is sniffing only traffic that is directly related to it. Only traffic to, from, or routed through the host will be picked up by the sniffer. Promiscuous mode, on the other hand, sniffs all traffic on the wire. In a non-switched environment, this could be all network traffic. The obvious advantage to this is that it provides more packets for sniffing, which may or may not be helpful depending on the reason you are sniffing the network. However, there are regressions. Promiscuous mode sniffing is detectable; a host can test with strong reliability to determine if another host is doing promiscuous sniffing. Second, it only works in a non-switched environment (such as a hub, or a switch that is being ARP flooded). Third, on high traffic networks, the host can become quite taxed for system resources.

> 关于混杂模式和非混杂模式的区别：两种方式完全是两种风格。从标准角度来讲，非混杂模式，主机只能嗅探到和他直接相关的流量，一般只有流经自己的数据包才能抓到。混杂模式恰恰相反，可以嗅探所以网内的包。在非交换网络环境中，这可能是网络中所有的数据包。混杂模式明显的优势是提供更多的信息（同样，也会有很多没用的信息，取决于你像干嘛）。当然也是有代价的。混杂模式嗅探是能被发现的。其他主机很可能发现你在用混杂模式嗅探，其次，混杂模式只能在非交换环境中工作（hub，arp交换网络），再次，在大吞吐量网络中真心考验主机的性能


Not all devices provide the same type of link-layer headers in the packets you read. Ethernet devices, and some non-Ethernet devices, might provide Ethernet headers, but other device types, such as loopback devices in BSD and OS X, PPP interfaces, and Wi-Fi interfaces when capturing in monitor mode, don't.

> 并非所有设备在您读取的数据包中提供相同类型的链路层报头.在监听时候，以太网设备和一些非以太网设备可能提供以太网头部，但是其他设备如BSD，OS X， PPP， WiFi，不会提供头部

You need to determine the type of link-layer headers the device provides, and use that type when processing the packet contents. The `pcap_datalink()` routine returns a value indicating the type of link-layer headers; see the list of link-layer header type values. The values it returns are the DLT_ values in that list.

> 您需要确定设备提供的链路层报头的类型，并在处理数据包内容时使用该类型. `pcap_datalink()` 函数返回一个头部信息的值。。。（？不会翻译）表头信息可以参考 (http://www.tcpdump.org/linktypes.html) ，函数返回的值是DTL_值


If your program doesn't support the link-layer header type provided by the device, it has to give up; this would be done with code such as

> 如果您的程序不支持设备提供的链路层标头类型，则必须放弃.

```c
if (pcap_datalink(handle) != DLT_EN10MB) {
        fprintf(stderr, "Device %s doesn't provide Ethernet headers - not supported\n", dev);
    return(2);
}
```

which fails if the device doesn't supply Ethernet headers. This would be appropriate for the code below, as it assumes Ethernet headers.

> 失败说明这个并不支持以太网头部，下面的代码同样适用，因为它假定以太网头。

## Filtering traffic

> 过滤规则


Often times our sniffer may only be interested in specific traffic. For instance, there may be times when all we want is to sniff on port 23 (telnet) in search of passwords. Or perhaps we want to highjack a file being sent over port 21 (FTP). Maybe we only want DNS traffic (port 53 UDP). Whatever the case, rarely do we just want to blindly sniff all network traffic. Enter pcap_compile() and pcap_setfilter().

> 通常我们只对某些流量感兴趣，比如我们只想嗅探23号端口（telnet）的数据（用来找密码），或者我们想劫持一个刚刚从12号端口（ftp）发送的文件， 或者我们想让搞DNS（53号udp端口）（想想都有点邪恶） ，总而言之，我们不会毫无目的地去搞所有的流量，这里要用到`pcap_compile()`和`pcap_setfilter()`

The process is quite simple. After we have already called pcap_open_live() and have a working sniffing session, we can apply our filter. Why not just use our own if/else if statements? Two reasons. First, pcap's filter is far more efficient, because it does it directly with the BPF filter; we eliminate numerous steps by having the BPF driver do it directly. Second, this is a lot easier :)

> 这个程序也很简单，在我们执行完`pcap_open_live()` 并且得到一个嗅探会话（sniffing session）之后，我们可以使用我们的过滤器了。为什么不用 if /else if 语句过滤呢？ 两个原因： 第一个是 pcap 的过滤器是非常高效的,因为他直接作用于[BPF](https://en.wikipedia.org/wiki/BPF),大概意思是在很底层的程度上过滤。而且还能节省很多步骤。其次就是简单粗暴（方便）


Before applying our filter, we must "compile" it. The filter expression is kept in a regular string (char array). The syntax is documented quite well in the man page for tcpdump; I leave you to read it on your own. However, we will use simple test expressions, so perhaps you are sharp enough to figure it out from my examples.

> 在使用过滤器之前，我们需要配置它，过滤器的表达式（我觉得叫规则好理解）是用字符数组来存放的(char[]),具体语法需要参考 **tcpdump文档** ， 你自己去看。

To compile the program we call `pcap_compile()`. The prototype defines it as:

> 我们需要用`pcap_compile()` 来配置

```c
int pcap_compile(pcap_t *p,                 //会话句柄
                struct bpf_program *fp,     //配置结构体，配置完成后这个结构体就是代表规则
                char *str,                  //过滤规则表达式 
                int optimize,               //是否是被优化（0=false，1=true） 
                bpf_u_int32 netmask)        //子网掩码

// 函数返回-1表示失败，其他返回值表示成功
```


The first argument is our session handle (pcap_t *handle in our previous example). Following that is a reference to the place we will store the compiled version of our filter. Then comes the expression itself, in regular string format. Next is an integer that decides if the expression should be "optimized" or not (0 is false, 1 is true. Standard stuff.) Finally, we must specify the network mask of the network the filter applies to. The function returns -1 on failure; all other values imply success.

> 对参数的描述，下面是机翻
>> 第一个参数是我们的会话句柄（在我们前面的例子中的pcap_t *句柄）。接下来是对我们将存储我们的过滤器的编译版本的地方的引用。然后是表达式本身，以常规字符串格式。接下来是一个整数，决定表达式是否应该被“优化”（0是假，1是真的。标准的东西。）最后，我们必须指定过滤器适用的网络的网络掩码。该函数在失败时返回-1;所有其他值意味着成功

After the expression has been compiled, it is time to apply it. Enter pcap_setfilter(). Following our format of explaining pcap, we shall look at the pcap_setfilter() prototype:

> 当表达式被配置完成了，那么就可以使用了，`pcap_setfilter()`， 下面是这个函数的原型

```c
int pcap_setfilter(pcap_t *p,           //要应用这个规则的会话
                    struct bpf_program *fp)     //规则配置好的规则结构体
```


This is very straightforward. The first argument is our session handler, the second is a reference to the compiled version of the expression (presumably the same variable as the second argument to pcap_compile()).

> 也是函数参数，下面是机翻
>> 他很直接。第一个参数是我们的会话处理程序，第二个是对表达式的编译版本的引用(与`pcap_setfiler()`第二个参数相同的变量)

Perhaps another code sample would help to better understand:

> 来点代码加深理解

```c
#include <pcap.h>

pcap_t *handle;        /* 会话句柄  */
char dev[] = "rl0";        /*将要启动嗅探的设备 */
char errbuf[PCAP_ERRBUF_SIZE]; /* 错误存放的地方 */
struct bpf_program fp;     /*过滤规则结构体*/
char filter_exp[] = "port 23"; /*过滤规则，自己看什么意思*/
bpf_u_int32 mask;      /*掩码（嗅探设备能用的）*/
bpf_u_int32 net;       /*设备ip*/


//启动设备
if (pcap_lookupnet(dev, &net, &mask, errbuf) == -1) {
    fprintf(stderr, "Can't get netmask for device %s\n", dev);
    net = 0;
    mask = 0;
}

//获取会话句柄
handle = pcap_open_live(dev, BUFSIZ, 1, 1000, errbuf);
if (handle == NULL) {
    fprintf(stderr, "Couldn't open device %s: %s\n", dev, errbuf);
    return(2);
}

//配置 规则结构体
if (pcap_compile(handle, &fp, filter_exp, 0, net) == -1) {
    fprintf(stderr, "Couldn't parse filter %s: %s\n", filter_exp, pcap_geterr(handle));
    return(2);
}
if (pcap_setfilter(handle, &fp) == -1) {
    fprintf(stderr, "Couldn't install filter %s: %s\n", filter_exp, pcap_geterr(handle));
    return(2);
}
```

This program preps the sniffer to sniff all traffic coming from or going to port 23, in promiscuous mode, on the device rl0.

> 这个程序实现了一个用r10网卡在混杂模式下抓23号端口数据的sniffer


You may notice that the previous example contains a function that we have not yet discussed. `pcap_lookupnet()` is a function that, given the name of a device, returns one of its IPv4 network numbers and corresponding network mask (the network number is the IPv4 address ANDed with the network mask, so it contains only the network part of the address). This was essential because we needed to know the network mask in order to apply the filter. This function is described in the Miscellaneous section at the end of the document.

> 你可能发现了这个程序包含了一个新的函数`pcap_lookupnet()`，这个函数 如果给他传入设备名字，那么就会返回那个设备的IPv4地址以及掩码（网络号是IPv4地址与网络掩码进行AND运算，因此它只包含网络部分的地址），这是很有必要的，因为我们需要知道掩码才能用过滤器。这个函数会在文档尾部有描述

It has been my experience that this filter does not work across all operating systems. In my test environment, I found that OpenBSD 2.9 with a default kernel does support this type of filter, but FreeBSD 4.3 with a default kernel does not. Your mileage may vary.

> 根据我的经验，这个过滤器不能在所有操作系统上工作。在我的测试环境中，我发现OpenBSD 2.9与默认内核确实支持这种类型的过滤器，但FreeBSD 4.3与默认内核没有。你的可能也不同

## The actual sniffing

> 动真格


At this point we have learned how to define a device, prepare it for sniffing, and apply filters about what we should and should not sniff for. Now it is time to actually capture some packets.

> 现在，我们已经学完了如何去启动一个设备去监听，而且还会使用过滤器去过滤，现在该动真格了。


There are two main techniques for capturing packets. We can either capture a single packet at a time, or we can enter a loop that waits for n number of packets to be sniffed before being done. We will begin by looking at how to capture a single packet, then look at methods of using loops. For this we use pcap_next().

> 抓包方法有两个，我们可以在一个时间点上抓一个包就拿去分析，也可以设置一个循环来等够 n个包在去分析，我们先从单个包开始讲起，然后再讲多个包。这里需要用到函数`pcap_next()`


The prototype for `pcap_next()` is fairly simple:

> 这个函数的原型还是比较简单的

```c
u_char *pcap_next(pcap_t *p,        //会话句柄
                struct pcap_pkthdr *h)      //这个数据包的信息
//返回值就是数据包
```


The first argument is our session handler. The second argument is a pointer to a structure that holds general information about the packet, specifically the time in which it was sniffed, the length of this packet, and the length of his specific portion (incase it is fragmented, for example.) pcap_next() returns a u_char pointer to the packet that is described by this structure. We'll discuss the technique for actually reading the packet itself later.

> 这个函数原型的解释，下面是机翻
>> 第一个参数是我们的会话处理程序。第二个参数是一个指向一个结构的指针，该结构保存有关数据包的一般信息，特别是它被嗅探的时间，这个数据包的长度，以及它的特定部分的长度（例如，它被分段）。`pcap_next()`返回一个u_char指向这个结构描述的数据包的指针。我们将讨论稍后实际读取包本身的技术。

Here is a simple demonstration of using `pcap_next()` to sniff a packet.

> 示例代码,加深理解

```c
#include <pcap.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
    pcap_t *handle;         /* Session handle */
    char *dev;          /* The device to sniff on */
    char errbuf[PCAP_ERRBUF_SIZE];  /* Error string */
    struct bpf_program fp;      /* The compiled filter */
    char filter_exp[] = "port 23";  /* The filter expression */
    bpf_u_int32 mask;       /* Our netmask */
    bpf_u_int32 net;        /* Our IP */
    struct pcap_pkthdr header;  /* The header that pcap gives us */ //报文信息
    const u_char *packet;       /* The actual packet */     //报文本身

    /* Define the device */ //启动设备
    dev = pcap_lookupdev(errbuf);
    if (dev == NULL) {
        fprintf(stderr, "Couldn't find default device: %s\n", errbuf);
        return(2);
    }
    /* Find the properties for the device */    //查找设备信息
    if (pcap_lookupnet(dev, &net, &mask, errbuf) == -1) {
        fprintf(stderr, "Couldn't get netmask for device %s: %s\n", dev, errbuf);
        net = 0;
        mask = 0;
    }
    /* Open the session in promiscuous mode */  //启动嗅探会话
    handle = pcap_open_live(dev, BUFSIZ, 1, 1000, errbuf);
    if (handle == NULL) {
        fprintf(stderr, "Couldn't open device %s: %s\n", dev, errbuf);
        return(2);
    }
    /* Compile and apply the filter */      //过滤规则配置
    if (pcap_compile(handle, &fp, filter_exp, 0, net) == -1) {
        fprintf(stderr, "Couldn't parse filter %s: %s\n", filter_exp, pcap_geterr(handle));
        return(2);
    }
    if (pcap_setfilter(handle, &fp) == -1) {
        fprintf(stderr, "Couldn't install filter %s: %s\n", filter_exp, pcap_geterr(handle));
        return(2);
    }
    /* Grab a packet */     //拿到一个数据包
    packet = pcap_next(handle, &header);
    /* Print its length */      //输出数据包的长度(放在数据包信息结构体里面)
    printf("Jacked a packet with length of [%d]\n", header.len);
    /* And close the session */
    pcap_close(handle);         //关闭这次会话
    return(0);
}
```

This application sniffs on whatever device is returned by pcap_lookupdev() by putting it into promiscuous mode. It finds the first packet to come across port 23 (telnet) and tells the user the size of the packet (in bytes). Again, this program includes a new call, pcap_close(), which we will discuss later (although it really is quite self explanatory).

> 这个程序就是 启动一个混杂模式嗅探,然后抓到第一个 23号端口的的包,接着输出这个包的长度,这里有个新函数`pcap_close()`,看名字就知道是用来关闭嗅探回话的

The other technique we can use is more complicated, and probably more useful. Few sniffers (if any) actually use `pcap_next()`. More often than not, they use `pcap_loop()` or `pcap_dispatch()` (which then themselves use pcap_loop()). To understand the use of these two functions, you must understand the idea of a callback function.

> 另外一种用法就比较复杂了,但是却相当有用.很少有 嗅探(或者说没有)是用 `pcap_next()`的,更多的是用`pcap_loop()` 或 `pcap_dispatch()`(这个内部封装了`pcap_loop()), 要理解这两个函数,你必须要先理解 回调函数(callback function)


Callback functions are not anything new, and are very common in many API's. The concept behind a callback function is fairly simple. Suppose I have a program that is waiting for an event of some sort. For the purpose of this example, let's pretend that my program wants a user to press a key on the keyboard. Every time they press a key, I want to call a function which then will determine that to do. The function I am utilizing is a callback function. Every time the user presses a key, my program will call the callback function. Callbacks are used in pcap, but instead of being called when a user presses a key, they are called when pcap sniffs a packet. The two functions that one can use to define their callback is pcap_loop() and pcap_dispatch(). pcap_loop() and pcap_dispatch() are very similar in their usage of callbacks. Both of them call a callback function every time a packet is sniffed that meets our filter requirements (if any filter exists, of course. If not, then all packets that are sniffed are sent to the callback.)

> "Callback functon" 回调函数并不是什么新东西.这个在许多API上面都很常见,回调函数背后的概念相当简单。举个例子,假设我有一个程序正在等待某种事件。让我们假设我的程序希望用户按下键盘上的一个键。每次他们按下一个键，我想调用一个函数，然后会决定做。我使用的函数是回调函数。每次用户按下一个键，我的程序将调用回调函数。回调在pcap中使用，但是当用户按下一个键时，它们被调用，而不是在pcap嗅探数据包时被调用。可以用来定义回调的两个函数是`pcap_loop（）`和`pcap_dispatch（）`。 `pcap_loop（）`和`pcap_dispatch（）`在回调的使用非常相似。两者都在每次侦听到满足我们的过滤器要求的数据包时调用一个回调函数（如果存在任何过滤器，如果不存在，那么所有被嗅探的数据包都将被发送到回调）。


> #### 百度百科的解释
> > 因为可以把调用者与被调用者分开，所以调用者不关心谁是被调用者。它只需知道存在一个具有特定原型和限制条件的被调用函数。简而言之，回调函数就是允许用户把需要调用的方法的指针作为参数传递给一个函数，以便该函数在处理相似事件的时候可以灵活的使用不同的方法。

The prototype for `pcap_loop()` is below:

> 这个函数的原型是

```c
    int pcap_loop(pcap_t *p,        //会话句柄
                    int cnt,        //一次嗅探多少个包(负值表示一直嗅探,直到发送错误) 
                    pcap_handler callback,      //回调函数本身(只是函数的名字)
                    u_char *user)           //传给回调函数的参数
```
The first argument is our session handle. Following that is an integer that tells pcap_loop() how many packets it should sniff for before returning (a negative value means it should sniff until an error occurs). The third argument is the name of the callback function (just its identifier, no parentheses). The last argument is useful in some applications, but many times is simply set as NULL. Suppose we have arguments of our own that we wish to send to our callback function, in addition to the arguments that pcap_loop() sends. This is where we do it. Obviously, you must typecast to a u_char pointer to ensure the results make it there correctly; as we will see later, pcap makes use of some very interesting means of passing information in the form of a u_char pointer. After we show an example of how pcap does it, it should be obvious how to do it here. If not, consult your local C reference text, as an explanation of pointers is beyond the scope of this document. pcap_dispatch() is almost identical in usage. The only difference between pcap_dispatch() and pcap_loop() is that pcap_dispatch() will only process the first batch of packets that it receives from the system, while pcap_loop() will continue processing packets or batches of packets until the count of packets runs out. For a more in depth discussion of their differences, see the pcap man page.

> 下面是机翻:
>
>> 第一个参数是我们的会话句柄。以下是一个整数告诉`pcap_loop（）`返回前应该嗅探多少个数据包（一个负值意味着它应该侦测，直到错误发生）。第三个参数是回调函数的名称（只是它的标识符，没有括号）。最后一个参数在某些应用程序中很有用，但很多时候只是简单的设置为NULL。假设我们有自己的参数，我们希望发送到回调函数，除了`pcap_loop（）`发送的参数。这是我们做的。显然，你必须输入一个`u_char`指针，以确保结果正确;我们将在后面看到，pcap使用一些非常有趣的方式以`u_char`指针的形式传递信息。在我们展示一个pcap如何做的例子后，它应该是显而易见的如何做到这里。如果没有，请参考您的本地C参考文本，因为指针的解释超出了本文档的范围。 `pcap_dispatch（）`几乎相同的用法。` pcap_dispatch（）`和`pcap_loop（）`之间的唯一区别是，`pcap_dispatch（）`将只处理从系统接收的第一批数据包，而`pcap_loop（）`将继续处理数据包或批数据包，直到数据包计数结束。有关其差异的更深入讨论，请参阅pcap手册页。

Before we can provide an example of using pcap_loop(), we must examine the format of our callback function. We cannot arbitrarily define our callback's prototype; otherwise, pcap_loop() would not know how to use the function. So we use this format as the prototype for our callback function:

> 在我们提供一个 `pcap_loop()` 之前,我们必须检查我们回调函数的格式.回调函数的原型不能随便定义,不然 `pcap_loop()` 将无法使用

```c
    void got_packet(u_char *args,       // `pcap_loop()` 的最后一个参数，传参用
                    const struct pcap_pkthdr *header,
                    const u_char *packet);
```

Let's examine this in more detail. First, you'll notice that the function has a void return type. This is logical, because pcap_loop() wouldn't know how to handle a return value anyway. The first argument corresponds to the last argument of pcap_loop(). Whatever value is passed as the last argument to pcap_loop() is passed to the first argument of our callback function every time the function is called. The second argument is the pcap header, which contains information about when the packet was sniffed, how large it is, etc. The pcap_pkthdr structure is defined in pcap.h as:

> 让我细细道来,首先你看到这是一个void返回的函数。这也很合理，毕竟`pcap_loop()`也不知道怎么处理你的返回值。第一个参数就是`pcap_loop()`的最后一个参数（可以理解为如果我们要给回调函数传参数，那么就直接传给调用他的 `pcap_loop()` 最后一个参数就行了。第二个参数是pcap 的头部，里面包含了数据包何时被嗅探的信息，以及数据包的大小
>
> 回调函数一般是自己编写对抓到的数据包进行处理的函数

> `pcap_pkthdr`结构体长成这样

```c
struct pcap_pkthdr {
    struct timeval ts; /* time stamp */
    bpf_u_int32 caplen; /* length of portion present */
    bpf_u_int32 len; /* length this packet (off wire) */
};
```

These values should be fairly self explanatory. The last argument is the most interesting of them all, and the most confusing to the average novice pcap programmer. It is another pointer to a u_char, and it points to the first byte of a chunk of data containing the entire packet, as sniffed by pcap_loop().

> 这些变量的作用就和名字一样。最后一个比其他的都有用，一般会感到混乱的都是新手，它是指向u_char的另一个指针，它指向包含整个数据包的数据块的第一个字节，如`pcap_loop（）`所嗅探。


But how do you make use of this variable (named "packet" in our prototype)? A packet contains many attributes, so as you can imagine, it is not really a string, but actually a collection of structures (for instance, a TCP/IP packet would have an Ethernet header, an IP header, a TCP header, and lastly, the packet's payload). This u_char pointer points to the serialized version of these structures. To make any use of it, we must do some interesting typecasting.

> 但是如何使用这个变量（在我们的原型中命名为“packet”）？一个包包含许多属性，所以你可以想象，它不是一个真正的字符串，但实际上是一个结构的集合（例如，TCP / IP包将有一个以太网头，IP头，TCP头，最后，分组的有效载荷）。这个u_char指针指向这些结构的序列化版本。要使用它，我们必须做一些有趣的类型转换。


First, we must have the actual structures define before we can typecast to them. The following are the structure definitions that I use to describe a TCP/IP packet over Ethernet.

> 首先，我们必须先定义实际结构，然后才能将其转换为它们。以下是我用来描述基于以太网的TCP / IP数据包的结构定义。

```c
/* Ethernet addresses are 6 bytes */
#define ETHER_ADDR_LEN  6

    /* Ethernet header */   //以太网头部
    struct sniff_ethernet {
        u_char ether_dhost[ETHER_ADDR_LEN]; /* Destination host address */  //目标主机地址
        u_char ether_shost[ETHER_ADDR_LEN]; /* Source host address */   //源主机地址
        u_short ether_type; /* IP? ARP? RARP? etc */    //IP? ARP? RARP?....
    };

    /* IP header */
    struct sniff_ip {
        u_char ip_vhl;      /* version << 4 | header length >> 2 */
        u_char ip_tos;      /* type of service */ //服务类型
        u_short ip_len;     /* total length */  //总长度
        u_short ip_id;      /* identification */    //身份
        u_short ip_off;     /* fragment offset field */     //片段偏移字段
    #define IP_RF 0x8000        /* reserved fragment flag */    //保留片段标志
    #define IP_DF 0x4000        /* dont fragment flag */    // 没有碎片标志
    #define IP_MF 0x2000        /* more fragments flag */   // 更多碎片标志
    #define IP_OFFMASK 0x1fff   /* mask for fragmenting bits */ //分片位掩码
        u_char ip_ttl;      /* time to live */      //存活时间
        u_char ip_p;        /* protocol */          //协议
        u_short ip_sum;     /* checksum */      //校验和
        struct in_addr ip_src,ip_dst; /* source and dest address */     //源地址
    };
    #define IP_HL(ip)       (((ip)->ip_vhl) & 0x0f)
    #define IP_V(ip)        (((ip)->ip_vhl) >> 4)

    /* TCP header */        //TCP头部
    typedef u_int tcp_seq;

    struct sniff_tcp {
        u_short th_sport;   /* source port */       //源端口
        u_short th_dport;   /* destination port */  //目标端口
        tcp_seq th_seq;     /* sequence number */   //数据报文序列号
        tcp_seq th_ack;     /* acknowledgement number */    //确认号
        u_char th_offx2;    /* data offset, rsvd */     //数据偏移量
    #define TH_OFF(th)  (((th)->th_offx2 & 0xf0) >> 4)
        u_char th_flags;
    #define TH_FIN 0x01
    #define TH_SYN 0x02
    #define TH_RST 0x04
    #define TH_PUSH 0x08
    #define TH_ACK 0x10
    #define TH_URG 0x20
    #define TH_ECE 0x40
    #define TH_CWR 0x80
    #define TH_FLAGS (TH_FIN|TH_SYN|TH_RST|TH_ACK|TH_URG|TH_ECE|TH_CWR)
        u_short th_win;     /* window */        //窗口
        u_short th_sum;     /* checksum */      //校验和
        u_short th_urp;     /* urgent pointer */    //紧急指针
};

```


So how does all of this relate to pcap and our mysterious u_char pointer? Well, those structures define the headers that appear in the data for the packet. So how can we break it apart? Be prepared to witness one of the most practical uses of pointers (for all of those new C programmers who insist that pointers are useless, I smite you).

> 所以这是如何与pcap和我们的神秘u_char指针相关？那么，那些结构定义出现在数据包的数据中的头。那么我们如何才能分开呢？准备见证指针的最实际用途之一（对于所有那些坚持指针是无用的新C程序员，我能说，我能打人吗）。

Again, we're going to assume that we are dealing with a TCP/IP packet over Ethernet. This same technique applies to any packet; the only difference is the structure types that you actually use. So let's begin by defining the variables and compile-time definitions we will need to deconstruct the packet data.

> 再次，我们将假设我们正在处理通过以太网的TCP / IP数据包。这种相同的技术适用于任何分组;唯一的区别是您实际使用的结构类型。因此，让我们开始定义解构数据包数据所需的变量和编译时定义。

```c
/* ethernet headers are always exactly 14 bytes */
#define SIZE_ETHERNET 14

const struct sniff_ethernet *ethernet; /* The ethernet header */    //以太网头部
const struct sniff_ip *ip; /* The IP header */      //IP头部
const struct sniff_tcp *tcp; /* The TCP header */   //TCP头部
const char *payload; /* Packet payload */           //数据包有效载荷

u_int size_ip;
u_int size_tcp;
```

And now we do our magical typecasting:

> 然后 使用魔法 进行类型转换

```c
ethernet = (struct sniff_ethernet*)(packet);        //先类型强转
ip = (struct sniff_ip*)(packet + SIZE_ETHERNET);    //然后通过指针偏移的方法
size_ip = IP_HL(ip)*4;                  //指针偏移
if (size_ip < 20) {
    printf("   * Invalid IP header length: %u bytes\n", size_ip);
    return;
}
tcp = (struct sniff_tcp*)(packet + SIZE_ETHERNET + size_ip);
size_tcp = TH_OFF(tcp)*4;       //指针偏移
if (size_tcp < 20) {
    printf("   * Invalid TCP header length: %u bytes\n", size_tcp);
    return;
}
payload = (u_char *)(packet + SIZE_ETHERNET + size_ip + size_tcp);

```

How does this work? Consider the layout of the packet data in memory. The u_char pointer is really just a variable containing an address in memory. That's what a pointer is; it points to a location in memory.

> 这个怎么用？考虑分组数据在存储器中的布局。 u_char指针实际上只是一个包含内存地址的变量。这是一个指针;它指向内存中的位置。

For the sake of simplicity, we'll say that the address this pointer is set to is the value X. Well, if our three structures are just sitting in line, the first of them (sniff_ethernet) being located in memory at the address X, then we can easily find the address of the structure after it; that address is X plus the length of the Ethernet header, which is 14, or SIZE_ETHERNET.

> 为了简单起见，我们会说这个指针设置的地址是值X.如果我们的三个结构只是排成行，第一个（sniff_ethernet）位于内存中的地址X ，那么我们可以很容易找到结构的地址后面;该地址为X加上以太网头的长度，即14，或SIZE_ETHERNET。

Similarly if we have the address of that header, the address of the structure after it is the address of that header plus the length of that header. The IP header, unlike the Ethernet header, does not have a fixed length; its length is given, as a count of 4-byte words, by the header length field of the IP header. As it's a count of 4-byte words, it must be multiplied by 4 to give the size in bytes. The minimum length of that header is 20 bytes.

> 类似地，如果我们有该报头的地址，则其后的结构的地址是该报头的地址加上该报头的长度。 IP报头与以太网报头不同，没有固定长度;其长度作为4字节字的计数由IP报头的报头长度字段给出。因为它是4字节字的计数，所以必须乘以4以给出字节大小。该标题的最小长度为20字节。

The TCP header also has a variable length; its length is given, as a number of 4-byte words, by the "data offset" field of the TCP header, and its minimum length is also 20 bytes.

> TCP报头也有可变长度;其长度作为4字节字的数量由TCP报头的“数据偏移”字段给出，并且其最小长度也是20字节。

So let's make a chart:

> 让我们绘个图

|Variable|    Location (in bytes)|
|----|----|
|sniff_ethernet|  X|
|sniff_ip |   X + SIZE_ETHERNET|
|sniff_tcp  | X + SIZE_ETHERNET + {IP header length}|
|payload | X + SIZE_ETHERNET + {IP header length} + {TCP header length}|


The sniff_ethernet structure, being the first in line, is simply at location X. sniff_ip, who follows directly after sniff_ethernet, is at the location X, plus however much space the Ethernet header consumes (14 bytes, or SIZE_ETHERNET). sniff_tcp is after both sniff_ip and sniff_ethernet, so it is location at X plus the sizes of the Ethernet and IP headers (14 bytes, and 4 times the IP header length, respectively). Lastly, the payload (which doesn't have a single structure corresponding to it, as its contents depends on the protocol being used atop TCP) is located after all of them.

> sniff_ethernet结构是第一个在位置X。sniff_ip直接在sniff_ethernet之后，位于位置X，加上以太网报头消耗的空间（14字节或SIZE_ETHERNET）。 sniff_tcp在sniff_ip和sniff_ethernet之后，所以它的位置在X加上以太网和IP头的大小（14个字节，分别是IP头长度的4倍）。最后，有效载荷（其不具有对应于其的单个结构，因为其内容取决于在TCP顶上使用的协议）位于所有这些之后。

So at this point, we know how to set our callback function, call it, and find out the attributes about the packet that has been sniffed. It's now the time you have been waiting for: writing a useful packet sniffer. Because of the length of the source code, I'm not going to include it in the body of this document. Simply download sniffex.c and try it out.

> 所以在这一点上，我们知道如何设置我们的回调函数，调用它，并找出关于已被嗅探的数据包的属性。现在是你一直在等待的时间：写一个有用的数据包嗅探器。由于源代码的长度，我不会将其包括在本文档的正文中。只需下载sniffex.c(http://www.tcpdump.org/sniffex.c)并试试看。

## Wrapping Up

At this point you should be able to write a sniffer using pcap. You have learned the basic concepts behind opening a pcap session, learning general attributes about it, sniffing packets, applying filters, and using callbacks. Now it's time to get out there and sniff those wires!

> 在这一点上，你应该能够使用pcap写一个嗅探器。您已经了解了打开pcap会话，学习其常规属性，嗅探数据包，应用过滤器和使用回调的基本概念。现在是时候出去，闻闻那些电线！

This document is Copyright 2002 Tim Carstens. All rights reserved. Redistribution and use, with or without modification, are permitted provided that the following conditions are met:

> 本文件是版权所有2002 Tim Carstens。版权所有。如果满足以下条件，则允许重新分发和使用（有或无修改）：

1. Redistribution must retain the above copyright notice and this list of conditions.
2. The name of Tim Carstens may not be used to endorse or promote products derived from this document without specific prior written permission.

> 1.再分发必须保留上述版权声明和此条件列表
>
> 2.在未经事先书面许可的情况下，Tim Carstens的名称不得用于支持或宣传本文档中的产品。
>
/* Insert 'wh00t' for the BSD license here */

> 在此处插入'wh00t'作为BSD许可证

*******


> 译者： 胡雄钦
>
> 这个文档是本人学习时候遇到了问题查到的文档，顺便在学习过程中翻译了一下，版权归原作者所有
>
> 里面许多无关紧要的细节部分使用了机翻，所以发现有错误的话，可以自行修改
>
> Translator: 胡雄钦（Hu.xiongqin)
>
> I found this document in the course of my study，and translated it during learning，The copyright belongs to the original author
>
> Many of the insignificant details of the use of the Google translation, so that there are errors, you can modify
