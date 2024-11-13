---
title: 【linux 学习笔记】常见基础概念
date: 2024-11-10 22:30:23
description: 根文件系统、文件权限、IO 重定向。..
categories:
  - linux
tags:
  - linux
---

## 根文件系统 rootfs

```bash
/
├── bin -> usr/bin # 存放常用且开机必须用到的可执行文件
├── boot
├── cdrom
├── dev # 设备文件
├── etc # 配置文件、用户信息、启动脚本
├── home
├── lib -> usr/lib # bin sbin 所需的链接库，Linux 的内核模块
├── lib32 -> usr/lib32
├── lib64 -> usr/lib64
├── libx32 -> usr/libx32
├── lost+found
├── media
├── mnt # 挂载点
├── opt
├── proc
├── root
├── run
├── sbin -> usr/sbin # 开机过程中所需的系统级可执行文件
├── snap
├── srv
├── swapfile
├── sys
├── tmp # 临时文件
├── usr
└── var
```

### bin 目录

该目录下存放所有用户都可以使用的、基本的命令，这些命令在挂接其它文件系统之前就可以使用，所以/bin 目录必须和根文件系统在同一个分区中。
/bin 目录下常用的命令有：cat，chgrp，chmod，cp，ls，sh，kill，mount，umount，mkdir，mknod，test 等，我们在利用 Busybox 制作根文件系统时，在生成的 bin 目录下，可以看到一些可执行的文件，也就是可用的一些命令。

### sbin 目录

该目录下存放系统命令，即只有管理员能够使用的命令，系统命令还可以存放在/usr/sbin,/usr/local/sbin 目录下，/sbin 目录中存放的是基本的系统命令，它们用于启动系统，修复系统等，与/bin 目录相似，在挂接其他文件系统之前就可以使用/sbin，所以/sbin 目录必须和根文件系统在同一个分区中。
/sbin 目录下常用的命令有：shutdown，reboot，fdisk，fsck 等，本地用户自己安装的系统命令放在/usr/local/sbin 目录下。

### dev 目录

该目录下存放的是设备文件，设备文件是 Linux 中特有的文件类型，在 Linux 系统下，以文件的方式访问各种设备，即通过读写某个设备文件操作某个具体硬件。比如通过"dev/ttySAC0"文件可以操作串口 0，通过"/dev/mtdblock1"可以访问 MTD 设备的第 2 个分区。

### etc 目录

该目录下存放着各种配置文件，对于 PC 上的 Linux 系统，/etc 目录下的文件和目录非常多，这些目录文件是可选的，它们依赖于系统中所拥有的应用程序，依赖于这些程序是否需要配置文件。在嵌入式系统中，这些内容可以大为精减。

### lib 目录

该目录下存放共享库和可加载（驱动程序），共享库用于启动系统。运行根文件系统中的可执行程序，比如：/bin /sbin 目录下的程序。

👆 上面 5 个是根文件系统必备的

### home 目录

用户目录，它是可选的，对于每个普通用户，在/home 目录下都有一个以用户名命名的子目录，里面存放用户相关的配置文件。

### root 目录

根用户的目录，与此对应，普通用户的目录是/home 下的某个子目录。

### usr 目录

/usr 目录的内容可以存在另一个分区中，在系统启动后再挂接到根文件系统中的/usr 目录下。里面存放的是共享、只读的程序和数据，这表明/usr 目录下的内容可以在多个主机间共享，这些主要也符合 FHS 标准的。/usr 中的文件应该是只读的，其他主机相关的，可变的文件应该保存在其他目录下，比如/var。/usr 目录在嵌入式中可以精减。

### var 目录

与/usr 目录相反，/var 目录中存放可变的数据，比如 spool 目录 (mail,news)，log 文件，临时文件。

### proc 目录

这是一个空目录，常作为 proc 文件系统的挂接点，proc 文件系统是个虚拟的文件系统，它没有实际的存储设备，里面的目录，文件都是由内核临时生成的，用来表示系统的运行状态，也可以操作其中的文件控制系统。

### mnt 目录

用于临时挂载某个文件系统的挂接点，通常是空目录，也可以在里面创建一引起空的子目录，比如/mnt/cdram /mnt/hda1 。用来临时挂载光盘、硬盘。

### tmp 目录

用于存放临时文件，通常是空目录，一些需要生成临时文件的程序用到的/tmp 目录下，所以/tmp 目录必须存在并可以访问。

## jffs2

JFFS 文件系统最早是由瑞典 Axis Communications 公司基于 Linux2.0 的内核为嵌入式系统开发的文件系统。JFFS2 是 RedHat 公司基于 JFFS 开发的闪存文件系统，最初是针对 RedHat 公司的嵌入式产品 eCos 开发的嵌入式文件系统，所以 JFFS2 也可以用在 Linux, uCLinux 中。

