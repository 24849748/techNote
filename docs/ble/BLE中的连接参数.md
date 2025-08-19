---
title: BLE中的连接参数
date: 2024-05-19 14:15:10
categories:
- ble
tags:
- BLE
- 低功耗蓝牙
- 连接参数
---

### 基础概念

#### Connection Event（连接事件）

* 连接事件是指 Master 与 Slave 之间相互发送数据包的过程
* 每个连接事件都是 Master 发起，Slave 回复
* 连接事件到来时，Slave 如果没有用户数据要发送，也要回复一个空口包
* Master 和 Slave 可以在一个连接事件中发送多个包
* Master 和 Slave 都有一个 16bit 的连接事件计数器（connEventCounter），它在第一个连接事件时设置 0，产生新的连接事件就加 1，用于同步链路层控制程序 LLCP

#### Connection Interval（连接间隔）

* 连接间隔决定了 Master 和 Slave 两个连续事件之间的时间长度
* Interval_min 和 Interval_max 描述了连接间隔取值范围，是 Slave 向 Master “建议” 的，连接间隔最终取值由 Master 决定
* 单位 1.25ms，取值范围 6-3200，即 7.5ms-4000ms

![20240602113651](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240602113651.png)

#### Slave latency

从设备延迟，是指 Slave 可以跳过的连接事件的次数。没有 latency（== 0）的情况下，如果 Slave 没有回复空口包，且超过了下面的 timeout，Master 则会认为蓝牙断开了连接；当 latency > 0 且 Slave 应用了 latency 时，如果 Slave 没有数据要发送，可以跳过回复一定个数的连接事件，此时 Master 没有收到 latency 个回复包，不会认为蓝牙断开了连接，从而达到 Slave 设备省电的目的
latency 取值范围 0-499，下图 latency 为3

![20240602113816](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240602113816.png)

#### Supervision Timeout

监控时间设置了一个超时时间，如果 Master 和 Slave 超过这个时间没有通信的话就会自动断开
单位 10ms，取值范围 10-3200
timeout 应该满足：timeout > (latency+1)*interval * N, N>=2
> 注：关于 n 的取值，《低功耗蓝牙开发指南》建议为 6，原文：
> 如果将从设备延迟设为可行的最大值，在监控超时发生前从设备只能获取唯一一次的侦听主设备的机会，这并不是一个好的处理方法。因此，建议至少给从设备留出 6 次侦听的机会，如果连接间隔为 100ms，从设备延迟为 9，那么监控超时应该至少为 6S，这样一来，链路在最终断开前从设备至少会有 6 次侦听的机会。
> n 的取值过小会降低链路的容错能力，过大时也会导致当对端设备断电时，需要等待较长的时间才会上报设备断开信息，n 的取值可以根据实际应用情况调整。

不同配置的连接参数对通信速率和功耗的影响：
* interval 缩短，Master 和 Slave 通信频率增加，数据发送周期缩短，数据发送速度增加，功耗增加
* interval 变长，Master 和 Slave 通信频率减少，数据发送周期增长，数据发送速度降低，功耗降低
* latency 增加，Slave 回复次数减少，功耗降低

<!-- ### 连接参数更新涉及的 LL 事件

* Slave 发起更新请求 LL_CONNECTION_PARAM_REQ
  * Master 拒绝：LL_REJECT_EXT_IND
  * Master 接收：LL_CONNECTION_UPDATE_IND
* Master 发起更新请求 LL_CONNECTION_PARAM_REQ
  *  -->

![20240602115339](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240602115339.png)

### Q&A

#### 连接间隔 和 连接事件长度 区别

1. 连接间隔，决定主从设备**通信的频率**：
   - 值越小，通信越频繁（低延迟，高功耗）。
   - 值越大，通信间隔越长（高延迟，低功耗）。
2. 连接事件长度，决定每次连接事件中**可交换的数据量**：
   - 值越大，单次事件可传输更多数据（高吞吐量）。
   - 值越小，通信时间越短（低功耗）。

