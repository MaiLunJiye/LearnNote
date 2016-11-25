# nmap
> 网络探测工具和 安全/端口扫描器

## 概要

```
nmap [<扫描类型>] [<选项>] {<目标规格>}
```

## 描述

Nmap是用于网络探索和安全审计的开源工具。被设计为快速扫描大型网络。Nmap以新颖的方式使用原始IP数据包来确定网络上可用的主机使用的服务器（应用程序和版本），运行的操作系统，防火墙等。


Nmap的输出是列表，内容取决于使用选项。其中关键信息是“有趣的端口表”。这个表列出了端口号和协议，服务名称和状态。状态是 打开， 过滤， 关闭， 或 未过滤。
* 打开意味着目标计算机上的应用程序正在监听端口上的连接，数据包。
* 过滤意味着防火墙或其他网络阻碍端口，导致Nmap无法判断其打开或关闭状态。
* 关闭的端口没有应用程序监听他们，虽然他们可以随时打开。
* 当端口响应Nmap的探测时候，端口被分类为未过滤的，但Nmap没办法确定他们是打开还是关闭。

**典型的例子**

！[nmap -A -T4 http://......](./Picture/Nmap1.png)

## 选项摘要

当Nmap运行没有参数时候，就会显示以下摘要

### 用法:

    nmap 扫描类型(多个) [选项] {目标}

### 目标说明：

可以通过 主机名，IP地址， 网络等， 如

    scanme.nmap.org , microsoft.com/24 , 192.168.1; 10.0.0 - 255.1-154


```
-iL <输入文件名字>        输入主机/网络列表
-iR <主机数量>            选择随机目标
-excluedfile <排除文件>   从列表中排除文件
```

### 主机发现

```
-sL     列表扫描-简单扫描列表目标
-sn     Ping扫描-禁用端口扫描
-Pn     检测所有在线主机 - 跳过主机发现
-PS/PA/PU/PY[端口列表]    TCP,SYN/ACK,UDP 或 SCTP 发现指定端口
-PE/PP/PM     ICMP echo，timestamp 和 netmask request 发现
-PO[协议列表]     IP协议ping
-n/-R     从不DNS解析/始终解析[默认：有时]
-dns-servers <服务器1，[服务器2]，.....>    指定自定义DNS服务器
-system-dns     使用本机的DNS解析器
-traceroute     每个主机跟踪一条路径
```


### 扫描技术

```
-sS/sT/sA/sW/sM     TCP SYN/Connect()/ACK/Windows/Maimon 扫描
-sU       UDP扫描
-sN/sF/sX       TCP Null,FIN 和 Xmas 扫描
-scanflags <标志>     自定义TCP扫描标志
-sl <讲师主机[:探测端口]>     闲置扫描
-sY/sZ      SCTP INIT/COOKIE-ECHO 扫描
-sO         IP协议扫描
-b        使用FTP bounce扫描
```

### 端口说明和扫描顺序

```
-p <端口范围>     只能扫描指定端口
         例: -p22; -p1-65535; -p U:53,111,137,T:21-25,80,139,8080,S:9
-F              快速扫描指定端口 
-r              连续扫描端口 - 不随机
-top-ports<数量>    扫描<数量>个常见端口
-port-ratio<比率>   扫描常见的<比率>

```

### 服务/版本检测

```
-sV         探索开放的端口,以确定版本信息
-version-inetnsity<级别>        设置从0(浅)到9(尝试所有探测)
 –version-light: 更快地识别最有可能的探测(强度2)
 –version-all: 尝试每一个探测(强度9)
 –version-trace: 显示详细的版本扫描活动(用于调试)
```


### 脚本扫描

```
 -sC: 相当于–script=default
 –script=: 是用逗号分隔的目录列表，脚本文件或脚本类别
 –script-args=: 脚本提供参数
 –script-args-file=文件名:在一个NSE文件中提供脚本参数
 –script-trace: 显示所有的数据发送和接收
 –script-updatedb: 更新脚本数据库
 –script-help=: 显示有关脚本的帮助。

```

###  操作系统检测

```
 -O: 开启操作系统检测
 –osscan-limit: 限定操作系统检测到有希望的目标
 –osscan-guess: 猜测操作系统更快速

```
