# 切片

## 列表切片


**定义**：把列表当作数组(list slice)


对于一些类似存储字段的数据

    fred flintstone:2168:301: Cobblestone Way:555-21100:555-2121:3
    
每个字段都是通过冒号分隔开，如果要把里面的数据单独提取，一般使用`split`

```perl
my ($name, $card_num, $addr, $home, $work, $count) = split /:/,$date;
```

如果单纯是想提取里面的某几项，而不是全部，上面的写法会比较浪费空间（因为不用提取的项都要为他定义一个标量存放）


不需要提取的项可以用`undef`来占位

```perl
my ($name, undef, $addr, undef,undef, $count) = split /:/,$date;
    # 只提取了 $name,$addr,$count, 而且没有开辟多余的空间，undef只是用来占位
```

当`undef`很多的时候，就很容易出错，因为写错一个，后面就全错位了


于是，perl是可以吧列表当作数组的，通过下标获得对应的值

```perl
my $mtime = (stat $some_file)[9];       # 括号是 强制在列表上下文中使用
my $mtime = stat ($somefile)[9];       # 错，这个括号被解析为 stat函数调用括号
                    # 通过下标直接取得对应的值
                    
my ($card_num, $count) = (split /:/$date)[1,5];     # 可以指定多个下标

my ($first, $last) = (split /:/$date)[0,-1];        # 第一个下标是0， 最后一个是-1（倒数第一个）

my @getEle = (@array)[9, 0, 2, 1, 0];       
        # 下标是可以重复的，乱序的， 结果也会按照你给的顺序赋值过去，所以很灵活
        # 一般是在下标的方括号前面用大括号包住前面，强制列表上下文
        # （...)[...]
```


## 数组切片
上面的最后一个例子可以不加`()`的

```perl
my @getEle = @array[9, 0, 2, 1, 0];     # 因为这个就是列表上下文
```

### 区别辨析
* 理论上， `@array[0,1]` 和 `($array[1] , $array[2])` 是一样的
* `@array[2]` 和 `$array[2]` 的值是一样的，但是前者是列表上下文，后者是标量上下文，**如果取单个元素一般使用 后者**

使用必要性：**切片可以内插**


```perl
my @date = qw/ aaa bbb cc dddd www tttt/;

say " data is ($date[3],$date[2],$date[5])";
    # 结果 是data is (dddd，cc，tttt)    并不是列表内插，而是标量内插

say "data is @date[3,2,5]"
    # data is dddd cc tttt          被内插，而且排序改变
```
> 实际上内插数组时候，中间间隔是 `$"`,默认为空。
> 数组内插时候，会先执行一次  join $",@list


### 切片当左值
切片是可以放在 `=` 左边当作左值的

```perl
my $name = "asdfaa";
my $phone = "222211111";

@deatil[4,9] = ($name, $phone);     # 和下面的意义一样，但是更加简洁
($deatil[4], $deatil[9]) = ($name, $phone);

@deatil[2,5,7] = @other_array[3,9,5];       # 甚至这样用
```

## 哈希切片
哈希也是可以切片的

```perl
my @array = ($hash{'one'}, $hash{'two'}, $hash{'three'} );
my @array = @hash{ qw/ one two three / };   # 和上面个一个意思
            # 注意前面用的是 @
```

Perl是通过看变量前面的符号来确定数据类型的

因为切片是一个列表，所以要用`@`

如果前置放了 $ 那么就只会返回一个 键值对了，反之就是一个列表

% 只能代表整个哈希，不能代表列表，切片一定是列表

在Perl任何地方哈希切片可以用来代表哈希里面相应的元素

```perl
my @player = qw/ barney fred dino/;
my @bowling_score = (195, 205, 30);
@score{ @players } = @blowling_score;
        # 哈希切片可以当左值
        
say "Tonight's plays were: @players\n";
print "Their scores were: @score{@players}\n"
        # 哈希切片是可以内插的
```

# 错误处理入门
类似C++ 和 Java的 `try-catch`，perl也有自己的错误检查

```perl
eval{ $barney = $fred/$dino };      # 捕获错误
        # $dino = 0 也不会让程序崩溃
```
==eval 后面有个逗号，因为eval是一个表达式，而不是一个结构==

如果`eval`捕获到错误，就会先去处理错误，处理完成了再接着运行。

`evil`的返回值就是最后一条语句的结果（类似函数）

```perl
my $ret = evil{ $fred/$dino };
```

如果捕捉到错误，就会返回undef，反之就返回最后一次结果。

可以通过设定默认值，让执行错误的时候返回一个默认结果

```perl
my $ret = evil{ $fred/dino } // 'NaN';
        # 当执evil 捕获错误的时候，就 由于 // 操作符，使得 $ret 得到 'NaN'
```

错误信息存放到 `$@` 中，可以通过检查 `$@`的真假来判断是否发生错误，没有错误就 是空。

```perl
use 5.010;
my $barney = eval{ $fred / $dino} // 'NaN';

print "I could't divide by \$dino: $@" if $@;
```

其实很多时候就算成功了，也没有多少有意义的返回，因此一般可以写成：

```perl
unless ( evil{ some_sub(), 1 ) {
    print "I could't divide by \$dino: $@" if $@;
}
# 如果没有捕捉到错误，就会执行1， 那么就返回了1， 不会触发 unless
```

列表上下文中，evil返回的是空列表,等于不存在

```perl
my @array = (1/2, evil{$fred,$dino}, 44/6);
# 如果evil捕获到错误， @array 就只有两元素了。
```

**evil 的{ } 是可以通过 my来创建本地变量的**

