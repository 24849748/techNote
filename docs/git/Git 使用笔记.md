---
title: Git使用笔记
categories:
  - git
tags:
  - Git
published: false
date: 2024-04-27 23:55:32
---

# Git 使用笔记

* git 仓库中保存记录就是快照
* branch 前面带 `*` 号为当前分支
* .gitignore 对路径符号有严格要求。必须用 `/`

```
[user]
        name = lijianpeng
        email = bosco@pthyidh.com
[credential "http://121.43.179.105:9001"]
        provider = generic
[core]
        autocrlf = false
[credential]
        helper = store
```

### git 指定仓库初始化分支

```shell
git init -b main
git config --global init.defaultBranch main
```

### 重命名分支

```shell
git branch -m [new-name] ## 当前分支
git branch -m [old-branch] [new-branch] ## 指定分支
```

### 将子目录独立为一个新仓库

> https://prinsss.github.io/splitting-a-subfolder-out-into-a-new-git-repository/

* 一开始创建仓库没考虑很多，随着开发提交越来越多
* 希望将目录独立出来，保留该目录在原仓库的所有提交记录
* 作为原仓库的子仓库管理

```shell
# 1.在原仓库下提取要分离子文件夹的所有提交记录
git subtree split -P [subdir] -b [branch-temp]
```

```shell
# 2.原仓库外创建一个新的文件夹，并初始化为 git 仓库
mkdir [subdir]
git init

# 将原仓库的 [branch-temp] 分支拉取到新仓库
git pull [原仓库地址] [branch-temp]
```

```shell
# 3.移除原仓库 [subdir] 目录及其提交记录
git rm -rf [subdir]
git commit -m 'Remove some fxxking shit'

# 4.移除 1 分离出来的临时分支
git branch -D [branch-temp]

# 5.作为子模块与原仓库关联
git submodule add [新仓库地址] [subdir]
```

注意备份, 原来 .gitignore 忽略的文件可能需要重新添加

### 更换子模块 url

```shell
## 1. 修改 .gitmodule url 链接
## 2. 更新
git submodule sync
## 3. 初始化子模块
git submodule init
## 4. 更新
git submodule update
```

### git stash 进阶使用

```shell
# 等同于 git stash
git stash push

# 指定某个文件，并添加 commit 信息
git stash push -m "commit message" file1 file2

# 查看 stash 记录
git stash list

# 恢复某个 stash 并删除 stash 记录
git stash pop stash@{0}

# 恢复某个 stash，但不删除 stash 记录
git stash apply stash@{0}

# 删除某个 stash
git stash drop stash@{0}

# 删除所有 stash
git stash clear
```

### gitignore 特殊规则

```
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

### git 忽略某一行

前面有提到 [git 停止追踪某个文件](#git 停止追踪某个文件)
场景
* 开发中添加了很多测试代码
* 这些测试代码不想提交到远程
* 希望下次还要用到

步骤
1. 配置 git config filter 规则
    git config --global filter.gitignore.clean "sed '/\/\/ @noCommit start/,/\/\/ @noCommit end$/d'"
    git config --global filter.gitignore.smudge cat
1. 在根目录中创建 `.gitattributes` 文件，并添加以下内容
```
xxx.js filter=gitignore
```
4. 在代码中需要屏蔽的测试代码前后添加 // @noCommit start，// @noCommit end

局限性
* 仅限于新增代码，对已提交的代码修改无效

### 子模块使用记录
场景
* ptduino 仓库上
* 需要同时修改仓库

```shell
cd 子仓库
# 你的代码修改
git add
git commit
git push

cd 主仓库

