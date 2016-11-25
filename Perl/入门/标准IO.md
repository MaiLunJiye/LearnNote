# 基本概念
* 标准输入 ： 键盘
* 标准输出 ： 屏幕

# 标准输入

```perl
while( defined($line = <STDIN>)) {		#读入整行，如果输入了 EOF，就会跳出循环
print "input $line";
}

while(<STDIN>){		#上面的简写，内容被放到默认$_ 里面
print "input $_";	#只有这种用法 <STDIN> 才把数据保存到$_,其他用法无效
}
while( defined($_ = <STDIN>)){	#上面的同样执行代码
.....
}

foreach (<STDIN>){		#和上面的区别是， foreach会把所有内容都读到内存
............			# 所以 推荐while
}
```

## 钻石操作符 <>
提供类似 linux 命令行传参的方法
`./Demo.pl`

```perl
use 5.022;
while (defined(my $line = <>))
{
	chomp($line);
	print "It was $line that I saw!\n";
}
```

`perl ./Demo.pl  aaa.pl`
结果是打印aaa.pl的内容

读入 后面参数文件  的第一行

如果后面多个参数， 可以理解为 把多个文件连在一起变为一个更大的文件

`-`（连字符） 标识要从标准输入中读取数据 如 fred - barry，

那么先读fred文件，后指定文件， 再读barry


上面可以简写为
```perl
while (<>){
chomp;			#处理默认的 $_
print "It was $_ that I saw!\n";		#默认的$_
}
```

**一般情况下 `<>` 只能出现一次，尤其是 while中的  <>**

## 真·命令行参数表 `@ARGV`
实际上 `<>` 是读取 数组`@ARGV`的

`@ARGV`才是存放 命令行参数的地方

一般用 `shift`  或者 `foreach` 来取得参数

可以通过检查时候有 `-` 开头的，然后将他们当成调用选项处理，如  `-w`

`<>`如果 发现`@ARGV`是空列表， 就会改为 `<STDIN>` 读取
否则就读取`@ARGV`

可以通过一下操作强制 限定读取文件

```perl
@ARGV = qw/ doca.txt  docb.txt  docc.txt/;  #强制指定读取文件
while (<>){
chomp;
print ".... $_ ...";
}
```

C语言的  `int argc`     在perl 里面没有
`argv[0]`		perl是 `$0`



# 标准输出
`print`

```perl
@array = qw /aaa bbb ccc/;
print @array;		#把所有元素打印出来，不加任何东西   aaabbbccc;
print "@array";	#打印一个字符串，默认空格分隔   aaa bbb ccc;

my @array = ("a\n","b\n","c\n");		#如果@array 是这样的话 ， 两行输出有差异
    #第一种会  每行打印一个  
    #第二种是 ，从第二行开始，前面补了个空格。
a
 b
 c
```
一般情况下  在 引号场合 字符串后面最好加上`\n`


print  是列表上下文，   <>也是列表上下文 ，于是
print <>;			#类似cat命令
print sort <>;		#类似sort命令


print()	在不歧义情况下 可以  省略  ();
print();		也是函数， 成功输出会返回1，  返回值一般是1

print （2+3）*4；		#这里会输出5
#其实 函数的括号优先级 比运算高
#  （ print（2+3）  ）*4；       ，print的返回值 和 4相乘。

尽量用 -w 开启 警告避免这种东西

printf格式化输出
和C语言类似

printf "hello, %s； your are no.%d", $user, $usernum;
printf "%g, %g, %g\n", 5/2, 51/17, 51**17;	#%g会根据数据，自动选择整型，浮点型，。。。。。
#	2.5,       3,          1.0683e+29；

# %d,  	无条件截取取整
#%f		四舍五入，可以控制 小数点多少位
# %%	两个百分号  就是 输出一个百分号    这里转义字符是  %


数组和printf
一般不会把数组当成printf的参数
不代表不可用，只是有微操

风骚
my @items = qw/ wilma dino pebbles /;
printf "The items are:\n".("%10s\n" x @items), @items;
#分析： 在格式表达式里面 不一定是写死的， 可以通过字符串操作动态生成
#因为格式表达式也是一个参数， 一样在传参时候进行 运算
# 传入 固定部分 "The items are:\n"   后，通过字符串连接符  .  把(%10s/n" x @items) 连接在一起
#%10s/n" x @items   这个是字符串复制操作根据 @item的元素数量（标量上下文）  动态添加 %10s\n的数量
#最后传入 @items  完成 风骚的代码


say输出
say输出 具体和print一样，只是后面会自动加上 换行符