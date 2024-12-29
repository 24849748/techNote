---
title: mermaid 语法学习
date: 2024-04-28 23:55:32
categories:
  - tools
tags:
  - mermaid
---

## Mermaid 介绍
* 基于 Javascript 的绘图工具
* Typora 支持渲染 Mermaid 语法
* 使用 markdown 代码块编写，并选择语言 `mermaid`，如果工具支持即可渲染

## Mermaid 绘制流程图

### 基本语法
* `id[description]`
id 就是一个节点，后面是此 id 的描述文本
> 通常只用 id，不想写 description

#### 图表显示方向
`graph <dir>`
* TB (Top to Bottom)
* BT (Bottom to Top)
* LR (Left to Right)
* RL (Right to Left)

#### 节点形状
* 矩形：`[]`
* 长方形带圆角：`()`
* 长圆形：`([])`
* 圆形：`(())`
* 圆柱：`[()]`
* 菱形：`{}`
* 六角形：`{{}}`
* 平行四边形：`[/ /]` or `[\ \]` 

> 如果文本里带 `()` 等符号，使用 `""` 将文本包裹起来。

#### 连线
* 实线：`--`
* 虚线：`-.`
* 带箭头：`>`
* 实线有描述：`--description--` or `--|description|`
* 加粗实线：`==`

#### 注释
* 使用 `%%` 行注释

## 实战举例

### 单个节点连接多个节点
```mermaid
graph LR
    a --> b & c --> d
```

### 流程图
```mermaid
graph 
	注册开始 --> 发送广播帧
	发送广播帧 --超时--> 没回应 --> 注册结束
	发送广播帧 --> 有回应
	有回应 --没冲突--> 设备表 --> 分类完成
	有回应 --有冲突--> 冲突链表 --> 分类完成
	分类完成 --注册下一类型--> 发送广播帧
```

### 流程图嵌套
```mermaid
graph TB
    c1-->a2
    subgraph one
    a1-->a2
    end
    subgraph two
    b1-->b2
    end
    subgraph three
    c1-->c2
    end
```

### 时序图
```mermaid
sequenceDiagram
    键盘 -->> 键盘线程 : 发送重新注册请求
    %%键盘线程 ->> + bus1 : 删除
    键盘线程 ->> bus1 : 删除
    loop 注册
    键盘线程 ->> 键盘线程 : bus1、bus2 设备先后注册
    end
    %%bus1 ->> - 键盘线程 : 重新创建
    键盘线程 ->> bus1  : 重新创建
    键盘线程 -->> 键盘 : 发送已注册的设备信息
```

### 状态图
```mermaid
stateDiagram
[*] --> 暂停
    暂停 --> 播放
    暂停 --> 停止
    播放 --> 暂停
    播放 --> 停止
    停止 --> [*] 
```

## 参考连接
> [快速上手 mermadi 流程图](https://snowdreams1006.github.io/write/mermaid-flow-chart.html)
> 
