# 前言

全部 socket 通道类`(DatagramChannel、SocketChannel 和 ServerSocketChannel)`在被实例化时都会创建一个对等 socket 对象

对等的socket可以通过`socket()` 方法从一个通道上获取

此外,这三个 `java.net` 类现在都有`getChannel()`方法

虽然每个`socket`通道`(java.nio.channnels)`都有一个关联的`java.net socket`对象,但是,如果**通过传统模式(直接实例化)创建的Socket对象是不会有SocketChannel的**, `getChannel()`返回值是`null`


## 非阻塞模式

Socket通道可以实现非阻塞模式下运行

非阻塞依赖socket通道类的公有超级类

`SelectableChannel`

```java
public abstract class SelectableChannel
    extends AbstractChannel
    implements Channel
{
    //设置是否阻塞模式(ture阻塞)
    public abstract void configureBlocking(boolean block)
        throws IOException;

    //查看通道是否阻塞模式
    public abstract boolean isBlocking();

    //设置阻塞模式锁定,防止其他进程乱修改状态
    public abstract Object blockingLock();
}
```

有条件的选择(readiness selection),是一种可以用来查询通道的机制,这个机制可以判断通道是否准备好执行一个目标操作(读写).这个和非阻塞通信紧密相关

设置是非阻塞模式,只需要执行 `configureBlocking(false)` 就可以(ture为阻塞)


# socket通道类

## ServerSocketChannel

API :

```java
public abstract class ServerSocketChannel
    extends AbstractSelectableChannel
{
    //创建一个新的ServerSocketChannel对象,将返回一个没被绑定的 java.net.ServerSocket,关联的通道
    public static ServerSocketChannel open() throws IOException;

    //返回关联的ServerSocket
    public abstract ServerSocket socket();

    //类似ServerSocket 的 accept方法,但是不会阻塞
    public abstract ServerSocket accept() throws IOException;
    public final int validOps();
}
```

关联的 socket 关联的 SocketImpl 能识别通道。通道不能被封装在随意的 socket 对象外面

ServerSocketChannel 没有 `bind()` 方法,只能通过 `socket()`来执行 `bind()`方法对端口进行监听

```java
ServerSocketChannel ssc = ServerSocketChannel.open();
ServerSocket ssocket = ssc.socket();

//监听
ssocket.bind( new InetSocketAddress(1234));
```

如果调用ServerSocket的`accept()`将会如同以前一样,阻塞,然后返回一个交互的socket对象,如果调用的是ServerSocketChannel的`accept()`,将会返回SocketChannel类型的对象.返回的对象能够在非阻塞模式下运行.

如果以非阻塞模式被调用,当没有传入连接在等待时,ServerSocketChannel.accept( )会立即返回 null。正是这种检查连接而不阻塞的能力实现了可伸缩性并降低了复杂性。可选择性也因此得到实现。我们可以使用一个选择器实例来注册一个 ServerSocketChannel 对象以实现新连接到达时自动通知的功能

<a href="#Serversocket" name="Server">非阻塞示例代码</a>

## SocketChannel

这个使用比较多

API

```java
public abstract class SocketChannel
    extends AbstractSelectableChannel
    implements ByteChannel,
            ScatteringByteChannel,
            GatheringByteChannel
{
    public static SocketChannel open( ) throws Exception
    public static SocketChannel open (InetSocketAddress remote)
        throws IOException;

    public abstract Socket socket( );

    //非阻塞的connect
    public abstract boolean connect (SocketAddress remote)
        throws IOException;

    //当前是否处于 正在建立连接过程中
    public abstract boolean isConnectionPending( );

    //检查连接是否完成,是否可用
    public abstract boolean finishConnect( ) throws IOException;


    public abstract boolean isConnected( );
    public final int validOps( )
}
```


* 每个 SocketChannel 对象创建时都是同一个对等的 `java.net.Socket` 对象串联的。静态的 `open( )`方法可以创建一个新的 `SocketChannel` 对象
* 而在新创建的 `SocketChannel` 上调用 `socket( )`方法能返回它对等的 `Socket` 对象
 + 在该 `Socket` 上调用 `getChannel( )`方法则能返回最初的那个 `SocketChannel`
* 同样,直接创建的Socket是没有SocketChannle的

带`InetSocketAddress`的`open()`是在返回之前进行的便捷方法(创建时候顺便连接服务器)

```java
SocketChannel sc = SocketChannel.open(new InetSocketAddress("127.0.0.1",8888);

SocketChannel sc = SocketChannel.open();
sc.connect(new InetSocketAddress("127.0.0.1",8888));
```

如果使用了传统的`connect()`那么Socket将会陷入阻塞状态,但是用SocketChannel的`connect()`建立通道则处于非阻塞模式(默认模式)

