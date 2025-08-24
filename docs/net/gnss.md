---
title: gnss
date: 2025-06-06 10:48:42
# description: 
# mermaid: true
categories:
  - misc
tags:
  - gps
  - gnss
---


## GNSS 和 GPS

* GNSS（Global Navigation Satellite System即全球导航卫星系统）
  * GNSS 是 GPS 的扩展，包括 GLONASS、Galileo、BDS 等系统。
* GPS（Global Positioning System即全球定位系统）
  * 全球定位系统（GPS）是一个支持全球高精度定位、导航和授时（PNT）测量的卫星，GPS 是 GNSS 系统的一部分


### QA

#### 为什么开发板不能在室内使用 gps 定位？

只有室外开阔的、无遮挡、晴好的地方，才能搜到更多的卫星，SNR 值更高（阴天都会有影响哦），GPS 芯片才能更快、更好的实现定位。


#### 为什么我的手机在室内就能定位，而且特别准呢？

手机使用的是多重定位

手机在室内之所以可以定位，实际上是它不仅使用了 GPS，还使用了很多其他的辅助定位技术，如 LBS（基站定位）、Wi-Fi（wifi 定位）、BLE（蓝牙）等


### 测试

> https://docs.openluat.com/air8000/luatos/app/gnss/gnss_test/

一般 GPS 实测时要求是：

1. 可用于定位卫星颗数大于 6 颗以上
2. 最强的信号在 45 dB/Hz 左右，要有 3 颗卫星信号大于 40 dB/Hz。


