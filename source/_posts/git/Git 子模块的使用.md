---
title: 【Git】子模块 submodule 的使用
date: 2024-11-08:00:00:00
categories:
  - git
tags:
  - Git
---

子模块是 git 仓库中的仓库，在一些大型工程中比较常见。
对于 git 来说，子模块仅是主仓库管理的一个指向子仓库某个提交的指针。
虽然在物理层面上来说子模块的代码、文件都在主仓库里，但子模块的 git 管理是独立的。

## 拉取子模块

```bash
# clone 时拉取
git clone --recursive <url>

# clone 后拉取
git submodule init
git submodule update
```

对于上面两种方式，都会将主仓库下的所有子模块都拉取下来

如果只想拉取某个子模块，可以指定子模块的名称
```bash
# clone 完之后，首次更新子仓库，后续更新可以无需 --init
git submodule update --init [sub_repo_name]
```

## 子模块的修改和更新

这里应该分两种情况讨论：
1. 子模块是自己修改的
2. 子模块是他人修改的

对于第一种情况：
```bash
# 对子仓库代码进行提交推送
git add
git commit
git push
# 切换到主仓库，可以看到主仓库的子模块版本信息已经更新
# 我们需要更新主仓库引用该子模块的 commit id，这样当别人使用主仓库时，才会拉取到我们修改后的子模块代码
git add [submodule_name]
git commit
```

对于第二种情况：
```bash
# 更新子模块代码，git 会自动根据子模块版本信息更新所有子模块目录相关代码
git submodule update
# 也可以切换到子模块目录下，使用 git pull 更新子模块代码
cd [submodule_name]
git pull

# 同时，由于他人也更新了主仓库的子模块版本信息，我们需要更新主仓库的最新提交
git pull
```

## 创建 submodule

比如需要将子模块 `submodule` 添加到主仓库 `main` 中

```bash
git submodule add <submodule_url> [子模块在主仓库中的路径]
```

此时 git 仓库会多出：
1. `.gitmodules`
2. `.git/config` 的一些信息
3. `.git/modules`

## 删除子模块

```bash
# 移除 .git/config 中的子模块信息，如果子模块本地有修改，加 --force
git submodule deinit [submodule_name]
# 移除 .gitmodule 相关内容
git rm [submodule_name]
# 移除 .git/modules 残余信息
git commit -m "rm submodule"
```

### 更换子模块 url

```bash
# 1. 直接修改 .gitmodule 文件中的 url 链接
# 2. 更新
git submodule sync
# 3. 初始化子模块
git submodule init
# 4. 更新
git submodule update
```