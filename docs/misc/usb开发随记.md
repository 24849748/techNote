---
title: usb 开发随记
date: 2024-11-24 00:53:54
# description: 
# mermaid: true
categories:
  - misc
tags:
  - usb
published: false
---

## 名词术语

| 术语 | 理解                                                  |
| ---- | ----------------------------------------------------- |
| HID  | human interface device 人机接口设备，鼠标、键盘之类的 |
| MSC  | mass storage class usb 中的存储类设备                  |
| UAC  | usb audio class 音频类设备                            |

## 知识点记录

#### Host 和 Device

* Host 就是主机，比如 PC，可以识别 u 盘、串口等其他设备，属于数据读取者
* Device 等于从机，类似 dongle、u 盘等，属于数据提供者

#### High Speed 和 Full Speed

* High Speed：USB1.1 标准，12Mbps
* Full Speed：USB2.0 标准，480Mbps

#### 端点

端点是 usb 设备和主机通讯的桥梁。

#### 描述符 descriptor

描述符是一个 usb 设备用来 定义 &“描述”这个设备具体功能的东西。
描述符的配置形象点可以用树形结构表示，如下图：

![20240618102031](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240618102031.png)

这些描述符都可以有其规定的结构体和对应的功能：

* 设备描述符介绍了设备的一些基本信息，比如设备 id、厂商 id、设备类别（）等等
* 配置描述符包含了一些可以配置的相关属性，如功率、供电关系等
* 接口描述符定义了该接口的类别（uac、hid 等）、协议等
* 端点描述符则描述了这个端点的属性、通讯方向、mps 等
* 此外还有一些字符串描述符，用来向主机提供易理解的文本信息（设备管理器中的一些名字？）。

#### 枚举

usb 设备插入电脑时，电脑向 usb 设备读取各个描述符、获取各端点等信息，从而让电脑“认识”这个 usb 设备的一个过程。

只有枚举完成后，usb 设备和主机才能开始通讯。

## 参考
> [USB 中文网](https://www.usbzh.com/)
> 
