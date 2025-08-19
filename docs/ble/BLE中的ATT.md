---
title: BLE中的ATT
date: 2024-05-19 14:15:15
categories:
- ble
tags:
- BLE
- 低功耗蓝牙
- ATT
- GATT
- profile
---


BLE ATT 应该是大部分应用开发最早接触的协议层。

本文将围绕 ATT、GATT、GAP、Profile、Service、Characteristic 这几个概念重点介绍。

### BLE中的C/S架构

### ATT 属性（服务里面带的）

```c
#define ATT_PROPERTY_BROADCAST              0x01
#define ATT_PROPERTY_READ                   0x02
#define ATT_PROPERTY_WRITE_WITHOUT_RESPONSE 0x04
#define ATT_PROPERTY_WRITE                  0x08
#define ATT_PROPERTY_NOTIFY                 0x10
#define ATT_PROPERTY_INDICATE               0x20
#define ATT_PROPERTY_AUTHENTICATED_SIGNED_WRITE 0x40
#define ATT_PROPERTY_EXTENDED_PROPERTIES    0x80
```


Central = 机顶盒
Peripheral = 遥控器
* Read：Central 读取 Peripheral 的值（机顶盒读取遥控器），适合静态数据
* Write With Response：Central 写入 Peripheral 并需要 Peripheral 回应
* Write Without Response/Write：无需回应的写入
* Notify：Peripheral 向 Central 发送通知，Central 可以通过 CCCD 特征来订阅通知
* Indicate：类似 Notify 但是需要 Peripheral 发送确认响应，适用确保数据传输可靠性的场景

