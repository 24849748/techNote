
## 书写规范（置顶）
1. 传参是 void *时，不显式转换
2. 括号换行，当 if 只有一句时，不加括号
3. () 前面空格

## 变量初始化
对于变量的初始化，我们一般有两种方式：
* 声明的时候直接初始化
* 只声明，后续在初始化
```c
// 普通变量
uint32_t u32 = 0;	/*!< 声明时直接初始化 */

uint32_t u32;	/*!< 声明后再初始化 */
u32 = 0;

// 数组
uint8_t array[10] = {0};	/*!< 声明时直接初始化 */

uint8_t array[10];	/*!< 声明后再初始化 */
memset(array, 0, sizeof(array));
```

* 对于第一种方式，编译时会将初始化的值存在 code 数据段中（全局/静态存储区），上电加载时这些变量时会一并加载到内存中，访问相对较快；
* 对于第二种方式，编译时编译器不知道需要初始化为什么值，因此会存放在栈上。如果对于大数组，memset 可能会耗费一点时间

**memset()**
memset 的正规用法是只能用来初始化 **char** 类型的数组的，也就是说，它只接受 0x00-0xFF 的赋值。

如果对于 int 类型，比如 memset(,1,sizeof())，最后的结果就是 00000001000000010000000100000001 = 16843009

## goto
goto 语句后面不能声明临时变量了

```c
// 错误
goto error;
int var = 10;

// 正确
int ver = 10;
goto error;
```

## 取消内存对齐
### `__attribute__((packed))` & `#pragma pack(1)`

自己的理解：这两个都可以用于取消自定义结构体的内存对齐。通常机器为了提高运行效率，会对数据进行内存对齐。
```c title:11
typedef struct _test_t
{
    uint8_t a;
    uint32_t b;
    uint16_t c;  
}test_t;
```
由于内存对齐的作用，32 位机器下，sizeof(test_t) 的结果会是 12。
使用内存对齐后，
```c
typedef struct _test_t
{
    uint8_t a;
    uint32_t b;
    uint16_t c;  
} __attribute__((packed)) test_t; // __attribute__语法应该放在声明 ; 之前

// 或者

#pragma pack(1)  // 以 1 个字节对齐
typedef struct _test_t
{
    uint8_t a;
    uint32_t b;
    uint16_t c;  
}test_t;
#pragma pack()  // 取消字节对齐
```
a 和 b 之间的空位会被取消（b 往前挪动 3 个字节），这样`sizeof(test_t)`的结果就是 7。
而这两个语法跟编译器有关，区别在于：
* `__attribute__((packed))` 是 gcc 编译器特有；`#pragma pack(1)` 则兼容更多编译器
* `__attribute__((packed))` 仅适用于当前结构体，结构体里包含的其他结构体没有效果；`#pragma pack(1)` 则适用于往后的所有结构体，直到 `#pragma pack()` 

需要注意，取消内存对齐后，可能会对系统的运行效率尝试一定影响；反之，在部分场合（如嵌入式通讯）上，取消结构体对齐可以更优雅地定义和调用通讯协议的内容。

另外，当用在 enum 类型定义时，则暗示 enum 使用最小完整类型。

### `__attribute__((packed))` 与位域一起使用

利用取消内存对齐的"优雅"调用方式和结构体位域

### `pack (push,1)`
* #pragma  pack (push,1) 的作用是指把原来对齐方式设置**压栈**，并设新的对齐方式设置为一个字节对齐
* #pragma pack(pop) 的作用：恢复对齐状态

## 复杂声明

```c
int (*func())();    // foo 指针函数
int (*foo())[];     // foo 指针函数
int (*foo[])();     // foo 指针数组
int *foo[][];       // 二维数组，指针数组，每个元素都是整形指针
foo()();    // 非法
foo()[];    // 非法
foo[]();    // 非法
```

## c 语言编译、执行过程

## 函数指针与指针函数

## 结构体

## 字符串

## 关键字

### volatile

```c
volatile int i = 0;
int a = i;
// ... 其他代码，未明确告诉编译器对 i 操作过
int b = i;
```

* volatile 指明 变量 i 随时可能变化，告诉系统每次用它都必须从 i 的地址读取
* 即汇编代码会从 i 的地址读取数据
* 如果没有 volatile，编译器优化后，发现两次读取 i 的代码之间没有对 i 进行操作，会自动把上次读取给 a 的数据放给 b
* 所以 volatile 会保证这个特殊地址的稳定访问

> 菜鸟教程说明：https://www.runoob.com/w3cnote/c-volatile-keyword.html

