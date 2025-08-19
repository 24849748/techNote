

https://elec.alampy.com/stm32/communication/spi_protocol/

## SPI 协议简介

SPI（Serial Peripheral Interface）

* 是一种同步的串行通信协议，由 Motorola 公司在 1980 年代提出，用于芯片间通信
* 是一种主从式的通信协议，主设备可以同时控制多个从设备，但每个从设备只能被一个主设备控制
* 必须由主机发起通信（无论是发送还是接收），从机被动接受。从机不能主动发送数据。
* 通信速度快，但通信线路较多，常用于短距离的板内通信

### 特性
1. 同步：需要主机提供时钟信号
2. 串行：数据是一位一位发的
3. 全双工：同时进行发送接收
4. 主从工作方式
5. 四线
   * MOSI(DO)
   * MISO(DI)
   * SCK
   * CS

## 接口形式

* SCLK（Serial Clock）：时钟信号
* MOSI（Master Output / Slave Input）：主设备输出、从设备输入
* MISO（Master Input / Slave Output）：主设备输入、从设备输出
* CS（Chip Select）：片选信号，用于选择从设备

## 协议参数

* 时钟极性（CPOL，Clock Polarity）：时钟空闲状态为高电平还是低电平
* 时钟相位（CPHA，Clock Phase）：数据在时钟的第一个边沿采样还是第二个边沿采样
* 时钟频率（SCLK，Serial Clock）：时钟信号的频率
* 传输顺序：MSB 优先还是 LSB 优先

## 传输模式

* mode 0：CPOL=0，CPHA=0，SCK空闲低电平
* mode 1：CPOL=0，CPHA=1，SCK空闲低电平
* mode 2：CPOL=1，CPHA=0，SCK空闲高电平
* mode 3：CPOL=1，CPHA=1，SCK空闲高电平

![20241228211129](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20241228211129.png)

![20241228210934](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20241228210934.png)

## Flash 测试

### Flash(W25Qxx) 常用指令表

![20241228205751](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20241228205751.png)

```c
/*FLASH常用命令*/
#define W25X_WriteEnable                0x06
#define W25X_WriteDisable               0x04
#define W25X_ReadStatusReg              0x05
#define W25X_WriteStatusReg             0x01
#define W25X_ReadData                   0x03
#define W25X_FastReadData               0x0B
#define W25X_FastReadDual               0x3B
#define W25X_PageProgram                0x02
#define W25X_BlockErase                 0xD8
#define W25X_SectorErase                0x20
#define W25X_ChipErase                  0xC7
#define W25X_PowerDown                  0xB9
#define W25X_ReleasePowerDown           0xAB
#define W25X_DeviceID                   0xAB
#define W25X_ManufactDeviceID           0x90
#define W25X_JedecDeviceID              0x9F
/*其它*/
#define  sFLASH_ID                      0XEF4017
#define Dummy_Byte                      0xFF
```