git commit # 同步子仓库的更新节点
git push
```

### git 存储账户密码
场景
* 新装了虚拟机 Linux 环境
* 有时 `git pull & push` 会提示要输入账户密码

可能是本地没有存储账户密码凭证，使用一下命令配置
```shell
git config --global credential.helper store
```

### .gitattributes
* 用来管理 git 行为
* 会覆盖 git 全局配置
* 可以确保当前 repo 下所有用户表现一致，不受系统和环境影响
```
text=auto eol=lf
```

```shell
# 会把所有的文件按照当前的。gitattributes 一次性修复并添加到 Git 中。
git add --renormalize .
```

### 子模块使用
场景：
* clone 一个带有子仓库的仓库
* 子仓库没有拉取

```shell
# clone 完之后，首次更新子仓库，后续更新可以无需 --init
git submodule update --init [sub_repo_name]
```

```shell
# 要在克隆的时候带上子模块一起
git clone --recursive [url]
```

### archive 打包发布
场景：
* 将仓库打包成压缩包

```shell
# 查看受支持的文件格式
git archive -l

# 基础用法 output 指定输出文件名；format 指定格式，如果不指定 git 会根据 output 自动猜测
git archive --format zip --output "output.zip" master
```

### submodule 子模块

[参考链接](https://zhuanlan.zhihu.com/p/87053283)

#### 创建 submodule

需要将子模块 `submodule` 添加到主仓库 `main` 中
```shell
git submodule add <submodule_url> [别名]
```

git 仓库会多出：
1. `.gitmodules`
2. `.git/config` 的一些信息
3. `.git/modules`

#### 获取 submodule

对于别的使用者，直接使用 git clone main 仓库不会把 submodule 的内容克隆下来，有两种方法克隆：
1. 在克隆主项目的时候带上 `--recurse submodules` 这样在 git clone 时会递归克隆 main 中的子仓库
2. 在当前的项目中执行：
```shell
git submodule init
git submodule update
```

#### 更新 submodule

对于子模块，只需要管理好自己的版本，并推送到远程通知
对于父模块，
1. 若子模块版本信息未提交，需要更新子模块目录下的代码，并执行`commit` 操作提交子模块版本信息；
2. 若子模块版本信息已提交，需要使用`git submodule update` ,git 会自动根据子模块版本信息更新所有子模块目录相关代码

#### 删除子模块

使用 `git submodule deinit` 命令卸载一个子模块 (.git/config), 如果该模块工作区内有本地修改，加上参数 `--force` 会强制移除，然后执行 `git rm` 移除实体内容 (.gitmodule), 最后`commit` 会移除残余 (.git/modules)
```shell
git submodule deinit [submodule_name]
git rm [submodule_name]
git commit -m "rm submodule"
```

#### 注意
* 主项目中，使用 git add/commit 不会改变项目中的子模块

### tag 使用
场景：
* 软件开发到达一定里程碑
* 需要为仓库添加版本信息

tag 的使用在本文档最下面记录过，但这里再详细重复一遍

```shell
git tag -a <tag> -m <tag commit> # 打 tag 并添加 commit 说明
git tag -d <tag> # 删除标签

git tag # 查看当前仓库所有标签
git show <tag> # 查看标签节点具体信息

git push origin --tags # 推送所有 tag 到远程仓库
```

上面 tag 标签操作仅作用于本地仓库，对于一次版本发布还需要同步到远程仓库
```shell
git push <remote> <tag>   # push tag 到远程仓库
git push <remote> --delete <tag> # 删除远程仓库具体标签
```

### 追加提交（补充提交）
场景：
* commit 完之后，发现漏了几个文件，此时还没 push
* 需要再 commit 一次，但又不想污染 git 提交记录

举例：
我合并了桃芯遥控器的基线，commit 完
```shell
❯❯ remoter git:(master)  10:50 git log      
commit 3aaefc3dbf7bbe1c68fedf59b9bd28ce7d3dcbcb (HEAD -> master)
Merge: 3c13b03 b172b96
Author: lijianpeng <bosco@pthyidh.com>
Date:   Wed Nov 8 10:50:13 2023 +0800

    chore: 更新小米遥控器基线
```

要 stash pop 时报了冲突，发现上次 commit 漏了两个工程文件
```shell
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   mi_rcu/mi_rcu.uvoptx
        modified:   mi_rcu/mi_rcu.uvprojx
