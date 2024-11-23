---
title: map 文件分析
date: 2024-11-24 01:28:59
# description: 
# mermaid: true
categories:
  - misc
tags:
  - map
published: true
---

本篇仅讨论 mdk armcc 生成的 map 文件

## c 语言内存布局

1. 代码段
2. 数据
    1. 初始化（只读 RO、以初始化读写 RW）数据
    2. 未初始化（.bss）
3. 堆栈
    1. heap（malloc）
    2. stack（由编译器自动分配释放）

## ARM 程序

RO 段、RW 段、ZI 段

ROM 拷贝到 RAM
* text 和 data 段在固件中，由系统加载
* 而 bss 由系统初始化

FLASH = Code + RO + RW
RAM = RW + ZI + 堆栈

## 段的使用

全局区（静态区）对应下面几个段：
* 只读（RO Data）
* 读写（RW Data）
* 未初始化（BSS Data）

对于变量
* 函数内声明的变量在 stack 上
* malloc 等动态分配的在 heap 上
* 字符串、const 修饰的放在 RO 区
* 其他全局变量
    * 初始化的放在 RW 区
    * 未初始化的放在 ZI（bss）区

## map 文件

分为 5 个部分：

### 函数调用关系

Section Cross Reference

![map0](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/map0.png)

`cb_putc()` 这个函数内调用了 `apUART_Check_TXFIFO_FULL()` 和 `UART_SendData()`

![map1](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/map1.png)

### 被优化的冗余函数

Removing Unused input sections from the image.

![map3](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/map3.png)

### 局部标签和全局标签

Image Symbol Table

![map4](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/map4.png)

### 固件的内存映射

Memory Map of the image

Load Region LR_IROM1

![map5](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/map5.png)

Execution Region RW_IRAM1

![map6](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/map6.png)

### 固件大小

![map7](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/map7.png)


## ARM 工程查看堆栈大小

看 startup_xxx.s 文件

![map8](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/map8.png)
