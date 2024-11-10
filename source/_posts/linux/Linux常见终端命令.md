---
title: 【linux 学习笔记】常见终端命令
date: 2024-11-10 22:28:21
categories:
  - linux
tags:
  - linux
---

## hexdump

```bash
# 同时显示 ASCII 和十六进制， 并只显示前 5 个字节
hexdump -C -n 5 test.bin

# 偏移 10 个字节开始显示
-s 10
```

## grep 命令

```bash
grep "pattern" file_name
```

* pattern 可以是正则表达式，也可以是字符串

## sed 命令

stream editor，流编辑器，用于对文本进行过滤和转换

可以替换、删除、新增文本

```bash
sed -i '1i\welcome' fin.txt
```

* a ：新增， a 的后面可以接字串，而这些字串会在新的一行出现（目前的下一行）～
* c ：取代， c 的后面可以接字串，这些字串可以取代 n1,n2 之间的行！
* d ：删除，因为是删除啊，所以 d 后面通常不接任何东东；
* i ：插入， i 的后面可以接字串，而这些字串会在新的一行出现（目前的上一行）；
* p ：打印，亦即将某个选择的数据印出。通常 p 会与参数 sed -n 一起运行～
* s ：取代，可以直接进行取代的工作哩！通常这个 s 的动作可以搭配正则表达式！例如 1,20s/old/new/g 就是啦！

## awk 命令

```bash
awk '{print $1}' file.txt
```
* file.txt 是需要处理的文件
* awk 会根据空格、制表符等来分割字段
* `'{print $1}'` 是模板，$1 表示第一个字段，$0 表示当前整行

举例：
```bash
echo "hello world" | awk '{print $1}'
hello

echo "hello world" | awk '{print $0}'
hello world

# 指定分隔符
echo "hello world; code bug" | awk -F';' '{print $2}'
 code bug
```

## top 命令

查看进程系统占用
```bash
top
# or
top -p <pid>
```
* M 按内存占用排序
* P 按 CPU 占用排序

## ps 命令

用于查看进程

```bash
ps aus | grep <进程名>
```

## kill 命令

用于杀掉进程

```bash
kill <pid>

# -9 强制杀掉进程
kill -9 <pid>
```

## du 命令

用于查看文件夹大小
[Linux 查看文件或文件夹大小：du 命令](https://blog.csdn.net/duan19920101/article/details/104823301)
[Linux 中查看各文件夹大小命令 du -h --max-depth=1](https://blog.csdn.net/ouyang_peng/article/details/10414499)

使用 `ls -l` 命令，文件夹大小都只显示 4KB

使用 `du` 命令查看目录或文件实际大小

```bash
-h, --human-readable
    以 K，M，G 为单位，显示文件的大小

-s, --summarize
    只显示总计的文件大小

-S, --separate-dirs
    显示时并不含其子文件夹的大小

-d, --max-depth=N
    显示子文件夹的深度（层级）
```

```bash
du -sh [dir/file]
```

## tar 命令

用于解压缩，通常也可以不加 -

```bash
# 解压
tar -zxvf xxx.tar.gz -C dir/
tar -zxvf xxx.tar.bz2 -C dir/
tar -xvf xxx.tar.xz -C dir/
unzip xxx.zip

# 压缩
tar -zcvf xxx.tar.gz dir/
tar -jcvf xxx.tar.bz2 dir/
tar -Jcvf xxx.tar.xz dir/
zip -r xxx.zip dir/
```

## file 命令

用于查看文件类型

```bash
file xxx
```

## head/tail 命令

用于查看文件内容

```bash
# 查看文件前 10 行
head -n 10 xxx

# 查看文件后 10 行
tail -n 10 xxx

# 查看文件第 10 行到第 20 行
```

## tree 命令

```bash
# 打印根目录
tree -L 1 /
```

## ln 命令

```bash
# src 为源文件，dst 为要生成的软连接文件
ln -s src dst
```
> **如果想要生成目录（而非文件）的软连接，必须用绝对路径。**
