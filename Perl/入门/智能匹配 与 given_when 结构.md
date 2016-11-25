# 智能匹配
智能匹配必须要 5.010001 版本以上
## 智能匹配操作符
`~~`

可以根据两边的操作数据类型自动判断应该用什么方式进行比较或匹配。

如果两边操作数看起来像数字，就比较数字大小。如果像字符串，就比较字符串大小

如果一边是正则表达式，就当作模式匹配来进行。

```perl
use 5.022;      #版本要够高
print "I found Fred in the name!\n" if $name =~ /Fred/;     # 传统写法

say "I found Fred in the name!" if $name ~~ /Fred/;     # 使用智能匹配
```

智能简化

```perl
# 遍历所有哈希键，查看是否找得到 Fred
my $flag = 0;
foreach my $key (keys %name){
    next unless $key =~ /Fred/;
    $flag = $key;
    last;
}
say "I found a key matching 'Fred'. It was $flag\n" if $flag;
```

```perl
# 用智能操作
say "I found a key matching 'Fred'" if %names ~~ /Fred/;
```

左边是哈希，右边是正则表达式，会被解析为 用这个正则表达式匹配哈希建，成功就立马返回

具体使用可以看表*perlsyn "Smart matching in detail"*

`~~` 不用太在意 左右操作， 两边换过来也是可以的

### 部分常用的

```perl
%a ~~ %b;                           # 哈希键是否一致
%a ~~ @b or @a ~~ %b;               # %a 中至少一个键在@b中
%a ~~ /Fred/ or /Fred/ ~~ %a;       #至少一个键匹配正则表达式
'Fred' ~~ %a;                       #是否存在$a{Fred}
@a ~~ @b;                           #数组是否完全相同
@a ~~ /Fred/;                       #@a中至少一个元素匹配正则表达式
$name ~~ undef $name;               # $name 没有定义
$name ~~ /Fred/;                    # 模式匹配
123 ~~ ' 123.0';                    # 数值和 "numish" 类型数值字符串是否相等
' Fred' ~~ ' Fred'                  # 字符串是否相同
123 ~~ 456                          # 数值是否相等
```
**这个表也是perl 查找操作的先后顺序**

**主要是看拿到的第一个操作数**

```perl
4 ~~ '4abc';        # 假    因为4abc不被看作numish类型
'4abc' ~~ 4;        # 真    字符串被解析为数字 4
```

```perl
$a ~~ $b;           # 没有真实参数，只能等到具体值才知道怎么操作
```

# given语句
`given-when` 语句和switch类似

```perl
use 5.022;

given( $ARGV[0] ){
    when ( 'Fred' ) { say 'Name is Fred' }
    when ( /fred/i ) { say 'Name has fred in it' }
    when ( /\AFred/ ) { say 'Name starts with Fred' }
    default { say "I dont see a Fred"}
}
```

其实完整版是这样的

```perl
use 5.022;

given( $ARGV[0] ){      # given 里面的东西会放到 $_ 里面
    when ( $_ ~~ 'Fred' ) { say 'Name is Fred' }    # 最后一个操作不需要分号
    when ( $_ ~~ /fred/i ) { say 'Name has fred in it' }
    when ( $_ ~~ /\AFred/ ) { say 'Name starts with Fred' }
    default { say "I dont see a Fred"}
}
```

上面是从上到下检索，遇到返回值是真的就执行对应的代码块

但是只执行一个代码块，具体完整是这样的

```perl
use 5.022;

given( $ARGV[0] ){
    when ( $_ ~~ 'Fred' ) { say 'Name is Fred'；break }     # break是默认的
    when ( $_ ~~ /fred/i ) { say 'Name has fred in it'；break } # 最后一个操作不需要分号
    when ( $_ ~~ /\AFred/ ) { say 'Name starts with Fred'；break }
    default { say "I dont see a Fred"}
}
```

如果还要继续往下检索，直到全部检索完毕，并且满足的都进行操作的话，就`continue`

```perl
use 5.022;

given( $ARGV[0] ){
    when ( $_ ~~ 'Fred' ) { say 'Name is Fred'；continue }      # continue 表示接着检索下一个
    when ( $_ ~~ /fred/i ) { say 'Name has fred in it'；continue }  
    when ( $_ ~~ /\AFred/ ) { say 'Name starts with Fred'； }   # break，为了不执行default
    default { say "I dont see a Fred"}
}
```

### 配合其他判断操作符
`given-when` 默认使用的是 `~~` 

如果要用其他的，需要手动指定

```perl
use 5.022;

given ($ARGV[0]){
    when ( 'Fred' ) { ..... }   # 智能匹配
    when ( $_ =~ /\Aferd/ ) {......}    # 手动指定，笨拙匹配
    when ( $_ > 10 ) {.......}          # 这种比较必须手动
    when ( exist $hash{$_} ) {......}   # 还可以配合函数使用
    when ( ! /fred/i)   {.....}         # 取反就用 ！
}
```

## 多条目的 `when` 匹配
当处理一个数组的元素时候，其实 可以用 `foreach` 替代 `given` 的

```perl
use 5.022;
# 表示吧数组中一个个拿出来进行when比对，
foreach (@name){        # 但是不要使用具体名称
    say "\n I get $_"   # 可以先执行一些其他操作
    
    when ( 'Fred' ) { ..... }
    when ( $_ =~ /\Aferd/ ) {......}
    when ( $_ > 10 ) {.......}
    when ( exist $hash{$_} ) {......}
    
    print ".....";      # 中间也可以执行其他操作，不过如果不是
    
    when ( ! /fred/i)   {.....}
    
    default {.......}
    say {......}        #default 后面的不会执行
    
}
```
**仔细查看，发现如果不手动break，break会自动放到下一个when前面。。。所以在中间加其他语句有点傻逼**