```

#### 方式一：
git commit --amend
```shell
git add
# 这里-m 的 commit 内容会把上次的内容更新掉
git commit -m "chore: 补充提交更新小米遥控器基线" --amend
```

查看 git log，head 节点变成了最新的提交
```shell
❯❯ remoter - 副本 git:(master) 11:01 git log
commit 90d14f6463e8a0680ec845ee18116dcc73d139c4 (HEAD -> master)
Merge: 3c13b03 b172b96
Author: lijianpeng <bosco@pthyidh.com>
Date:   Wed Nov 8 10:50:13 2023 +0800

    chore: 补充提交更新小米遥控器基线
```

#### 方式二：
git rebase 合并多个提交记录，[修改 commit 内容](##修改 commit 内容) 记录过。

### upstream & downstream
upstream 和 downstream 是 git 中一个比较常用的概念。
以我们小米遥控器的项目为例
* 代码主要是桃芯那边的人开发的
* 我们后面需要基于此代码进行修改
* 我这边 clone 了他的代码仓库，并把代码上传到我们的 gitlab 仓库
* 此时，桃芯的仓库就是我们的 upstream，我们就是桃芯那边的 downstream

### git 停止追踪某个文件
场景：
* 有些工程文件配置文件必须上传远程仓库
* 但不想后续每次编译后在更改列表里看到它们的修改

我们可以将该文件标记为 "假定为未更改"状态，**该操作只会影响 git 本地仓库，不会影响远程仓库**。

暂停追踪文件改动 
```shell
git update-index --assume-unchanged your_file_path
```

继续追踪文件的改动
```shell
git update-index --no-assume-unchanged your_file_path
```

查看暂停追踪的文件：
```shell
# windows
git ls-files -v | findstr "^h"

# Linux
git ls-files -v | grep "^h"
```
==建议慎重操作，仅适合非多人合作项目==

### git mv 移动文件位置但不丢失 git 记录
背景：
* 需要移动某个文件或文件夹
* git 单纯移动会当作删除后重新添加，导致之前的 git commit 记录丢失

```shell
# 例
.
├─ A
│  ├─B
└─ C

# 要改成以下文件结构
.
├─ A
├─ B
└─ C

# 命令行
git mv .\A\B .\B
git add -u .\B  # -u 更新已追踪的文件和文件夹
git commit -m "move dir B"

```

该操作同样适用文件重命名

### 记录一次 push 过程
背景：
* 开发到一个阶段，准备 push 到远程
* 功能在本地一个分支 `feat_register` 上开发
* 本地有一支 dev 分支，对应远程 dev 分支
* 已经把需要 push 的内容 add commit 了
```shell
git stash    # 如果本地还有其他内容不想上传，先暂存着
git checkout dev    # 切换到 dev 分支
git rebase feat_register    # 把最新更改合并到 dev 分支
git pull origin dev    # 拉取一下远程更新，没有冲突
git push origin dev    # 上传到远程 dev 分支
git checkout feat_register    # 上传完，切换回原来的分支，继续开发
git stash pop    # 恢复暂存的内容，继续开发
```

终端原始记录
```shell
❯❯ sas_host_rtts git:(feat_register)  11:38 git stash
Saved working directory and index state WIP on feat_register: d527e0b [feat]commit 内容
❯❯ sas_host_rtts git:(feat_register) 11:38 git checkout dev
Switched to branch 'dev'
Your branch is up to date with 'origin/dev'.
❯❯ sas_host_rtts git:(dev) 11:38 git rebase feat_register
Successfully rebased and updated refs/heads/dev.
❯❯ sas_host_rtts git:(dev) 11:39 git pull origin dev    
From 121.43.179.105:ptw_hzwl_sas/hzwl_sas_host
 * branch            dev        -> FETCH_HEAD
Already up to date.
❯❯ sas_host_rtts git:(dev) 11:39 git push origin dev
Enumerating objects: 42, done.
Counting objects: 100% (38/38), done.
Delta compression using up to 16 threads
Compressing objects: 100% (26/26), done.
Writing objects: 100% (26/26), 6.55 KiB | 3.27 MiB/s, done.
Total 26 (delta 17), reused 0 (delta 0), pack-reused 0
remote: 
remote: To create a merge request for dev, visit:
remote:   http://121.43.179.105:9001/ptw_hzwl_sas/hzwl_sas_host/-/merge_requests/new?merge_request%5Bsource_branch%5D=dev      
remote:
To 121.43.179.105:ptw_hzwl_sas/hzwl_sas_host.git
   c4f7072..d527e0b  dev -> dev
