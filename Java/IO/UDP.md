# Java 的UDP

## 类似C，
套接字用的是   `DatagramSocket` 但是Java的UDP 规定了数据包类型`DatagramPacket dp`

## 申请一个UDP套接字 DatagramSocket

构造函数 (下面不全，具体看文档）

```java
DatagramSocket()  throws  SocketException
```

创建UDP套接字，并随机绑定端口，随机IP

```java
DatagramSocket( int port ) throws SocketException
```

创建一个UDP套接字，并且绑定 指定端口（port）


## 发送数据包类DatagramPacket

构造方法：首先，有个 写有数据的  byte[]	数组，然后：

```java
DatagramPacket( byte[]  buf, int  offset,  int  length )
```
创建一个UDP数据包，
从字节数组 `buf` 的 `offset`位开始读起，往后读`length

```java
DatagramPacket( byte[]  buf, int  length,  InetAddress  address, int  port )
```

1. 创建一个UDP数据包
2. 读取 字节数组buf的  length长
3. 同时写上 接收方的  地址和端口

具体写法：

```java
DatagramPacket( buf， buf.length, new InetAddress("127.0.0.1"), 4567 );
```

### 发送接受

* 套接字.send( 数据包 ）
* 套接字.receive( 数据包 ）

read到的东西会存放到数据包中

数据封装和解封

由于数据包 生成时候就规定了 是以 字节数组的形式存在.但是 数据包的封装实际上是基于  传进去的  buf的.
可以用IO流对   buf进行  封装和解封

# 例子

```java
byte buf[]  =  new byte[1024];
String message = new String("即将封装的内容" );

ByteArrayOutputStream  baos = new ByteArrayOutputStream();
DataOutputStream  dos = new DataOutputStream( baos );
dos.writeString( n );

byte[] buf = baos.toByteArray();

DatagramPacket  dp = new DatagramPacket( buf,  buf.length, new  InetSocketAddress("2.2.2.2"),7944);

```

```java
byte buf[] = new byte[1024];
DatagramPacket  dp = new DatagramPacket( buf, buf.length );

DatagramSocket  ds = new DatagramSocket(7944);
ds.receive(dp);

ByteArrayInputStream  bais  =  new  ByteArrayInputStream( buf );
DataInputStream  dis  =  new  DataInputStream( bais );
System.out.println(  dis.readLong() );
```

解封完成

