
## 新建HAL库工程

* 新建工程文件夹
	* Drivers：硬件相关的驱动层文件
		* BSP：板级支持包
		* CMSIS：CMSIS底层代码，如启动文件.s等
		* SYSTEM：系统级核心驱动代码
		* HAL：HAL库
	* Middlewares：中间层组件和第三方中间层文件
	* Output：工程编译输出文件
	* Projects：mdk工程文件
	* Users：hal库用户配置文件，main.c，中断处理文件，分散加载文件
* 新建工程框架
* 添加文件
* 魔术棒
	1. target
	2. output
	3. listing
	4. c/c++
	5. Debug
	6. utilities
	7. linker
	![[Pasted image 20230421113318.png]]
* main.c


## printf重定向
![[Pasted image 20230422225137.png]]



## RCC(Reset Clock Control)

### 复位
* 电源复位（PWR）：RST按键
* 备份寄存器（BKP）：纽扣电池

### 时钟
stm32有三种时钟源驱动系统时钟 `SYSCLK`
* 高速内部时钟 `HSI`
* 高速外部时钟 `HSE`
* 锁相环倍频时钟 `PLL` 
二级时钟源：（主要提供给其他器件）
* 40kHz低速内部RC振荡器 `LSI` 
    * 低功耗
    * 应用于独立看门狗、自动唤醒
* 32.768kHz `LSE` ，
    * 低功耗、精准
    * 应用于RTC 

频率越高，工作越快，但功耗也高

分频 `/` 倍频 `×`

#### 时钟树
使用外部HSE 8M高速晶振配置系统时钟到72MHz
![[Pasted image 20230501205851.png]]
```c
/**
 * @brief 系统时钟初始化，72MHz
 *
 */
static void sys_clock_init(void)
{
    RCC_OscInitTypeDef OscInit = {0};
    RCC_ClkInitTypeDef ClkInit = {0};

    OscInit.OscillatorType = RCC_OSCILLATORTYPE_HSE;    
    OscInit.HSEState = RCC_HSE_ON;   /* HSE开关状态 */
    OscInit.HSEPredivValue = RCC_HSE_PREDIV_DIV1;   /* HSE分频系数 */
    OscInit.PLL.PLLState = RCC_PLL_ON;      /* PLL开关状态 */
    OscInit.PLL.PLLSource = RCC_PLLSOURCE_HSE;  /* PLL输入源选择HSE */
    OscInit.PLL.PLLMUL = RCC_PLL_MUL9;     /* PLL倍频值：8*9 = 72MHz */
    if(HAL_OK != HAL_RCC_OscConfig(&OscInit))
    {
        while(1);
    }
    ClkInit.ClockType = (RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2);
    ClkInit.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK; /* 系统时钟输入源 */
    ClkInit.AHBCLKDivider = RCC_SYSCLK_DIV1;    /* AHB时钟线分频值 */
    ClkInit.APB1CLKDivider = RCC_HCLK_DIV2;     /* APB1时钟线分频值 */
    ClkInit.APB2CLKDivider = RCC_HCLK_DIV1;     /* APB2时钟线分频值 */
    if(HAL_OK != HAL_RCC_ClockConfig(&ClkInit, FLASH_LATENCY_2))
    {
        while(1);
    }
}
```
在CubeMX中配置：
![[Pasted image 20230505111712.png]]



## 启动流程

CM3处理器结构-哈佛结构
![[Pasted image 20230506101634.png]]

中断
![[Pasted image 20230506102336.png]]

中断向量表
![[Pasted image 20230506102258.png]]


* 芯片上电后触发**复位异常**
* 跳转到中断向量表特定偏移地址（复位0x04），并获取里面的内容

也就是说，修改复位异常内容，就可以让处理器去执行我们指定的操作

触发异常->中断向量表->用户程序


