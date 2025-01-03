---
title: 【Git】将子文件夹独立为子模块
categories:
  - git
tags:
  - Git
---

* 一开始创建仓库没考虑很多，随着开发提交越来越多
* 希望将目录独立出来，保留该目录在原仓库的所有提交记录
* 作为原仓库的子仓库管理

```bash
# 1.在原仓库下提取要分离子文件夹的所有提交记录
git subtree split -P [subdir] -b [branch-temp]
```

```bash
# 2.原仓库外创建一个新的文件夹，并初始化为 git 仓库
mkdir [subdir]
git init

# 将原仓库的 [branch-temp] 分支拉取到新仓库
git pull [原仓库地址] [branch-temp]
```

```bash
# 3.移除原仓库 [subdir] 目录及其提交记录
git rm -rf [subdir]
git commit -m 'Remove some fxxking shit'

# 4.移除 1 分离出来的临时分支
git branch -D [branch-temp]

# 5.作为子模块与原仓库关联
git submodule add [新仓库地址] [subdir]
```

注意备份, 原来 .gitignore 忽略了的文件需要重新添加

> 参考链接：
> https://prinsss.github.io/splitting-a-subfolder-out-into-a-new-git-repository/

