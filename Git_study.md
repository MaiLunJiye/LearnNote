# 简单起步

## 新建
选择一个工作目录

    git init

新建一个新的git目录

## 提交

当文件改变时候

    git add <改变的文件>

把文件添加到一个暂存区,(文件为当时即使状态)

    git commit -m 信息

把暂存区的文件保存为一个版本

> 这里提交的是暂存区的版本,如果工作版本有修改是不会保存的,除非git add 更新一下暂存区

如果需要查看本次提交将会提交什么

    git diff

查看将会提交什么

## 回滚

    git reset HEAD^

回滚一个版本, HEAD表示当前版本, HEAD^表示上一个,HEAD^^表示上上个...  当要回退太多时候可以 HEAD~数字

    git log

查看提交的版本信息, 前面有一段乱数字是版本号,以后回复用得上

    git reset 版本号

回滚到对应版本号,版本号只要写前面几个数字就行了,git会自动匹配

然而回滚版本号很坑爹,主要是太难记了

    git relog

这个命令可以查看 提交过的版本信息,根据提交时候的提交信息确定版本(说明版本描述很重要)


# 深入


## 修改比较

    git status

可以查看当前状态和最近一次提交的区别

    git diff 具体文件

查看对应文件与最近一次提交的具体修改

## 丢弃当前工作

如果对一个文件不太满意,可以选择丢弃他

    git checkout -- 文档

这样就可以撤销**工作区**的所有修改,**注意是工作区**
* 如果工作区文件没有 git add, 那么撤销的结果就是退回到上次 commit状态
* 如果已经git add, 那么撤销的结果就是就是退回到和 git add 一样
* **注意语法`git checkout (一个空格) -- (再一个空格) 丢弃的文档`**
    
```
git reset HEAD 文档名字
```

这个可以吧暂存区的文件撤销,并且放回工作区
