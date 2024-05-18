---
title: Python使用笔记
date: 2024-05-18 21:39:47
categories:
- code
tags:
- Python
---

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [不定参实现](#不定参实现)
- [传参默认值](#传参默认值)
- [程序入口](#程序入口)
- [其他](#其他)

<!-- /code_chunk_output -->


### 不定参实现

`*args **kwargs`

```python
def func(arg1, arg2, *args, **kwargs):
    print(f"arg1: {arg1}")
    print(f"arg2: {arg2}")
    
    for arg in args:
        print(f"Additional arg: {arg}")
    
    for key, value in kwargs.items():
        print(f"{key}: {value}")

# 使用混合的参数
func('value1', 'value2', 'extra1', 'extra2', key1='value1', key2='value2')
```

### 传参默认值

```python
# 直接在参数后面 = 即可，如果需要指定类型，在类型后面再 = 
def func(arg1=1, arg2:str="2"):
    pass

# python 要求在调用函数时，非默认参数必须出现在默认参数之前。
def func(arg1=1, arg2) # 错误的
    pass
    
def func(arg1, arg2=1) # 正确的
    pass
```

### 程序入口

python 中，`if __name__ == "__main__":` 表示的是当前程序以非模块的方式被执行时的入口，可以简单理解为 main 函数。

当当前程序作为模块被其他模块 import 时，如果不在这句语法内执行的代码，都会被运行一遍

### 其他

1. 路径作为字符串前面要加上 `r`，因为包含 `\`，
2. os.walk 返回的文件路径是当前 python 文件的路径
