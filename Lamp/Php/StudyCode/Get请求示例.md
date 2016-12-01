```php
<form action="<?=$_SERVER['PHP_SELF'] ?>" method = "GET">
    name:<input type="text" name="name" size="15" />
    age:<input type="text" name="age" size="15" />
    hobby:<input type="text" name="hobby" size="15" />
    <input type="submit" name="submit" value="submit" />
</form>

<p>注意查看地址栏变化</p>

<?php
if(isset($_GET['submit'])){
    echo '<p>';
    echo 'name:'.$_GET['name'].'<br>';
    echo 'age:'.$_GET['age'].'<br>';
    echo 'hobby'.$_GET['hobby'].'<br>';
}
?>
```

# 分析

假设我传入的是 'Luck', '19', 'dance'

那么地址栏就会变成:

    http://127.0.0.1/index.php?name=Luck&age=19&hobby=dance&submit=submit

可见,Http 的Get并不安全,会把传输的信息发送到地址栏上,并不适合大数据传输

充上面还可以看出,php的命令行传参有点特别,
* xxx.php后面加上一个`?`后加上参数
* 传参结果是传到`$_GET`中,而且是键值对形式传参
* 传参是可以直接打到地址栏上面的(注入攻击)
* 传其他字符需要转义->如中文