非阻塞模式的`connect()`过程

1. 向服务器发起连接请求,并且立刻返回值
2. `connect()`返回ture那么就建立连接(可能是本地还回连接)
3. 如果不能建立,`connect()`就返回false,并且并发地继续继续连接建立过程


面向流的的 socket 建立连接状态需要一定的时间,因为两个待连接系统之间必须进行包对话以建立维护流 socket 所需的状态信息。跨越开放互联网连接到远程系统会特别耗时。假如某个SocketChannel 上当前正有一个并发连接,`isConnectPending( )`方法就会返回 true 值。

### finishConnect()

调用 `finishConnect()`方法来完成连接过程,该方法任何时候都可以安全地进行调用。假如在一个非阻塞模式的 SocketChannel 对象上调用 `finishConnect()`方法,将可能出现下列情形之一:

* `connect()`没被调用,产生`NoConnectionPendingException` 异常
* 连接建立过程正在进行,尚未完成。那么什么都不会发生,finishConnect( )方法会立即返回`false` 值。
* 在非阻塞模式下调用 `connect( )`方法之后,SocketChannel 又被切换回了阻塞模式。那么如果有必要的话,调用线程会阻塞直到连接建立完成,`finishConnect( )`方法接着就会返回 true值。
* 在初次调用 `connect( )`或最后一次调用 `finishConnect( )`之后,连接建立过程已经完成。那么SocketChannel 对象的内部状态将被更新到已连接状态,`finishConnect( )`方法会返回 true值,然后 SocketChannel 对象就可以被用来传输数据了
* 连接已经建立。那么什么都不会发生,`finishConnect( )`方法会返回 true 值


**当通道处于中间的连接等待(connection-pending)状态时,您只可以调用 `finishConnect( )`、`isConnectPending( )`或 `isConnected( )`方法。一旦连接建立过程成功完成,`isConnected( )`将返回 true值**


具体用法

```java
InetSocketAddress addr = new InetSocketAddress(host,port);
SocketChannel sc = SocketChannel.open();
sc.configureBlocking(false);
sc.connect(addr);

while(!sc.finishConnect()){ //一直检查,是否连接上
    doSomethingElse();      //等待过程中做些自己的事情
}

doSomethingWithChannel(sc); //连接成功,可以开始通信
sc.close();
```


<a herf="SocketChannel" name="#Socket">非阻塞socket示例代码</a>

***

# 示例代码

## 非阻塞ServerSocketChannel的`accept()`

<a name="Serversocket" herf="#Server">返回</a>

```java
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;

public class ChannelAccept {
    public static final String GREETING = "Hello I must be going.\n";

    public static void main(String[] args) throws Exception {
        int port = 8888;      //默认端口
        if(args.length > 0){
            port = Integer.parseInt(args[0]);   //端口赋值(字符串变int)
        }

        //数据输入
        ByteBuffer buffer= ByteBuffer.wrap(GREETING.getBytes());
        
        //新建一个ServerSocketChannel,并绑定
        ServerSocketChannel ssc = ServerSocketChannel.open();
        ssc.socket().bind(new InetSocketAddress(port));     //通过关联的socket绑定
        ssc.configureBlocking(false);       //非阻塞模式
        
        while(true){
            System.out.println("Waiting for connections");
            SocketChannel sc = ssc.accept();
            
            if(sc == null){
                //没有连接请求, 系统休眠一会儿
                Thread.sleep(20000);
            }else{
                System.out.println("Incoming connection from:"+
                                    sc.socket().getRemoteSocketAddress());
                buffer.rewind();
                sc.write(buffer);
                sc.close();
            }
        }
    }
}

```

***

## 非阻塞socket通信

<a name="#SocketChannel" herf="Socket">返回</a>

> 搭配上面那个一起使用

```java
import java.net.InetSocketAddress;
import java.nio.channels.SocketChannel;

public class ConnectAsync {
    public static void main(String[] args) throws Exception {
        //服务器和目标端口的默认设置
        String host = "localhost";
        int port = 8888;
        if(args.length == 2){
            host = args[0];
            port = Integer.parseInt(args[1]);
        }

        InetSocketAddress addr = new InetSocketAddress(host,port);
        SocketChannel sc = SocketChannel.open();
        sc.configureBlocking(false);    //非阻塞模式

        System.out.println("initiating connecting");
        sc.connect(addr);

        while(!sc.finishConnect()){     //后台一直连接着,等待连接成功
            doSomethingUseful();
        }

        //循环跳出,连接完成
        System.out.println("connecting established");
        

        sc.close();

    }

    private static void doSomethingUseful()
    {
        System.out.println("doing something useless");
    }
}
```

***