❯❯ sas_host_rtts git:(dev) 11:39 git checkout feat_register
Switched to branch 'feat_register'
❯❯ sas_host_rtts git:(feat_register) 11:40 git stash pop
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   .gitignore
        modified:   applications/main.c
        modified:   applications/pt_sas.h
        modified:   applications/register.c
        modified:   applications/warn.c
        modified:   applications/warn.h

no changes added to commit (use "git add" and/or "git commit -a")
Dropped refs/stash@{0} (63ae916b87bea6078bee795e08d50b71d5c5efaa)
```

### git pull 冲突举例

背景：
1. 我要把远程仓库的 `hao_dev` 分支拉到我本地的 `feat_register` 分支上
2. 我当前在 `feat_register` 分支上

```shell
git pull origin hao_dev    # 拉取 hao_dev 分支到本地当前的分支
```

提示有冲突
![image.png|560](https://raw.githubusercontent.com/24849748/PicBed/main/ob/202307121648166.png)

vscode 里可以直接点击修改
![image.png|360](https://raw.githubusercontent.com/24849748/PicBed/main/ob/202307121650725.png)

![image.png|680](https://raw.githubusercontent.com/24849748/PicBed/main/ob/202307121653498.png)

因为这两个文件是 rtt 工程的配置文件，比较奇葩需要用 git 管理，所以上传了，这里就用采用本地的修改，点击“采用当前更改”后，保存一下文件
然后点击左侧**合并更改**里冲突文件的+号，git add 修改后的冲突文件
继续合并
```shell
git merge --continue
```
修改一下 commit 内容
![image.png|470](https://raw.githubusercontent.com/24849748/PicBed/main/ob/202307121715101.png)
合并完成
![image.png|510](https://raw.githubusercontent.com/24849748/PicBed/main/ob/202307121716934.png)

### git rm
删除已 git add 的某个文件，使用 gitignore 没有起作用
适用场景：
1. 之前错误 push 了某个项目配置文件，后面 pull 下来后一直有冲突
2. 打算远程和本地都删除改文件

```shell
git rm -r -n --cached <file/dir> # 查看文件或目录是否在本地或远程

git rm -r --cached <file/dir> # 删除
```

### git stash

git push 前如果有代码没有提交，会被打断的
我们可以使用 stash 来保存当前的改动，然后再 push 或 pull，操作完后再把改动恢复回来

适用场景：
1. 写完部分代码，但有部分代码还不想提交

```shell
git stash  # 放入暂存区
git stash pop # 恢复之前暂存的改动
```

举例：
* 功能开发一半，改了一个 bug
* bug 比较重要需要先提交

```shell
git commit bug # commit bug
git stash # 把其他内容暂存起来
git pull --rebase # 以 rebase 方式拉取更新远程最新的代码
git push # 上传 commit 的 bug
git stash pop # 恢复之前暂存内容
```

### 修改 commit 内容

**修改最近一次**
```shell
git commit --amend # 然后进入 vi 编辑器
```

**修改之前**
```shell
git rebase -i HEAD~2 # 修改倒数两次 commit 记录
#然后在 vi 界面将 pick 更改成 edit，保存退出
#然后终端会有 git commit --amend
#修改注释保存退出
git rebase --continue
```

### 下载远程指定分支
clone：
```shell
git clone -b <branch-name> <url>
```

pull：
```shell
git pull origin <远程分支名>:<本地分支名> # 拉取远程指定分支到本地指定分支
git pull origin <远程分支名> # 拉取远程指定分支到本地当前分支

# git push 一样
```

### GIT 解决换行符 LF CRLF warning
眼不见为净
```shell
# 查看 core.autocrlf 属性
git config --global --get core.autocrlf
git config --get core.autocrlf

