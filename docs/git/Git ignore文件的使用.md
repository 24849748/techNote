---
title: 【Git】.gitignore 文件的使用
date: 2024-11-08:00:00:00
categories:
  - git
tags:
  - Git
---

这里记录 .gitignore 文件的一些书写规则

```bash
# 忽略*.o和*.a文件
*.[oa]

# 忽略*.b和*.B文件，my.b除外
*.[bB]
!my.b

# 忽略dbg文件和dbg目录
dbg

# 只忽略dbg目录，不忽略dbg文件
dbg/

# 只忽略dbg文件，不忽略dbg目录
dbg
!dbg/

# 只忽略当前目录下的dbg文件和目录，子目录的dbg不在忽略范围内
/dbg
```