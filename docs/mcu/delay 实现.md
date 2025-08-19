
## 简单粗暴的实现

```c
void delay(uint32_t cnt)
{
    while(cnt--);
}
```

存在问题：
1. cnt 需要自己计算
2. 主频不一样，延迟时间不一样

## 使用硬件timer实现

```c

void timer_config(void)
{
// 配置 timer us 计数一次：
// 时钟配置为 1MHz
// 计数器位数看平台
}

void delay(uint32_t us)
{
    TIM1.TIMx_CNT = 0;

    while(TIM1.TIMx_CNT < us);
}
```

需要延时 ms，可通过两种方式实现：
1. us * 1000
2. 修改定时器配置，实现 1ms 计数一次


