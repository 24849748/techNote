---
categories:
  - linux
tags:
  - linux
published: false
---

## DTS 由来

全称 Device Tree Source 设备树源码。是一种描述硬件的数据结构

// 识别 platform 的信息
// runtime 的配置参数
// 设备的拓扑结构以及特性

## DTS 加载过程

```
DTS -- (DTC) --> DTB -- (BootLoader) --> Kernal
```

1. 用户把硬件配置和系统运行参数，组织成 DTS(device tree source file)
2. DTC 将适合人类阅读的 DTS 变成适合机器处理的 DTB(device tree binary file)
3. 系统启动时，bl 将保存在 flash 中的 DTB copy 到内存（或者其他方式）

## DTS 的描述信息

设备树由一系列的 node 和 property 组成，类似 json 的 name value。
可描述信息包括：
* CPU的数量和类别
* 内存基地址和大小
* 总线和桥
* 外设连接
* 中断控制器和中断使用情况
* GPIO控制器和GPIO使用情况
* Clock控制器和Clock使用情况

它基本上就是画一棵电路板上CPU、总线、设备组成的树，Bootloader会将这棵树传递给内核，然后内核可以识别这棵树，并根据它展开出Linux内核中的platform_device、i2c_client、spi_device等设备，而这些设备用到的内存、IRQ等资源，也被传递给了内核，内核会将这些资源绑定给展开的相应的设备。

Device Tree 并不需要描述系统中所有的硬件信息。例如 USB Device 这些可以动态探测到的设备不需要描述。

arm linux 的一个 .dts 对应一个 arm mechine，一般放置在内核的 `arch/arm/boot/dts` 目录。

linux 为了简化，对共用部分抽象为 .dtsi ，因此有的 .dts 会有 `#include "xx.dtsi"` 字样，和c语言的头文件类似


## DTS 组成结构

```
/ {  
    node1 {  
        a-string-property = "A string";  
        a-string-list-property = "first string", "second string";  
        a-byte-data-property = [0x01 0x23 0x34 0x56];  
        child-node1 {  
            first-child-property;  
            second-child-property = <1>;  
            a-string-property = "Hello, world";  
        };  
        child-node2 {  
        };  
    };  
    node2 {  
        an-empty-property;  
        a-cell-property = <1 2 3 4>; /* each number (cell) is a uint32 */  
        child-node1 {  
        };  
    };  
};
```




## 设备树 DTS

DTS 全称 Device Tree Source 设备树源码。是一种描述硬件的数据结构

```
DTS -- (DTC) --> DTB -- (BootLoader) --> Kernal
```

通过 make 编译指定 dtbs

```
make [xx.dtb]
```

内核启动时会解析设备树，然后在 `/proc/device-tree` 体现

![20240711151416](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240711151416.png)


### DTS 基本语法

1. DTS 从 `/` 根节点开始
2. `/` 之外， `&` 表示追加


举例：

```
/ {  
    node1 {  
        a-string-property = "A string";  
        a-string-list-property = "first string", "second string";  
        a-byte-data-property = [0x01 0x23 0x34 0x56];  
        child-node1 {  
            first-child-property;  
            second-child-property = <1>;  
            a-string-property = "Hello, world";  
        };  
        child-node2 {  
        };  
    };  
    node2 {  
        an-empty-property;  
        a-cell-property = <1 2 3 4>; /* each number (cell) is a uint32 */  
        child-node1 {  
        };  
    };  
};
```





---

## 字符设备驱动

### 用户空间与内核空间（用户态与内核态）

Linux操作系统内核和驱动程序运行再内核空间，应用程序运行在用户空间

应用程序访问内核资源怎么办？三种方法：
1. 系统调用
2. 异常（中断）
3. 陷入

应用程序不会直接调用系统调用，而是通过 POSIX 、C库、API等。Unix常见的就是 POSIX

![20240711145137](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240711145137.png)


### 字符设备驱动开发流程

Linux一切皆文件，驱动设备表现在 `/dev/` 目录下的文件，应用程序通过调用 open 打开设备

![20240711151322](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240711151322.png)

编写 open、read、write、close 等接口，以及字符设备驱动结构体 fileoptions_struct

* 因为驱动最终是被应用调用的。写驱动的时候需要考虑应用开发的遍历性
* 驱动需要按照驱动框架来编写


### 驱动模块加载

#### 动态加载
```bash
insmod
rmmod

modprobe
```

#### 静态加载

放入 `/lib/modules/` 相应目录

```bash
```

