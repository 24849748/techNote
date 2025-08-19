# RT-thread学习


**在线资料：**
>[Rt-thread官网资料](https://www.rt-thread.org/document/site/#/)
>[RTT论坛](https://club.rt-thread.org/ask/tag/95e5c3c0a60881a0.html)
>[RTT标准版在线文档](https://www.rt-thread.org/document/site/#/rt-thread-version/rt-thread-standard/README)
>[Studio开发工具文档](https://www.rt-thread.org/document/site/#/development-tools/rtthread-studio/README)



RTT不仅只有**实时**内核，还有丰富的组件
![image.png|610](https://raw.githubusercontent.com/24849748/PicBed/main/ob/202306081127400.png)


RTT有三个版本：
1. 标准版
2. Nano版：是标准版的极简内核
3. Smart版：标准版增加用户态功能

资料整理：
>  [在线API手册](https://www.rt-thread.org/document/api/)
>  [编程指南](F:\Data\RT-thread\01-资料整理\【编程指南】um4003-rtthread-programming-manual)
>  

使用工具下载（软件包）：
> env
> studio

## RTT移植

### 修改系统时钟（以F407 HSE 168M为例）
1. 在 `board.h` 中修改时钟有关的宏
```c
/*-------------------------- CLOCK CONFIG BEGIN --------------------------*

#define BSP_CLOCK_SOURCE                  ("HSE")
#define BSP_CLOCK_SOURCE_FREQ_MHZ         ((int32_t)8)
#define BSP_CLOCK_SYSTEM_FREQ_MHZ         ((int32_t)168)
```
2. 修改 `drv_clk.c` 中系统时钟配置函数 `system_clock_config()` 
```c
void system_clock_config(int target_freq_mhz)
{
    RCC_OscInitTypeDef RCC_OscInitStruct = { 0 };
    RCC_ClkInitTypeDef RCC_ClkInitStruct = { 0 };
    /** Configure the main internal regulator output voltage */
    __HAL_RCC_PWR_CLK_ENABLE();
    __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);
    /** Initializes the CPU, AHB and APB busses clocks*/
    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
    RCC_OscInitStruct.HSEState = RCC_HSE_ON;
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
    RCC_OscInitStruct.PLL.PLLM = 4;
    RCC_OscInitStruct.PLL.PLLN = target_freq_mhz;
    RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
    RCC_OscInitStruct.PLL.PLLQ = 4;
    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) ! = HAL_OK)
    {
        Error_Handler();
    }
    /** Initializes the CPU, AHB and APB busses clocks*/
    RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2;
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
    RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV4;
    RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV2;
    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_5) ! = HAL_OK)
    {
        Error_Handler();
    }
}
```


### RT-Thread studio工程文件
* `SConscript、SConstruct`：类似makefile文件
* `.project、.cproject`：eclipse文件相关
* `cconfig.h`：rtts自动生成的，用于gcc
* `linkscripts`：硬件平台的链接脚本文件，用于指定编译器和链接器在构建可执行文件时的内存分配和代码组织

```shell
.
├─.settings # IDE项目配置文件夹
├─applications # 应用程序
├─build # 编译文件
├─Debug # 调试文件
├─drivers # RTT 驱动层
├─libraries	# stm32 CMSIS和hal库相关文件
│  ├─CMSIS
│  └─STM32F4xx_HAL_Driver
├─linkscripts
│  └─STM32F407ZG
├─packages # 硬件平台的链接文件
└─rt-thread
```

# RTT kernal内核

* 对象管理：`object.c`
* 实时调度器：`schedule.c`
* 线程管理：`thread.c`
* 线程间通信：`ipc.c`
* 时钟管理：`clock.c`，`time.c`
* 内存管理：`mem.c`，`memheap.c` ...
* 设备管理：`device.c`


# 设备和驱动

* I/O设备
* UART
* UART v2
* PIN
* ADC
* CAN
* HW TIMER
* CPUTIME
* I2C
* PWM
* RTC
* SPI
* WATCHDOG
* WLAN
* SENSOR
* TOUCH
* CRYPTO
* AUDIO


## 使用笔记

### cubemx生成工程后添加 `SConscript` 文件
==不要在studio里用cubemx==
```python
import os
from building import * #导入building的所有模块

cwd = GetCurrentDir() #获取获取当前路径，并保存至变量cwd
src  = Glob('*.c') #获取当前目录下的所有 C 文件，并保存至src变量

# add cubemx drivers
#由于RT-Thread工程中存在部分相同函数文件，所以对src重新赋值
#文件中的stm32g4xx_it.c 、 system_stm32g4xx.c不加入构建
#其余文件按相同格式填写到下述括号内
src = Split('''
Src/stm32g4xx_hal_msp.c
Src/main.c
Src/dma.c
Src/gpio.c
Src/usart.c
''')

#创建路径列表，并保存至path中
path = [cwd]
path += [cwd + '/Inc']
#这是 RT-Thread 基于 SCons 扩展的一个方法（函数）。
group = DefineGroup('cubemx', src, depend = [''], CPPPATH = path)

Return('group')
```

cubemx生成的main文件，main函数要加 `__weak` 

### 内置FinSH指令集合

```shell
RT-Thread shell commands:
clear            - clear the terminal screen
version          - show RT-Thread version information
list_thread      - list thread
list_sem         - list semaphore in system
list_event       - list event in system
list_mutex       - list mutex in system
list_mailbox     - list mail box in system
list_msgqueue    - list message queue in system
list_mempool     - list memory pool in system
list_timer       - list timer in system
list_device      - list device in system
help             - RT-Thread shell help.
ps               - List threads in the system.
free             - Show the memory usage in the system.
reboot           - Reboot System
```

### 线程创建

```c
#define THREAD_STACK_SIZE    512

struct rt_thread th_name;

rt_uint8_t thread_stack[THREAD_STACK_SIZE] = {0};

void thread_entry(void *parameter)
{
    // do something
}

int main(void)
{
    rt_err_t ret = 0;

    ret = rt_thread_init(&th_name, "th_warn",
                        thread_entry, NULL,
                        thread_stack, sizeof(thread_stack),
                        1, 5);
    if(ret < 0)
    {
        LOG_E("th_warn init falied\n");
        return ret;
    }
    rt_thread_startup(&th_name)
}
```

除了上面像 FreeRTOS 那样静态创建线程，RTT 的线程还可以动态创建
#todo
```c

```

### 消息队列


### 串口对接


### 动态内存使用


## 使用ENV工具

编译
```shell
# env工具自带python环境，输入下面命令即可编译
scons
```

使用env创建工程mdk5工程
```shell
scons --target=mdk5
```

软件包管理
```shell
pkgs

# 在menuconfig菜单中修改软件包后
pkgs --update  # 更新、下载、删除

# 升级本地软件包信息
pkgs --upgrade
```

添加文件