### const

* 将变量定义为只读，不允许赋值
* 存放在 “只读数据段”中
* const 有变量基本属性，有类型、咱用存储单元
* const 定义的是常变量，define 定义的是常量，所以编译器能对 const 进行安全检查

### inline

内联，为了==减少函数调用开销==，将函数内的代码“复制”到调用的地方
* 在调用的地方，编译器需要看到函数定义
* 建议放在头文件里
    * 如果不放在头文件里，需要保证每处声明都一致
    * 而且在源文件里可能增加资源开销
    * 放在头文件里需要加上 `static`
        * 等同于在每份引用的源文件中都实现了这份代码，导致程序空间上的膨胀
        * ==但== 内联展开后减少了程序在时间上的开销
        * 避免被多次引用时产生的命名冲突（多重定义，redefine）
* 约等于宏定义，但编译器会对 inline 执行==类型检查==
* 函数执行时间要尽可能快

### extern

1. extern 时不能加上初始化，否则会 multiple definition 
2. 类型一定要严格一致，指针和数组不能替代
4. 声明外部变量发生在链接阶段，链接器不会语法检查

```c
extern char *str;
extern char str[]; // 不能替代，至于数组大小可写可不写
```

### static

##  __ containerof() 宏使用

```c
typedef struct
{
    led_strip_t parent;
    rmt_channel_t rmt_channel;
    uint32_t strip_len;
    uint8_t buffer[0];
} ws2812_t;

static esp_err_t ws2812_del(led_strip_t *strip)
{
    ws2812_t *ws2812 = __containerof(strip, ws2812_t, parent);
    free(ws2812);
    return ESP_OK;
}
```

`ws2812_t *ws2812 = __containerof(strip, ws2812_t, parent);` 
根据 `strip` 的结构体找到 `ws2812_t` 这个结构体的地址

用到以下宏

```c
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)

#define container_of(ptr, type, member) ({ \
    const typeof(((type *)0->member) *__mptr = (ptr); \
    (type *)((char *)__mptr - offsetof(type,member));})

```

0 是结构体首地址，强转成 TYPE 结构体后取 member 地址，可以获取到偏移的地址

## 输出格式符%
* ％d 整型输出，％ld 长整型输出，
* ％o 以八进制数形式输出整数，
* ％x 以十六进制数形式输出整数，
* ％u 以十进制数输出 unsigned 型数据（无符号数）。
* ％c 用来输出一个字符，
* ％s 用来输出一个字符串，
* ％f 用来输出实数，以小数形式输出，（备注：浮点数是不能定义如的精度的，所以“%6.2f”这种写法是“错误的”！！！）
* ％e 以指数形式输出实数，
* ％g 根据大小自动选 f 格式或 e 格式，且不输出无意义的零。
![[Pasted image 20230519182356.png|630]]

## 完整二进制输出

```c
// byte 8 位
void printf_bin_8(unsigned char num)
{
	int k;
	unsigned char *p = (unsigned char*)&num;

	for (int k = 7; k >= 0; k--) // 遍历 8 位
	{
		if (*p & (1 << k))
			printf("1");
		else
			printf("0");
	}
	printf("\r\n");
}

// 32 位数据
void printf_bin(int num)
{
	int i, j, k;
	//p 先指向 num 后面第 3 个字节的地址，即 num 的最高位字节地址
	unsigned char *p = (unsigned char*)&num + 3;

	for (i = 0; i < 4; i++) //依次处理 4 个字节 (32 位）
	{
		j = *(p - i); //取每个字节的首地址，从高位字节到低位字节，即 p p-1 p-2 p-3 地址处
		for (int k = 7; k >= 0; k--) //处理每个字节的 8 个位，注意字节内部的二进制数是按照人的习惯存储！
		{
			if (j & (1 << k))//1 左移 k 位，与单前的字节内容 j 进行或运算，如 k=7 时，00000000&10000000=0 ->该字节的最高位为 0
				printf("1");
			else
				printf("0");
		}
		printf(" ");//每 8 位加个空格，方便查看
	}
	printf("\r\n");
}
```

# 自问自答的疑惑

* `if(0 == a)`，为什么变量放后面？
    * 防止失误写成 `if(a = 0)`，写成 `0 = a` 编译器会报错
* `__weak`：弱函数，常用在回调函数的时候
    * 解决系统和用户之间函数重复定义的问题
    * 一般系统定义一个空回调，保证编译器不会报错
    * 如果用户自己定义回调函数，直接定义就好了，不需要考虑重复定义的问题
    * 最终编译器会优先选择用户定义的函数
