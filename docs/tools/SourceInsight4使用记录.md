---
title: SourceInsight4使用记录
date: 2024-11-15 00:14:19
# description: 
# mermaid: true
categories:
  - tools
tags:
  - SourceInsight4
---

## 使用记录

### 查找函数或变量的引用

选中函数或变量，右击，“Lookup Reference”(或者使用快捷键 “ctrl+/” )
options说明：

![20231101155227](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20231101155227.png)

## 添加工程

### 在工程下面新建一个用于存放si工程数据的目录

### 新建工程

![20231101151249](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20231101151249.png)

![20231101151746](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20231101151746.png)

![20231101151934](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20231101151934.png)

按tree形式添加源文件和头文件

![20231101152146](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20231101152146.png)

### 同步文件

![20231101152359](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20231101152359.png)

## 常用快捷键

快捷键保存在 utils.em 文件中

| 快捷键       | 说明                 |
| ------------ | -------------------- |
| ctrl+滚轮    | 放大缩小字体         |
| ctrl+G       | 跳转到当前文件某一行 |
| ctrl+H       | 替换字符             |
| Alt+Shift+S  | 同步文件             |
| ctrl+/       | 搜索                 |
| ctrl+,       | 后退                 |
| ctrl+.       | 前进                 |
| F8           | 高亮选中字符         |
| ctrl+F       | 查找                 |
| F3或shift+F3 | 往前查找             |
| F4或shift+F4 | 往后查找             |


## 其他设置

* 显示行号：Options -> File Type Options -> 勾选show line numbers
* 快捷键设置：Options  -> Key Assignments
* 字体设置：Options -> File Type Options -> Screen Font...