Jffs2: 日志闪存文件系统版本 2 (Journalling Flash FileSystem v2)
主要用于 NOR 型闪存，基于 MTD 驱动层，特点是：可读写的、支持数据压缩的、基于哈希表的日志型文件系统，并提供了崩溃/掉电安全保护，提供“写平衡”支持等。缺点主要是当文件系统已满或接近满时，因为垃圾收集的关系而使 jffs2 的运行速度大大放慢。

目前 jffs3 正在开发中。关于 jffs 系列文件系统的使用详细文档，可参考 MTD 补丁包中 mtd-jffs-HOWTO.txt。
jffsx 不适合用于 NAND 闪存主要是因为 NAND 闪存的容量一般较大，这样导致 jffs 为维护日志节点所占用的内存空间迅速增大，另外，jffsx 文件系统在挂载时需要扫描整个 FLASH 的内容，以找出所有的日志节点，建立文件结构，对于大容量的 NAND 闪存会耗费大量时间。

## Ramdisk

Ramdisk 是将一部分固定大小的内存当作分区来使用。它并非一个实际的文件系统，而是一种将实际的文件系统装入内存的机制，并且可以作为根文件系统。将一些经常被访问而又不会更改的文件（如只读的根文件系统）通过 Ramdisk 放在内存中，可以明显地提高系统的性能。
在 Linux 的启动阶段，initrd 提供了一套机制，可以将内核映像和根文件系统一起载入内存。

## 文件权限

Linux 文件权限分为三种：
* 读 r
* 写 w
* 执行 x

权限粒度又分：
* 所有者
* 群组
* 其他组

使用 `ll` 命令查看文件对应权限及所属用户和组：

```bash
bosco@2004 ~/Project/PX4-Flow (master*) $ ll            
总用量 176K
drwxrwxr-x 4 bosco bosco 4.0K 11 月  5 19:22 baremetal-configs
drwxrwxr-x 2 bosco bosco 4.0K 11 月  5 19:22 cmake
-rw-rw-r-- 1 bosco bosco  11K 11 月  5 19:22 CMakeLists.txt
-rw-rw-r-- 1 bosco bosco  705 11 月  5 19:22 Flow.sublime-project
drwxrwxr-x 2 bosco bosco 4.0K 11 月  5 19:22 Images
...
```

对于第一串字符，定义如下：
![20241113172554](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20241113172554.png)

即 文件类型，所有者，群组，其他组，`-` 表示没有对应权限

```bash
# 修改权限，-R 表示递归修改，xyz 表示权限
chmod -R +x file # 给所有用户添加执行权限
chmod -w file # 给所有用户去掉写权限
chmod =x file # 所有用户只有执行权限

# 用数字修改
## r:4
## w:2
## x:1
## 加起来表示一组权限
chmod 777 file # 所有用户都有读写执行权限
```

常见数字权限表示

* 777: 所有用户都有读写执行权限
* 755: 所有者有读写执行权限，群组和其他用户只有读和执行权限
* 644: 所有者有读写权限，群组和其他用户只有读权限
* 600：所有者有读写权限，群组和其他用户没有权限

## IO 重定向

- Linux 命令默认输出是终端

几个标准的文件描述符

```bash
stdin   0   标准输入流（键盘）
stdout  1   标准输出流（终端）
stderr  2   标准错误流（终端）
```

输出重定向常见形式

```bash
command > file      # 将 stdout 重定向到 file
command 1> file     # 同上
command >> file     # 将 stdout 追加到 file
command 2> file     # 将 stderr 重定向到 file
command 2>> file    # 将 stderr 追加到 file
command &> file     # 将 stdout 和 stderr 都重定向到 file
```

即 `&>` = `1>` + `2>`，例如

```bash
ifconfig wlan0 192.168.1.1 up >> /tmp/ap.log 2>&1
# 2>&1 表示将 stderr 重定向到 stdout
# 上面等于
ifconfig wlan0 192.168.1.1 up >> /tmp/ap.log 2>> /tmp/ap.log
```

另外，/dev/null 是一个特殊文件，给它的东西都会丢弃掉
`&> /dev/null` 表示丢弃 stdout 和 stderr

## 守护进程（Daemon）

是一种在后台运行的特殊进程，不直接与用户交互
特点：

1. 后台运行
2. 独立性，脱离父进程控制
3. 长时间运行
4. 提供服务，通过 socket、文件接口等

创建步骤：

1. fork()
2. setsid() 创建新会话
3. chdir("/") 更改根目录
4. unmask(0)，设置文件权限掩码
5. reopen() 重定向 `stdin` `stdout` `stderr` 到 `/dev/null`
