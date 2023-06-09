红外是无线射频的一种，基于38kHz载波

38kHz无线载波，周期为 `1 / 38000` 约等于26.32 us，占空比 `1/3`（推荐1/3 ~ 1/4）

NEC协议是红外的一种编码方式
![Pasted image 20230511100311](https://raw.githubusercontent.com/24849748/PicBed/main/ob/202306091030472.png)


NEC协议由以下部分组成：
1. 前导码（9ms载波+4.5ms低电平）
2. 用户（地址）码
3. 用户（地址）反码
4. 数据码
5. 数据反码
6. 停止位（0.56ms载波）
7. 重复码（9ms载波+2.25ms低电平+0.56ms载波）+100ms延迟

其中，表示数据高低电平的格式是
* 逻辑1：0.56ms载波 + 1.69ms低电平
* 逻辑0：0.56ms载波 + 0.56ms低电平
![Pasted image 20230511100347](https://raw.githubusercontent.com/24849748/PicBed/main/ob/202306091049217.png)

NEC协议使用8bit反码用于检验出错
每个数据从LSB低有效位开始发送


一般，按下遥控器按键，发送一组命令序列后接着发送n个重复码
![Pasted image 20230511101051](https://raw.githubusercontent.com/24849748/PicBed/main/ob/202306091049127.png)


有的红外接收器为了提高接收灵敏度，输入高电平，输出的是相反的低电平

