---
title: WireShark使用笔记
date: 2024-11-15 00:12:52
# description: 
# mermaid: true
categories:
  - tools
tags:
  - WireShark
---

## 蓝牙

https://blog.csdn.net/zl374216459/article/details/105102770

### 过滤规则
* !(condition)：过滤掉所有符合condition的包
* 多条规则用 and/&& 连接起来，其他还有 || !=
* btle：显示所有的ble包
* btatt：只显示att数据包
* btsmp：只显示smp配对过程数据包
* btl2cap：只显示l2cap层的数据包
* 具体过滤器规则在 视图-内部-Support Protocols里搜索BT查看

举例
* (frame.len == 38) || (frame.len == 60)：只显示数据帧长度为38 或 60 的数据包
* !(btle.length == 0)：过滤掉长度为0的包


### 查看相对时间
1. 设置时间显示格式
   ![20240423190213](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240423190213.png)
2. 右键选中的条目设置 时间参考 或 快捷键Ctrl+T
   ![20240423190406](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240423190406.png)

### 添加主窗口显示列
以添加rssi为例，右键对应的位置，选择 **应用为列**
![20240423195338](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20240423195338.png)


参考
> https://docs.wireless-tech.cn/doc/34/
> https://mp.weixin.qq.com/s/67NdU7cLhPrtr54yCmbezA
> [提示 COM 口 187 行错误的解决办法](https://devzone.nordicsemi.com/f/nordic-q-a/107828/invalid-escape-sequence-s)
