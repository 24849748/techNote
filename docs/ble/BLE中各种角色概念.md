---
title: BLE 中各种角色概念
date: 2024-05-19 15:14:57
categories:
- ble
tags:
- BLE
- 低功耗蓝牙
# published: false
---

蓝牙开发中，我们经常看到一些关于角色的名词，Master/Slave，Central/Peripheral，Server/Client。如何区分这些角色呢？

## GAP 层 4 种角色

BLE 核心规范在 GAP 层定义了 4 种角色：
* 广播者（Broadcaster）：又叫 Advertiser
* 观察者（Observer）：又叫 Scanner
* 外围设备（Peripheral）：也叫 Slave
* 中心设备（Central）：也叫 Master

根据是否建立连接和蓝牙工作阶段，可以将者四种角色分为两组：broadcaster/observer，perpheral/central，前者属于广播阶段的角色，在 iBeacon 应用中比较常用；后者属于连接阶段的角色。

以蓝牙遥控器和电视为例：
1. 蓝牙遥控器发起广播，属于广播者；电视机扫描蓝牙设备，属于观察者。
2. 蓝牙遥控器负责收集数据（按键数据、语音数据），一个遥控器同一时间一般只能连接一台电视，属于外围设备；电视机负责接收按键或语音数据，一般可以配对多个遥控器，属于中心设备。

我们还可以根据最终建立连接的决定权来判断谁是主机谁是从机，比如有多个遥控设备同时发起广播，但最终决定与哪个遥控器建立连接的是电视，因此电视拥有最终建立连接的决定权，所以电视机是主机，遥控器则是从机。

需要注意的是，BLE 没有限制设备的角色范围。一个设备既可以是主机也可以是从机。

## Server 和 Client

前面几个角色是基于 GAP 层的，而 Server 和 Client 是基于 ATT/GATT 层的一组角色。

ATT 采用 c/s 模式，client 负责请求数据，server 负责提供数据。

与以上例子第二点类似，若电视需要获取遥控器电量，电视机是请求方，所以电视机是 Client；遥控器是提供方，所以遥控器是 Server。

此外，我们也可以服务的声明来判断，一般蓝牙服务是由遥控器声明的，所以遥控器是服务器 Server，反之电视机是客户端 Client。

## 总结

一个人可以有多种角色，可以是个男生，也可以是个学生。对于 BLE 来说也是一个道理。