
## 资料

* [Cortex-M处理器入门](d:/Docs/Cortex-M/ARM%20Cortex-M处理器入门.pdf)
* https://zh-cn.manuals.plus/_st/cortex-m0-plus-microcontrollers-manual
* https://github.com/JayHeng/cortex-m-spec

## 内核对比

![20241212144348](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20241212144348.png)


## 存储器映射

Cortex-M0(+) 处理器的 4G 存储空间从架构上被分为多个区域。总的被分成 8 大部分，每个部分 512M。 
![20241214185002](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20241214185002.png)

虽然映射已经被架构预先定义，但是实际分配却是很灵活的。 
1. 代码区域 (0x0000 0000~0x1FFF FFFF) 512M，主要用于存储代码 
2. SRAM区域 (0x2000 0000~0x3FFF FFFF) 512M，主要用于数据存储 
3. 外设区域 (0x4000 0000~0x5FFF FFFF) 512M，主要用于外设及数据存储。不允许执行程序 
4. RAM区域 (0x6000 0000~0x9FFF FFFF) 1GB，外部RAM区域，由两个512M区域组成 
5. 设备区域 (0xA000 0000~0xDFFF FFFF) 1GB，由两个512M组成。属性不同。主要用于外设和IO口，不允许程序执行，但是可以用作通用数据存储。 
6. 内部私有总线区域(0xE000 0000~0xE00F FFFF) 1MB。用于处理器内部的外设，包括中断控制器NVIC和调试部件，还有systick。不允许程序执行。 
7. 保留存储器空间 (0xE010 0000~0xFFFF FFFF) 511M用于保留。 

![20241214185141](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20241214185141.png)

上图为基于Cortex-M0+的stm32L053的存储器映射图。我们可以看到基本是与Cortex-M0内核是符合的。但是具体的分配具有很大的灵活性。 

片上FLASH在 0x08000000，SRAM在 0x20000000。

IO口在 0x50000000 - 0x50001FFF，占用了8K。 

APB1上的器件基地址为0x4000 0000； 
APB2上的外设基地址为0x4001 0000； 
AHB上的外设基地址为 0x4002 0000。


## 时钟系统

![20241223005453](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20241223005453.png)

![20241223101557](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20241223101557.png)

F0 的时钟树

![20241223102633](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20241223102633.png)

* HSI，高速内部时钟
* HSE，高速外部时钟
* LSI，低速内部时钟
* LSE，低速外部时钟



---
<!-- 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Memory Map Visualization</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f9f9f9;
        }
        .memory-map {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 200px;
        }
        .memory-label {
            font-size: 14px;
            margin: 5px 0;
        }
        .memory-bar {
            width: 50px;
            height: 400px;
            border: 2px solid black;
            position: relative;
            background-color: white;
        }
        .region {
            position: absolute;
            width: 100%;
            border: 1px dashed black;
            text-align: center;
            font-size: 12px;
        }
        .region-top {
            top: 0;
            height: 20%;
        }
        .region-middle {
            top: 20%;
            height: 60%;
            border: none;
        }
        .region-bottom {
            top: 80%;
            height: 20%;
        }
        .label-top {
            color: purple;
            font-weight: bold;
        }
        .label-middle {
            color: red;
            font-weight: bold;
        }
        .label-bottom {
            color: green;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="memory-map">
        <div class="memory-label label-top">0x0208 0000</div>
        <div class="memory-bar">
            <div class="region region-top"></div>
            <div class="region region-middle"></div>
            <div class="region region-bottom"></div>
        </div>
        <div class="memory-label label-middle">0x0204 1000</div>
        <div class="memory-label label-bottom">0x0200 2000</div>
    </div>
</body>
</html>


---
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>内存布局可视化</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f0f0f0;
        }
        .memory-map {
            display: flex;
            align-items: flex-start;
        }
        .labels {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            margin-right: 10px;
        }
        .labels div {
            font-size: 14px;
        }
        .bar-container {
            position: relative;
            width: 50px;
            height: 400px;
            border: 2px solid #000;
            background-color: #fff;
        }
        .region {
            position: absolute;
            width: 100%;
            text-align: center;
            color: #fff;
            font-size: 12px;
            line-height: 1.2;
        }
        .region-1 {
            height: 20%;
            top: 0;
            background-color: #4CAF50;
        }
        .region-2 {
            height: 30%;
            top: 20%;
            background-color: #2196F3;
        }
        .region-3 {
            height: 50%;
            top: 50%;
            background-color: #FF9800;
        }
    </style>