# 设置为 true
git config --global core.autocrlf true
git config core.autocrlf true
```

core.autocrlf 说明
```shell
$ git config --global core.autocrlf true
$ git config --global core.autocrlf false
$ git config --global core.autocrlf input
```
* true：会基于用户当前的系统来进行自动转换，在 **Windows** 下进行 _checkout_ 就会把 **LF** 转换成 **CRLF**，如果把代码添加（add）到 Git 的缓冲区，又会自动把 **CRLF** 转换成 **LF** 。
* false：告诉 git 不做转换
* input：让 git 在 add 时转换为 LF

### 团队提交流程

1. 写代码前先 `git pull` 拉取更新，如果你本地有文件没有 `commit` 要 `commit` 一下
2. 写完代码后，先  `git add`、`git commit` 提交到本地仓库
3. `git push` 前再 `git pull` 一次保证远程所有更新都有获取到，确保你写代码过程中远程没有更新
    1. 没有更新就会提示 `Already up to date`
    2. 有更新，没有冲突 -> 自动合并到当前分支了
    3. 有更新，有冲突 -> 提示 `merge failed` ，需要手动修改冲突
4. `git push`

#### 常见冲突
* 本地和远程对同一段代码作了修改，git 不知道要使用哪一个
* 一边删除了一个文件，另一边修改了这个文件

#### 我们的开发模型：
-   master 分支为编译可用版本，dev 分支为开发分支
-   每个人拉取仓库后，自己在本地仓库新建一个自己的 dev_yourname 分支
    -   dev_yourname 分支保持与 dev 分支同步
    -   完成一个阶段后，小组讨论后将 dev_yourname 分支合并到 dev 分支，并将 dev 分支 push 到远程仓库
-   根据自己分配的任务在本地 dev_yourname 分支的基础上创建一个功能分支，比如 feat#433 分支，写完功能分支后，rebase 到 dev_yourname 分支上

### GIT 本地和远程仓库都有改动

发生冲突
适用场景：

做法 1：
1. 首先需要将本地分支改动 commit 到暂存区去
2. 然后使用 `pull` 同步远程仓库的改动，如果有冲突需要手动修改

### GIT 同步远程仓库

适用场景：
* 远程仓库有改动
* 本地仓库想与远程仓库一样

首先需要确保本地仓库当前的分支是要同步的分支
1. 使用 `git branch` 查看当前分支
2. 使用 `git checkout <branch-name>` 切换目标分支

做法一：
```shell
# 获取远程仓库 origin 最新改动的信息到本地 master 分支上
# 如提交、改动、标签等，但不会与本地 master 分支合并
git fetch origin master

# 比较远程更新和本地分支差异
git log master.. origin/master

# 合并远程分支到当前分支
git merge origin/master 
```
注意远程分支名要写全 `origin/master`

做法二：
```shell
git pull origin master # 自动获取远程仓库信息并合并到本地当前分支
# 如果有冲突，需要手动修改，然后再 add 再 commit，再 push 确保本地改动与远程同步
```

### GIT 删除远程分支
```shell
git remote -v # 查看远程分支
git remote rm <origin-name> # 删除

# 或者
git push origin -d <branch-name>

