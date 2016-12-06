# 通道过程

1. 数据写进缓冲区
2. 缓冲区写到通道中
3. 对方从通道获取数据
4. 对方用同样的过程吧数据发回来

# 通道基础

## Channel接口

```java
package java.nio.channels;

public interface channels
{
  public boolean isOpen();    //是否打开
  public void close() throw IOException;    //关闭一个打开的通道
}
```

Channel接口本身没什么，有趣的是他的子接口类

通道只能在字节缓冲区上操作


## 打开通道

通道是访问IO服务的导管。I/O大概可以分为两大类 FileIO 和StreamIO。

* 面向文件 `FileChannel`
* 面向流
 + `SocketChannel` TCP客户机
 + `ServerSocketChannel` TCP服务器
 + `DatagramChannel`    UDP

通道创建方式有很多种
* `SocketChannel`可以直接创建新`SocketChannel`的方法创建
* `FileChannel`只能在一个打开的`RandomAccessFile、FileInputStream 或 FileOutputStream`
对象上调用 `getChannel()`


```java
//SocketChannel 直接创建
SocketChannel sc = SocketChannel.open();
sc.connect(new InterSocketAddress("somehost",someport));

ServerSocketChannel ssc = ServerSocketChannel.open();
ssc.socket().bind(new InetSocketAddress(somelocalport));

DatagramChannel dc = DatagramChannel.open();



RandomAccessFile raf = new RandomAccessFile("somefile","r");
FileChannel fc = raf.getChannel();
```

## 使用通道

通道只能和`ByteBuffer`对象或从`ByteBuffer`中获取数据进行传输

### 子接口

```java
//单向读
public interface ReadableByteChannel extends Channel
{
  public int read(ByteBuffer dst) throws IOException;
}

//单向写
public interface WritableByteChannel extends Channel
{
  public int write (ByteBuffer src) throws IOException;
}

//两个都实现，那就双向
public interface ByteChannel extends ReadableByteChannel, WritableByteChannel
{
}
```

通道可以使单向的，也可以是双向的，具体看改Channel类实现了哪个接口（两个都实现了那就是双向）


`ByteChannel` 的 `read( )` 和 `write( )`方法使用 `ByteBuffer` 对象作为参数。两种方法均返回已传输的
字节数,可能比缓冲区的字节数少甚至可能为零。缓冲区的位置也会发生与已传输字节相同数量的
前移。如果只进行了部分传输,缓冲区可以被重新提交给通道并从上次中断的地方继续传输。该过
程重复进行直到缓冲区的 `hasRemaining( )`方法返回 `false` 值。

<a herf="#channelcopy" name="copy">示例代码：从一个通道复制数据到另外一个通道</a>


## 通道关闭

与缓冲区不同，通道不能重复使用，通道代表了

通道代表的是一种特定的I/O服务连接。当通道关闭，连接就会丢失，然后通道就不会有任何东西

```java
package java.nio.channels;
public interface Channel
{
    public boolean isOpen( );   //检测通道是否开放
    public void close( ) throws IOException;    //关闭通道
}
```

> 调用通道的`close()`方法时,可能会导致在通道关闭底层I/O服务的过程中线程暂时阻塞 ,哪怕该通道处于非阻塞模式。通道关闭时的阻塞行为(如果有的话)是高度取决于操作系统或者文件系统的。
>
> 在一个通道上多次调用`close()`方法是没有坏处的,但是如果第一个线程在`close()`方法中阻塞,那么在它完成关闭通道之前,任何其他调用`close()`方法都会阻塞。后续在该已关闭的通道上调用`close()`不会产生任何操作,只会立即返回










***

# 示例代码

## Channel 的复制

<a name="channelcopy" herf="#copy">返回</a>

```java
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;

public class ChannelCopy {
    /**
     * 类似cat命令那样的功能
     */
    public static void main(String[] args) throws IOException{
        ReadableByteChannel source = Channels.newChannel(System.in);
        WritableByteChannel dest = Channels.newChannel(System.out);
        channelCopy2(source,dest);

        //alternatively, call channelCopy2 (source,dest);
        source.close();
        dest.close();
    }

    /**
     * Channel copy method 1. This method copies data from the src
     * channel and writes it to the dest channel until EOF on src.
     * This implementation makes use of compact( ) on the temp buffer
     * to pack down the data if the buffer wasn't fully drained. This
     * may result in data copying, but minimizes system calls. It also
     * requires a cleanup loop to make sure all the data gets sent.
     */

    private static void channelCopy1(ReadableByteChannel src,
                                     WritableByteChannel dest)
            throws IOException
    {
        ByteBuffer buffer = ByteBuffer.allocateDirect(16*1024);
        while(src.read(buffer) != -1){
            //让buffer进入读取准备状态
            buffer.flip();
            //写入
            dest.write(buffer);
            // If partial transfer, shift remainder down
            // If buffer is empty, same as doing clear( )

            //让buffer清理已经写入的数据
            buffer.compact();
        }

        //虽然接收到EOF了，但是可能没有把buffer内容都输出到dest中

        buffer.flip();

        //确保部分尾巴写入dest中

        while(buffer.hasRemaining()) {
            dest.write(buffer);
        }
    }

    /**
     * Channel copy method 2. This method performs the same copy, but
     * assures the temp buffer is empty before reading more data. This
     * never requires data copying but may result in more systems calls.
     * No post-loop cleanup is needed because the buffer will be empty
     * when the loop is exited.
     */

    private static void channelCopy2(ReadableByteChannel src,
                                     WritableByteChannel dest)
        throws IOException
    {
        ByteBuffer buffer = ByteBuffer.allocateDirect(16 * 1024);
        while (src.read(buffer) != -1) {
            //Prepare the buffer to be drained
            buffer.flip();
            //Make sure that the buffer was fully drained
            while(buffer.hasRemaining()){
                dest.write(buffer);
            }

            //通过清空缓冲区方法，把没写入的数据写入
            buffer.clear();
        }
    }
}
```

***
