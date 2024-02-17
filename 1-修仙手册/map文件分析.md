
## c语言存储区域

1. 代码段
2. 数据
    1. 初始化（只读RO、以初始化读写RW）数据
    2. 未初始化（.bss）
3. 堆栈
    1. heap（malloc）
    2. stack（由编译器自动分配释放）


## ARM程序

RO段、RW段、ZI段

ROM拷贝到RAM
* text和data段在固件中，由系统加载
* 而bss由系统初始化

FLASH = Code + RO + RW
RAM = RW + ZI + 堆栈


## 段的使用

全局区（静态区）对应下面几个段：
* 只读（RO Data）
* 读写（RW Data）
* 未初始化（BSS Data）

对于变量
* 函数内声明的变量在stack上
* malloc等动态分配的在heap上
* 字符串、const修饰的放在RO区
* 其他全局变量
    * 初始化的放在RW区
    * 未初始化的放在ZI（bss）区


## map文件
分位5个部分

### 函数调用关系
Section Cross Reference
![[../addon/Pasted image 20240130014831.png]]
`cb_putc()` 这个函数内调用了 `apUART_Check_TXFIFO_FULL()` 和 `UART_SendData()`
![[../addon/Pasted image 20240130014950.png]]

### 被优化的冗余函数
Removing Unused input sections from the image.
![[../addon/Pasted image 20240130014754.png]]

### 局部标签和全局标签
Image Symbol Table
![[../addon/Pasted image 20240130015153.png]]

### 固件的内存映射
Memory Map of the image
    Load Region LR_IROM1
![[../addon/Pasted image 20240130015538.png]]
    Execution Region RW_IRAM1
![[../addon/Pasted image 20240130015845.png]]

### 固件大小
![[../addon/Pasted image 20240130020229.png]]



## ARM工程查看堆栈大小
看startup_xxx.s文件
![[../addon/Pasted image 20240130021605.png]]