# 再或者
# 简单粗暴上 gitlab 手动删除
```

### GIT 多个本地仓库提交同一远程仓库不同分支

适用场景：
* 希望在本地有多个仓库可以同时打开
* 不想再创建多个远程仓库

做法：
跟新建仓库流程一样

git push 命令，会在远程仓库创建和 branch 名字一样的分支
```shell
git push origin branch
```
加上-u，会把该分支设置为上游分支，设置了上游分支后，后面 push 不需要再指定 origin 和本地 branch
可以使用以下命令手动设置上游分支
```shell
git branch --set-upstream-to=<remote_name>/<remote_branch>
# 或者
git branch -u <remote_name>/<remote_branch>
```

### Git 回滚历史版本

适用场景：
* 提交代码到错误的分支
* 提交的代码不需要上线了，而同一分支有需要上线的代码
* 提交了不需要提交的代码

```shell
git reset --hard HEAD^ # 回退到上个版本。 
git reset --hard HEAD~n # 回退到前 n 次提交之前，若 n=3，则可以回退到 3 次提交之前。 
git reset --hard commit_sha # 回滚到指定 commit 的 sha 码，推荐使用这种方式。
```

commit_sha 可以在远程仓库里、或者 git log 命令查看
例如：
```shell
git reset --hard 05ac0bfb2929d9cbwiener75e52ecb011950fb
```

--hard 是强制执行的意思，执行完上述命令后，使用以下命令可以强推到远程仓库
```shell
git push origin HEAD --force
```

git reset 三个参数：
* --soft：只撤销 `git commit`，不撤销 `git add`，不删除工作空间代码改动
* --hard：撤销 `git commit`、`git add`，删除工作空间代码改动，恢复到上一次 `git commit` 的状态
* --mixed：撤销 `git commit`、 `git add`，不删除工作空间代码改动，reset 默认参数

### 为 Github 和 Gitlab 添加 ssh 公钥

1. 分别为 github、gitlab 生成 ssh 密钥，邮箱要和 git config --global 的一样
```shell
ssh-keygen -t rsa -C "yourEmail@mail.com" -f ~/.ssh/github_rsa
ssh-keygen -t rsa -C "yourEmail@mail.com" -f ~/.ssh/gitlab_rsa
    ```
2. ssh-add 添加密钥
```shell
ssh-add ~/.ssh/github_rsa
ssh-add ~/.ssh/gitlab_rsa
```
   如果提示 "Could not open a connection to your authentication agent"，执行`ssh-agent bash`
    ![[Pasted image 20230429014827.png]]

3. 配置`~/.ssh/config`文件
```
# gitlab
Host gitlab.com
HostName gitlab.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/gitlab_rsa 
# github
Host github.com
HostName github.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/github_rsa
```

4. 用记事本打开~/.ssh/github_rsa.pub，复制里面的内容到 github `SSH and GPG keys` 的 `SSH keys` 里，gitlab 也一样
5. 测试
```shell
ssh -T git@github.com
ssh -T git@gitlab.com
```

### 概念性理解

#### 工作区域
* 工作区
* 暂存区
* 本地仓库
* 远程仓库

#### 文件状态
* 未跟踪（untrack）
* 未修改（unmodified）
* 已修改（modified）
* 已暂存（staged）
![image.png|510](https://raw.githubusercontent.com/24849748/PicBed/main/ob/202306121639294.png)

### GIT 命令

```shell
git add
git commit

git branch # 列出本地所有分支
git branch -a # 列出本地和远程所有分支
git branch <branch-name> # 新建 <branch-name> 分支，但不切换

git checkout <branch-name> # 切换到 <branch-name> 分支
git checkout -b <branch-name> # 新建并切换到 <branch-name> 分支
git branch -f master HEAD~3 # 让 master 分支强制指向 HEAD 节点的上上上次提交记录

git merge <branch-name>  # 把 <branch-name> 分支合并到当前分支
git rebase <target-branch-name> # 将当前分支提交记录，一个一个取出，合并到目标分支上去
```

切换当前节点
```shell
git checkout <hash> # 幸好 git 处理 hash 比较人性，只需要输入前几个字符就好

git checkout HEAD^  # 切换到 HEAD 节点上个提交记录
git checkout HEAD^^^ # 切换到 HEAD 节点上上上个提交记录

git checkout HEAD~4  # 切换到 HEAD 节点前 4 个提交记录
```

撤销变更
```shell
git reset <hash> # 撤销更改，但对远程分支无效

git revert # 在当前 HEAD 后面创建一个与 HEAD^相同的节
```

整理提交记录
```shell
git cherry-pick <hash>  # 将对应 commit hash 复制一份到当前分支节点后面，支持多个<hash>

git rebase -i HEAD~4 # 用 vi 以文本形式整理 HEAD 往前 4 个分支提交记录
```

Tag
```shell
git tag <tag-name> <commitHash> # 在 <commitHash> 提交记录上添加标签 <tag-name>，不指定 <commitHash> 默认为 HEAD 节点

git checkout <tag-name> #快速切换到相应位置
```