配置BOOT启动电平选择复位后的**启动模式**
![[Pasted image 20230506102842.png]]
* 主闪存（flash）：非易失性
* system memory：主芯片内部一块特定区域
* SRAM：芯片内置的RAM，掉电易失

**启动文件：startup_xxx.s 汇编文件**
在顶部注释里写了这个文件做的内容
- 【初始化堆栈指针】Set the initial SP
* 【设置pc指针的值】Set the initial PC == Reset_Handler
* 【设置中断向量表】Set the vector table entries with the exceptions ISR address
* 【配置系统时钟】Configure the clock system
* 【调用c库main函数】Branches to `__main` in the C library (which eventually calls main()).

总流程（上电到执行main函数）：
1. **确定boot启动方式**
2. **初始化sp、pc指针**
    * 系统复位后，处理器从向量表中读取前八字节（两条指令），前四个字节存入MSP，后四个字节为复位向量，就是程序执行起始地址
    * 将0x08000000 堆栈栈顶地址存到SP中（MSP）
    * 将0x08000004 向量地址存入PC程序计数器
    * sp即`_initial_sp`，pc即`Reset_Handler`，PC指针指向物理地址取出的第1条指令开始的执行程序，也就是开始执行复位中断服务程序 Reset_Handler，然后从Reset_Handler处执行代码
3. **初始化系统时钟**
    1.  Reset_Handler调用SysetmInit函数，对系统时钟初始化
4. **初始化用户堆栈**
    * 程序执行到 `LDR     R0, =__main`，跳转到 `__main` 程序段运行，`__main` 就是标准库中的函数，会调用c文件中的main函数
    ![[Pasted image 20230506110212.png]]
5. **进入main函数**




## 中断

### GPIO外部中断`EXTI0~15`处理流程：
1. 设置输入模式
2. 设置EXTI和IO口的映射关系【使能AFIO或SYSCFG时钟】
3. EXTI <----- ===其他外设`EXTI16、17...` 无需经过GPIO的中断===
4. 设置中断分组、优先级、使能【NVIC】<--- ===外设中断`USART/TIM/SPI...`===
5. 按优先级顺序依次处理中断


### 配置外部中断步骤：
1. 使能IO时钟，初始化IO为输入`_HAL_RCC_GPIOx_CLK_ENABLE()`
2. 配置IO口结构体`HAL_GPIO_Init()`
	HAL_GPIO_Init 时函数内部会通过判断Mode 的值来开启 SYSCFG 时钟，并且设置 IO 口和中断线的映射关系
3. 配置中断优先级NVIC，并中断使能
	```c
	//抢占优先级为 2，子优先级为 0
	HAL_NVIC_SetPriority(EXTI0_IRQn,2,0); 
	//使能中断线 2
	HAL_NVIC_EnableIRQ(EXTI0_IRQn); 
	```
4. 编写中断服务函数
	`void HAL_GPIO_EXTI_IRQHandler()` 清除中断标志
	`void HAL_GPIO_EXTI_Callback()`
	中断服务函数在.s文件里定义
5. 


~~todo：抢占优先级？子优先级？~~
`F:\Data\stm32\8，STM32参考资料` 资料里有`STM32中断优先级与相关使用概念`


抢占优先级（preemption priority / group priority）
响应优先级（sub priority）【子优先级】
* 低优先级无法打断高优先级，高可以打断低
* pre优先级不同，pre优先级高的先执行
* pre优先级相同，sub优先级高的先执行，但sub高的无法打断低的
* 如果pre和sub都相同，优先执行异常号低的

（异常号：异常向量表位置，cortex m3权威指南第七章、参考手册第九章表格左边位置）

STM32F03系列有16个可编程优先级

寄存器：
* SCB_AIRCR 应用中断和重启控制寄存器，PRIGROUP决定pre和sub优先级的分隔（16个优先级的由来）




## HAL库文件理解

* mspinit文件：包括mspinit函数，在调用HAL_Init()函数时会自动调用
* 类似回调？暂不清楚怎么实现全局找到该函数【不重要】



