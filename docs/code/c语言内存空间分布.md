---
title: c 语言内存空间分布
date: 2024-11-24 00:29:27
# description: 
mermaid: true
categories:
  - code
tags:
  - c
published: true
---

## 内存分布模型

（高地址）

* 动态区
  * 栈
  * 堆
* 静态区
  * 全局未初始化区（.bss）
  * 全局初始化区（.data）
  * 只读数据段
  * 代码段

（低地址）

其中，动态区 = RAM，静态区 = ROM

![20241229214702](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20241229214702.png)

| 程序静态结构 | 对应 arm 程序结构|
|--|--|
|.bss|ZI-data|
|.data/.rwdata|RW-data|
|.rodata|RO-data|
|.text|Code|

### stack

* 临时创建的局部变量
* 调用函数的传参、返回值
* const 定义的局部变量

### heap

* 动态分配的内存

### .bss

全局未初始化区

* 存放未初始化的全局变量、静态变量
* .bss 不占用可执行文件空间，内容由操作系统初始化（一般为0）

### .data

全局初始化区

* 存放已初始化的全局变量、静态变量
* .data 占用可执行文件空间，内容由程序初始化

### .rodata

常量区

* const 定义的全局变量（常量）
* 字符串常量

### .text

代码段

* 程序代码

## 代码示例
```c
#include <stdio.h>

int g_inited = 10; /*!< .data */
int g_uninit; /*!< .bss */

const int g_const = 20; /*!< .rodata */

int main(int argc, char *argv[])
{
    int value = 20; /*!< 栈区 */
    static int s_value = 30; /*!< 静态变量，.data */
    const int value2 = 40; /*!< value2 存放在栈区 */
    const char *str = "hello world"; /*!< str 放在栈区，"hello world" 放在常量区 */

    int *buffer = (int *)malloc(sizeof(int) * 10); /*!< 动态分配的内存 */

    printf("main: %p", main);
    printf("str: %p\n", str);
    printf("g_inited: %p\n", (void *)&g_inited);
    printf("s_value: %p\n", (void *)&s_value);
    printf("g_uninit: %p\n", (void *)&g_uninit);
    printf("value: %p\n", (void *)&value);
    printf("buffer: %p\n", buffer);

    free(buffer);

    return 0;
}
```

## 存储介质

### RAM

随机存储器，分两种：

* 静态 RAM（SRAM）
* 动态 RAM（DRAM）

单片机常用 SRAM，PC电脑常见 DRAM

### ROM

只读存储器，相比 RAM 读写速度慢，断电后数据不丢失，常用来存放一次性写入的程序和数据

### Flash

闪存，断电后数据不丢失，可多次擦写

现在 Flash 已经取代了 ROM，成为嵌入式系统常用的存储介质

## ARM 内存占用计算

FLASH = Code + RO + RW
RAM = RW + ZI + 堆栈

### 为什么 RW 既占 FLASH 又占 RAM ？

1. RW-data 属于有初始值的变量，这个初始值由程序员指定
2. 编译器在编译时，需要将 RW-data 的初始值存放在 FLASH 中，程序运行时，将初始值拷贝到 RAM 中
3. ZI-data 则不用，编译器只需要知道区域，程序前由系统去初始化，一般为 0