</head>
<body>
    <div class="memory-map">
        <div class="labels">
            <div>0x0800 0000</div>
            <div>0x0800 2000</div>
            <div>0x0800 5000</div>
            <div>0x0800 A000</div>
        </div>
        <div class="bar-container">
            <div class="region region-1">Bootloader</div>
            <div class="region region-2">Application</div>
            <div class="region region-3">User Data</div>
        </div>
    </div>
</body>
</html>

 -->

## 向量表

向量表是存储在闪存中的地址表，用于存储中断处理程序的入口地址。向量表通常位于闪存的起始位置，在复位时被加载到内存中。向量表中的每个条目都指向一个中断处理程序，当相应的中断发生时，处理器会跳转到该地址并执行中断处理程序。

```
; Vector Table Mapped to Address 0 at Reset-------------------------------------
                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors

__Vectors       DCD     __initial_sp                    ; 0,  load top of stack
                DCD     Reset_Handler                   ; 1,  reset handler
                DCD     NMI_Handler                     ; 2,  nmi handler
                DCD     HardFault_Handler               ; 3,  hard fault handler
                DCD     0                               ; 4,  Reserved
                DCD     0                               ; 5,  Reserved
                DCD     0                               ; 6,  Reserved
                DCD     0                               ; 7,  Reserved
                DCD     0                               ; 8,  Reserved
                DCD     0                               ; 9,  Reserved
                DCD     0                               ; 10, Reserved
                DCD     SVCall_Handler                  ; 11, svcall handler
                DCD     0                               ; 12, Reserved
                DCD     0                               ; 13, Reserved
                DCD     PendSV_Handler                  ; 14, pendsv handler
                DCD     SysTick_Handler                 ; 15, systick handler

                ; External Interrupts
                DCD    EXTI_IRQHandler                  ;  irq0  EXTI 
                DCD    WWDG_IRQHandler                  ;  irq1  WWDG 
                DCD    AON_WKUP_IRQHandler              ;  irq2  APB2AON Wakeup 
                DCD    BLE_IRQHandler                   ;  irq3  BLE Combined 
                DCD    RTC_IRQHandler                   ;  irq4  RTC
                DCD    DMAC_IRQHandler                  ;  irq5  DMAC 
                DCD    QSPI_IRQHandler                  ;  irq6  QSPI
                DCD    0                                ;  irq7  Reserved
                DCD    CRYPT_IRQHandler                 ;  irq8  CRYPT
                DCD    BOD_IRQHandler                   ;  irq9  BOD
                DCD    IWDG_IRQHandler                  ;  irq10 IWDG
                DCD    0                                ;  irq11 Reserved
                DCD    0                                ;  irq12 Reserved
                DCD    BLE_WKUP_IRQHandler              ;  irq13 BLE Wakeup
                DCD    0                                ;  irq14 Reserved
                DCD    ATMR_IRQHandler                  ;  irq15 Advance Timer
                DCD    BTMR_IRQHandler                  ;  irq16 Base Timer 
                DCD    CTMR2_IRQHandler                 ;  irq17 Common Timer2
                DCD    CTMR1_IRQHandler                 ;  irq18 Common Timer1
                DCD    0                                ;  irq19 Reserved
                DCD    0                                ;  irq20 Reserved
                DCD    CTMR3_IRQHandler                 ;  irq21 Common Timer3
                DCD    LTMR_IRQHandler                  ;  irq22 Lowpower Timer
                DCD    I2C1_IRQHandler                  ;  irq23 I2C1  
                DCD    0                                ;  irq24 Reserved
                DCD    SPI1_IRQHandler                  ;  irq25 SPI1
                DCD    SPI2_IRQHandler                  ;  irq26 SPI2
                DCD    UART1_IRQHandler                 ;  irq27 UART1
                DCD    UART2_IRQHandler                 ;  irq28 UART2
                DCD    0                                ;  irq29 Reserved
                DCD    SUART1_IRQHandler                ;  irq30 SUART1
                DCD    0                                ;  irq31 Reserved

__Vectors_End

__Vectors_Size  EQU  __Vectors_End - __Vectors
```

上面向量表长度 16+32 = 48

上电启动，把向量表拷贝到 sram 起始地址

```c
//SCB->VTOR = addr;
static void sysVector(uint32_t addr)
{
    uint32_t i;

    for (i = 0; i < LEN_VECTOR/*48*/; i++)
    {
        WR_32((SRAM_VECTOR + (i << 2)), RD_32(addr + (i << 2))); // copy
    }
}
```