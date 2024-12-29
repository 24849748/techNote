---
title: BLE 中的 HCI
date: 2024-05-19 14:15:19
categories:
- ble
tags:
- BLE
- 低功耗蓝牙
- HCI
# published: false
---

HCI（HOST Controller Interface）是 Host 和 Controller 之间数据交互的接口。

HCI 上传输的数据分 5 种：

1. HCI Command，是协议栈通过给上层发送命令来控制芯片的行为
2. HCI ACL 数据，协议栈跟芯片双向交互的 L2CAP 以及上层数据
3. HCI SCO 数据：协议栈跟蓝牙芯片双向交互的音频数据
4. HCI Event：发送给对端 BLE 的 HCI 事件
5. HCI ISO 数据，蓝牙协议栈跟蓝牙芯片交互的 BLE audio 的数据（Core 5.2 才增加）

![20240522182342](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240522182342.png)

详细的数据格式参考 *蓝牙核心规范 Vol 4，Part E，第 5.4 小节*，下面我们简单了解一下 HCI Command 和 HCI Event 的格式，并重点关注一下常见的 HCI 错误码。

### HCI Command

HCI Command 用于从 Controller 发送命令到 Host，具体格式如下图：

![20240522183841](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240522183841.png)

OpCode: 长度 2byte 的操作码，分两个字段：

* OGF(Opcode Group Field)：操作码组字段，占高 6bit
* OCF(Opcode Command Field)：操作码命令字段，占低 10bit

OGF 分以下几组：

* 0x01: Link Control commands，链路控制的，控制蓝牙跟 remote 沟通的
* 0x02: Link Policy commands，链路策略，比如转换角色等
* 0x03: HCI Control and Baseband commands，控制本地芯片跟基带的 OGF，比如 reset 本地芯片
* 0x04: Informational Parameters commands，读取信息，本地芯片的 LMP 版本、支持的 command、蓝牙地址等
* 0x05: status parameters commands，读取状态的命令，比如 rssi
* 0x06: Testing commands（进入测试模式的命令，DUT，device under test）
* 0x08: LE Controller commands，
* 0x3F: vendor-specific debug commands，厂商定义的

OCF 很多，每个 OCF 后面带参数总长度，参数。

HCI Command Packet 的长度不能超过 255（包括包头 2+1+1 个字节）

### HCI Event

![20240522184922](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240522184922.png)

* Event Code：唯一事件代码
* Parameter Total：后面参数长度
* Event Parameter：事件参数

HCI 主要分为三种基本事件类型：

1. 通用命令完成事件
2. 通用命令状态事件
3. 特殊命令完成事件

具体 HCI 事件查看 *蓝牙核心规范 Vol 4，Part E，第 7.7 小节* 。

### BLE 断连常见 HCI 错误码

* 0x08 - Connection Timeout
  * 连接超时。这个错误通常发生在连接的一方没有在预期时间内接收到对方的响应。
* 0x13 - Remote User Terminated Connection
  * 远程用户终止了连接。这个错误表示对方设备主动断开了连接。
* 0x14 - Remote Device Terminated Connection Due To Low Resources
  * 远程设备由于资源不足而终止了连接。可能是由于内存不足、电池电量低等原因。
* 0x16 - Connection Terminated by Local Host
  * 本地主机终止了连接。这个错误表示本地设备主动断开了连接。
* 0x3E - Connection Failed to be Established
  * 连接建立失败。这个错误表示连接尝试未成功。
* 0x22 - Instant Passed
  * 在链路层事件中，"Instant" 是一个时间点，用于标记特定事件的时间。如果在到达这个时间点之前未完成预定的操作，就会产生这个错误。
* 0x42 - Unacceptable Connection Parameters
  * 不可接受的连接参数。设备在连接过程中交换了连接参数，但这些参数不被接受。
* 0x28 - Instant Passed
  * 链路层事件中指定的时间点已过，通常在通道映射更新过程中发生。
* 0x3B - MAC Connection Failed
  * MAC 层连接失败。这个错误可能与硬件相关的问题有关。

更多错误码，可在 *蓝牙核心规范 Vol 1，Part F，第 2 小节*  查看
