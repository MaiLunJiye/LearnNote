# 简明版Pcap编程

## 基本步骤

1. 定义一个网卡开始监听
2. 初始化pcap（也就是取得会话句柄）
3. 设置过滤规则（先用一个函数编译成过滤结构体）
4. 通过回调函数用自己的函数处理数据包
5. 嗅探完毕后关闭会话，嗅探完成

> 使用gcc 或 g++ 编译命令需要添加参数 -lpcap


```cpp
#include <pcap.h>
#include <stdio.h>
#include <iostream>

using namespace std;

void processPacket(u_char *arg, const struct pcap_pkthdr *pkthdr,const u_char *packet) {
    //....自己的处理函数，其中， packet 就是数据包
    // pacp_pkthdr 就是数据包信息的结构体， 
    //arg 是 pcap_loop() 的第一个参数
}

int main(int argc, char *argv[])
{
    int i=0,count = 0;
    pcap_t *handle;        /* 会话句柄  */
    char *dev;        /*将要启动嗅探的设备名字 */
    char errbuf[PCAP_ERRBUF_SIZE]; /* 错误存放的地方 */
    struct bpf_program fp;     /*过滤规则结构体*/
    char filter_exp[] = "port 554"; /*过滤规则，554号端口是视频直播服务端口*/
    bpf_u_int32 mask;      /*掩码（嗅探设备能用的）*/
    bpf_u_int32 net;       /*设备ip*/

    if(argc>1) dev=argv[1];       //先设定嗅探设备的名字（命令行传参）
    else 
    {
        fprintf(stderr,"usage %s dev_name\n",argv[0]);
        return -1;
    }

    //获取对应设备的ip地址，掩码（后面设置规则结构体需要）
    if (pcap_lookupnet(dev, &net, &mask, errbuf) == -1) {
        fprintf(stderr, "Can't get netmask for device %s\n", dev);
        net = 0;
        mask = 0;
    }

    //获取会话句柄
    handle = pcap_open_live(dev, BUFSIZ, 0, 1000, errbuf);
    if (handle == NULL) {
        fprintf(stderr, "Couldn't open device %s: %s\n", dev, errbuf);
        return(2);
    }

    //配置 规则结构体
    if (pcap_compile(handle, &fp, filter_exp, 0, net) == -1) {
        fprintf(stderr, "Couldn't parse filter %s: %s\n", filter_exp, pcap_geterr(handle));
        return(2);
    }

    //调用pcap_loop  对抓到的数据包进行操作，其中 processPacket函数是回调函数
    //arg 是传给 processPacket 函数的 参数
    pcap_loop(handle, -1, processPacket,(u_char *)&arg);

    pcap_close(handle);     //关闭会话句柄

    return 0;
}
```

## 定义网卡，开始嗅探

一般是需要网卡名字，通过 `ifconfig` 来查看网卡名字，选择一个网卡


```c
pcap_t *pcap_open_live(char *device,        //上面指定嗅探的设备 
                    int snaplen,            //pcap抓取的最大字节数
                    int promisc,            //是否选择混杂模式（ture为是）（就算是假，在特性模式也可能是混杂模式）
                    int to_ms,              //设置超时（毫秒，0表示没有超时）
                    char *ebuf)             //存放错误信息的char[]
//返回值： 会话句柄
```

### 检查是否支持以太网头部

```c
if (pcap_datalink(handle) != DLT_EN10MB) {
        fprintf(stderr, "Device %s doesn't provide Ethernet headers - not supported\n", dev);
    return(2);
}
```

如果返回失败，说明并不支持以太网头部

## 过滤规则

过滤规则对于人而言是一串文字（这个自己查语法），对于pcap，需要一个函数去吧这个窜文字转化成一个结构体，pcap只能使用这种结构体来进行过滤


```c
int pcap_compile(pcap_t *p,                 //要进行过滤操作的会话句柄
                struct bpf_program *fp,     //配置结构体，配置完成后这个结构体就是代表规则
                char *str,                  //过滤规则表达式（一串字符） 
                int optimize,               //是否是被优化（0=false，1=true） 
                bpf_u_int32 netmask)        //那个句柄对应设备的，子网掩码（要提前用 pcap_lookupnet获得）

// 函数返回-1表示失败，其他返回值表示成功
```

获得掩码

```c
pcap_lookupnet(char *dev,           //设备名字
               bpf_u_int32 *net,     // 装ip地址的地方
               bpf_u_int32 *mask,   //  装掩码的地方
                errbuf)             // 错误存放区
//返回0 成功， -1 失败
```

使用

```c
int pcap_setfilter(pcap_t *p,           //要应用这个规则的会话
                    struct bpf_program *fp)     //规则配置好的规则结构体
```

## 处理数据包

```c
    int pcap_loop(pcap_t *p,        //会话句柄
                    int cnt,        //一次嗅探多少个包(负值表示一直嗅探,直到发送错误) 
                    pcap_handler callback,      //回调函数本身(只是函数的名字)
                    u_char *user)           //传给回调函数的参数
```

回调函数的原型必须这样，否则就无法使用,名字可以随意

```c
    void call_back(u_char *args,       // `pcap_loop()` 的最后一个参数，传参用
                    const struct pcap_pkthdr *pkthdr,   //数据包结构体
                    const u_char *packet);          //数据包本身
```



> `pcap_pkthdr`结构体长成这样

```c
struct pcap_pkthdr {
    struct timeval ts; /* time stamp */
    bpf_u_int32 caplen; /* length of portion present */
    bpf_u_int32 len; /* length this packet (off wire) */
};
```




