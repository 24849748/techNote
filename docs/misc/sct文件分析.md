---
title: sct 文件分析
date: 2024-11-24 00:55:08
# description: 
# mermaid: true
categories:
  - misc
tags:
  - sct
published: true
---

我们可以直接使在 MDK 魔术棒 - Target 中指定 ROM RAM 布局，也可以在 Linker 中指定 scatter 文件。

sct全名，scatter，意味分散。.sct文件就是分散加载文件。分散加载文件就是可以通过这个脚本文件来自己定义各个不同的位置，哪里存的是代码、哪里存的是数据，去哪个特定的地址找到下一步需要运行的函数等等。

结合 attribute ，我们可以将代码/变量指定到具体位置

以某个 scatter 文件举例

```c
#! armcc -E -I ..\src\ -I ..\..\..\ble\api
#include "cfg.h"
#include "blelib.h"

#define SCT_FLASH_BASE          (0x18004000)
#define SCT_FLASH_END           (0x18020000)
#define SCT_FLASH_LEN           (SCT_FLASH_END - SCT_FLASH_BASE)

LR_IROM1 SCT_FLASH_BASE SCT_FLASH_LEN
{
    ER_IROM1 SCT_FLASH_BASE SCT_FLASH_LEN
    {
        *.o (RESET, +First)
        *(InRoot$$Sections)
        startup*.o (+RO)
        .ANY (+RO)
    }
    
    RW_IRAM_VECT 0x20003000 EMPTY 152
    {
        ; sram vector
    }
    
    RW_IRAM_USER +0
    {
        *.o(ram_func*)
        .ANY (+RW +ZI)
    }

    RW_IRAM_STACK 0x20008000-0x600 UNINIT 0x600
    {
        .ANY (STACK)
    }
    
    RW_IRAM_EXCH BLE_EXCH_BASE EMPTY BLE_EXCH_SIZE
    {
        ; configured with BLE HW
    }
    
    RW_IRAM_HEAP BLE_HEAP_BASE EMPTY BLE_HEAP_SIZE
    {
        ; configured with ble_heap()
    }
    
    RW_IRAM_RWZI BLE_RWZI_BASE UNINIT BLE_RWZI_SIZE
    {
        ; ZI data, manual inited in lib
        *ble6*.lib (+RW +ZI)
        ; user manual init
        *.o(user_retention)
    }
}
```

### 基本格式
```
加载域名 基地址 偏移地址 [属性] [最大容量]
{
}
```

* ER_IROM1：可执行代码段的 rom，ER: Execution Region
* (InRoot$$Sections)：链接器的特殊选择符号，可以选择所有标准库里要求存储的 root 区域的字节
* (+RO)：属性为只读
* .ANY：所有 section，.ANY(+RO) 表示其他属性为只读的 section
* UNINIT：表示未初始化的区域，程序在启动时不需要预先设定初始值（全局定义但未赋值的变量）
* EMPTY：表示空的区域，不包含任何内容，用于描述不需要使用的内存区域

## 参考
> https://blog.csdn.net/weixin_44788542/article/details/127537956