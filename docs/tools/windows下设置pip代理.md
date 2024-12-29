---
title: windows 下配置 pip 代理及镜像源
date: 2024-11-25 13:50:33
# description: 
# mermaid: true
categories:
  - tools
tags:
  - pip, windows
published: true
---

这里使用的是清华大学的源：
`https://pypi.tuna.tsinghua.edu.cn/simple`
本地代理地址是：
`http://127.0.0.1:7890`
根据实际情况修改

## 单次配置

```bash
pip install --proxy http://127.0.0.1:7890 -i https://pypi.tuna.tsinghua.edu.cn/simple [package-name] 
```

## 全局配置

在用户目录下新建 `pip` 目录，并新建 `pip.ini` 文件，内容如下：
```ini
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
proxy     = http://127.0.0.1:7890

[install]
trusted-host=pypi.tuna.tsinghua.edu.cn
```

## 检查配置

```bash
pip config list
```

## 其他国内镜像源

阿里云：http://mirrors.aliyun.com/pypi/simple/
中国科学技术大学：https://pypi.mirrors.ustc.edu.cn/simple
豆瓣：http://pypi.douban.com/simple/
