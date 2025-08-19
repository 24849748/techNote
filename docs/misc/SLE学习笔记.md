
## 术语认识

* Grant 管理节点，发送 “命令”，接收 “数据”
* Terminal 终端节点，接收 “命令”，发送 “数据”

## SLE 基本特性了解

* 调制模式: GFSK QPSK 8PSK
* 物理层带宽: 1M 2M 4M
* 码率: 帧类型2下 QPSK 3/4, 8PSK 3/4 1
* 连接个数: 最大4条
* WS63 支持 8 路
* 支持 SM4 和 AES-128 加密

## 应用开发上与 BLE 对比

* 都有 adv
* Device Discovery 等于 BLE adv+scan
* 类似 GATT 的 SSAP 规范
  * client、server 角色和 gatt 一样
  * 都有 client id、connected id 等
  * UUID
* 广播结构 ltv 结构

## 协议层

### Device Discovery

Terminal 等于 advertiser，Grant 等于 scaner

Terminal：
1. enable_sle，打开 SLE 开关。
2. sle_announce_seek_register_callbacks，注册设备公开和设备发现回调函数。
3. sle_set_local_addr，设置本地设备地址。
4. sle_set_local_name，设置本地设备名称。
5. sle_set_announce_param，设置设备公开参数。
6. sle_set_announce_data，设置设备公开数据。
7. sle_start_announce，启动设备公开。

Grant：
1. 调用 enable_sle，打开 SLE 开关。
2. sle_announce_seek_register_callbacks，注册设备公开和设备发现回调函数。
3. sle_set_local_addr，设置本地设备地址。
4. sle_set_local_name，设置本地设备名称。
5. sle_set_seek_param，设置设备发现参数。
6. sle_start_seek，启动设备发现，并在回调函数中获得正在进行设备公开的设备信息。

#### announce

anounce有两个角色，G/T，可选协商，待了解

### Connection Manager

有点像 BLE 中 GAP 的发起连接 + SMP 层
主要负责连接、配对、读取对端 RSSI

主要的接口：
* sle_connect_remote_device，向对端设备发起连接请求。
* sle_pair_remote_device，向对端设备发起配对请求。
* sle_get_paired_devices_num，获取当前配对设备数量。
* sle_get_paired_devices，获取当前配对设备信息。
* sle_get_pair_state，获取配对状态。

### SSAP

client、server 概念和 BLE GATT 一样，动作可能不一样
server 端负责 发送响应、通知、指示
client 端负责 接受响应、通知、指示

# 详细学习

[SLE基础服务层设备发现与服务管理](D:\Project\sle\星闪原始资料\星闪无线通信系统基础服务层设备发现与服务管理.pdf)

**协议栈设计**

* 基础应用层
* 基础服务层
* 星闪接入层

![20240911174336](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240911174336.png)


## 接入层

### 设备发现

**anounce数据结构**

![20240911171429](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240911171429.png)

**设备发现配置流程**

![20240911171321](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240911171321.png)


### 服务管理

**服务关系**

![20240911173019](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240911173019.png)

首要服务，类似 service
次要服务，类似 characteristic

**服务结构**

* 服务声明
* 服务引用
* 属性
* 方法
* 事件

## 基础服务层

### 传输通道

SLE 为传输通道定义了四种模式：
1. 基础模式
2. 透传模式
3. 流模式
4. 可靠模式

![20240911175111](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240911175111.png)

根据不同业务，基础服务层定义了不同的帧格式，并且每种帧都有其适用的传输模式

![20240911175933](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240911175933.png)