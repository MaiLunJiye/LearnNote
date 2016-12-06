# Buffer 类

Buffer是缓冲区类

```java
package java.nio;
public abstract class Buffer {
    public final int capacity( )    //容量
    public final int position( )    //下一个要被读取的元素的下标
    public final Buffer position (int newPosition)
    public final int limit( )
    public final Buffer limit (int newLimit)
    public final Buffer mark( )     //标记
    public final Buffer reset( )
    public final Buffer clear( )
    public final Buffer flip( )
    public final Buffer rewind( )
    public final int remaining( )
    public final boolean hasRemaining( )
    public abstract boolean isReadOnly( );      //是否只读
}
```

