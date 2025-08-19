
## 寄存器窗口

![20240921163045](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240921163045.png)
* R0~R12 是通用寄存器
* SP 是栈指针，分为 MSP（主堆栈指针）和 PSP（进程栈指针）
* LR 是链接寄存器，保存返回地址，当函数执行完毕时，能够通过 LR 返回调用函数。
* PC 是程序计数器，程序当前执行的地址
* PSR 是程序状态寄存器，包含条件标志和中断/异常状态





## 截图乱记

重新运行依次点这两个，记得在重新运行前打个断点

![20240921171328](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240921171328.png)

黄色箭头与PC寄存器对应

![20240921171158](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240921171158.png)


memory窗口，查看字节变量位置

![20240921171622](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240921171622.png)


汇编窗口中，跳转到具体位置
![20240921173413](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240921173413.png)



## hardfault 追溯

1. 找到 LR 寄存器
2. 进入错误的时候，不一定会给你压完整的栈
3. 在memory中，复制 SP 地址位置
4. 找疑似地址的变量，调成 4 字节宽度会很舒服
   ![20240921175824](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240921175824.png)
5. 

![20240921180300](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240921180300.png)