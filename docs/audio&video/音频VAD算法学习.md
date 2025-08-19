---
title: 音频VAD算法学习
date: 2024-06-20 17:22:55
categories:
- audio
tags:
- audio
- vad
---

<!-- ## 基础概念 -->

VAD(Voice Activity Detection)，语音活性检测。

作用是从一段语音信号中识别出语音片段与非语音片段。VAD 系统通常包括两部分：
1. 特征提取
2. 语音判决（我叫人声判决）

## 特征提取

通常特征提取分为五类：

* 基于能量
* 基于频域
* 倒谱
* 谐波
* 长时信息

## 语音判决

三类：

* 基于门限
* 统计模型
* 机器学习


VAD分类特征尤为重要，好的特征应该具备以下特性：

1. 区别能力
2. 噪声鲁棒性


## 参考资料

> https://blog.csdn.net/weixin_42788078/article/details/89634363