## 定时器



* 基本定时器：主要用于驱动DAC（TIM6、7）
* 通用定时器：定时计数，PWM输出，输入捕获，输出比较（TIMx）
* 高级定时器：带死区控制盒紧急刹车，可应用于PWM电机控制（TIM1、8），c8t6只有一个

![[Pasted image 20230510100954.png]]
（绿色是时基单元CNT、PSC、ARR）


### 通用定时器

* 时基单元
* 捕获和对比通道
* 时钟控制单元

![[Pasted image 20230511104839.png]]

* 位于低速总线APB1上
* 16bit 向上、向下、向上向下计数模式，自动装载计数器（TIMx_CNT）
* 16bit 可编程预分频器（TIMx_PSC），计数器时钟分频系数为 1~65535之间的任意数值
* 4个独立通道，可用于
    * 输入捕获
    * 输出比较
    * PWM生成
    * 单脉冲模式输出
* 可用外部信号（TIMx_ETR）控制定时器和定时器互联的同步电路（1个定时器控制另一个定时器）
* 可根据事件产生中断/DMA（6个独立的IRQ/DMA请求生成器）
    * 更新
    * 触发事件
    * 输入捕获
    * 输出比较
    * 支持针对定位的增量编码器、霍尔传感器电路
    * 触发输入作为外部时钟或按周期的电流管理

**三种计数器模式**
* 向上计数模式：计数器从0计数到自动加载值（TIMx_ARR），然后重新从0开始计数并且产生一个计数器溢出事件。
* 向下计数模式：计数器从自动装入的值（TIMx_ARR）开始向下计数到0，然后从自动装入的值重新开始，并产生一个计数器向下溢出事件。
* 中央对齐模式（向上/向下计数）：计数器从0开始计数到自动装入的值-1，产生一个计数器溢出事件，然后向下计数到1并且产生一个计数器溢出事件；然后再从0开始重新计数。
![[Pasted image 20230509101900.png]]

![[Pasted image 20230509102209.png]]

**时基单元**
* 计数器寄存器 `TIMx_CNT`
* 预分频器寄存器 `TIMx_PSC`
* 自动装载寄存器 `TIMx_ARR`

**相关配置寄存器**
* 计数器当前值寄存器（TIMx_CNT）
* 预分频寄存器（TIMx_PSC）
    * 对CK_PSC进行预分频。此时需要注意：**CK_CNT计算的时候，预分频系数要+1**。
* 自动重装载寄存器（TIMx_ARR）
* 控制寄存器（TIMx_CR1）
* DMA/中断使能寄存器（TIMx_DIER）

**定时器超时（溢出）时间**

**Tout=（ARR+1)(PSC+1)/TIMxCLK**
![[Pasted image 20230509104722.png]]

其中：Tout的单位为us，TIMxCLK的单位为MHz。
这里需要注意的是：**PSC预分频系数需要加1，同时自动重加载值也需要加1。**
-   **为什么自动重加载值需要加1，因为从ARR到0之间的数字是ARR+1个；**
-   **为什么预分频系数需要加1，因为为了避免预分频系数不设置的时候取0的情况，使之从1开始。**


### PWM
![[Pasted image 20230510124926.png]]
占空比（脉宽）
![[Pasted image 20230510125007.png]]

比较值CCRx，自动重载值ARR
* 当定时器从0计数到CCRx时，对应输出pin的电平翻转
* 当计数到ARR时，再次翻转
* 0~CCRx是一个电平，CCRx~ARR是另外一个电平，电平的高低由起始电平决定
* 影响PWM频率和占空比的因素
    * ARR：决定PWM周期
    * CCRx：决定PWM占空比



## To Learn
* [STM32经典功能 Cotrex-M3学习](https://mp.weixin.qq.com/s/I0ZgMB-2rLHhwcmA3B4A5w)
* 



