---
title: hex 文件分析
date: 2024-11-24 01:07:39
# description: 
# mermaid: true
categories:
  - misc
tags:
  - hex
published: true
---

## 格式

如果使用 vscode，建议安装 hex 高亮插件（Intel HEX format），方便阅读。

从横向空间看，可以将格式划分为
```
len(1) addr(2) cmd(3) data(len) end(1)
```

* len 表示后面的 data 段长度
* addr 表示 data 段数据起始地址
* cmd 表示 data 段数据用途
    * (00)Data Rrecord：用来记录数据，HEX 文件的大部分记录都是数据记录
    * (01) 文件结束记录：用来标识文件结束，放在文件的最后，标识 HEX 文件的结尾
    * (02) 扩展段地址记录：用来标识扩展段地址的记录
    * (03) 开始段地址记录：开始段地址记录
    * (04) 扩展线性地址记录：用来标识扩展线性地址的记录，==设置扩展地址==
    * (05) 开始线性地址记录：开始线性地址记录，==对应函数入口地址==
* end 为校验和：校验和 = 0xff & (0x100 - 累加和）

从竖向空间看，hex 固件文件分为三部分：
* 起始一行
* 中间数据
* 结尾两行

## 举例

### 起始+数据：
![Pasted_image_20231115145113](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/Pasted_image_20231115145113.png)

第一行，
04 表示将 0x0202 设置为拓展地址，并直到下一次遇到 04 前有效，
F6 是校验值，计算如下：
```
F6 = 0xff & (0x100 - (0x02 + 0x00 + 0x00 + 0x04 + 0x02 + 0x02))
```

第二行及往后，
00 表示数据，
10 表示中间有 16 个数据，
地址为 0x8000，实际对应 flash 中的地址为 `((0x0202 << 16) | 0x8000)`，即 `0x02028000`

### 数据+结束：
![Pasted_image_20231115145032](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/Pasted_image_20231115145032.png)

倒数第二行中，
05 其实表示的是函数入口，对应 .map 文件的 Image Entry point 字段
![Pasted_image_20231115152330](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/Pasted_image_20231115152330.png)

最后一行，01 表示文件结束

## 验证

使用厂商提供的烧录工具，发现烧录 bin 文件到 flash 的地址，与 hex 文件中的地址一致
![Pasted_image_20231115153029](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/Pasted_image_20231115153029.png)
