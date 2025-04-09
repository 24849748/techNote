---
title: c语言likely()和unlikely()宏
date: 2025-04-09 09:47:58
categories:
  - code
tags:
  - c
---

```c
if (likely(condition)) { // 等效于 if(conditon)
} 

if (unlikely(condition)) { // 也等效于 if(conditon)
}
```

宏展开：
```c
#define likely(x)   __builtin_expect(!!(x), 1)
#define unlikely(x) __builtin_expect(!!(x), 0)
```

`__builtin_expect()` 是 gcc (version >= 2.96) 提供的内建函数，目的是将分支转移信息告诉编译器，编译器决定将哪部分代码放在前面，**以减少指令跳转带来的性能下降**。


## 总结

1. `likely()` 和 `unlikely()` 是 gcc 编译器提供的内建函数
2. `likely()` 和 `unlikely()` 用于**分支预测**，告诉编译器某个分支很可能会被执行，或者某个分支很不可能被执行，从而优化代码的执行顺序，提高程序的性能。
3. `likely()` 表示条件为 `True` 的可能性更大
4. `unlikey()` 表示条件为 `False` 的可能性更大

