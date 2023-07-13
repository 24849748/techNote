* git仓库中保存记录就是快照
* branch前面带 `*` 号为当前分支
* .gitignore对路径符号有严格要求。必须用 `/`

### 记录一次push过程
背景：
* 开发到一个阶段，准备push到远程
* 功能在本地一个分支 `feat_register` 上开发
* 本地有一支dev分支，对应远程dev分支
* 已经把需要push的内容 add commit了
```shell
git stash    # 如果本地还有其他内容不想上传，先暂存着
git checkout dev    # 切换到dev分支
git rebase feat_register    # 把最新更改合并到dev分支
git pull origin dev    # 拉取一下远程更新，没有冲突
git push origin dev    # 上传到远程dev分支
git checkout feat_register    # 上传完，切换回原来的分支，继续开发
git stash pop    # 恢复暂存的内容，继续开发
```

终端原始记录
```shell
❯❯ sas_host_rtts git:(feat_register)  11:38 git stash
Saved working directory and index state WIP on feat_register: d527e0b [feat]commit内容
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
git pull origin hao_dev    # 拉取hao_dev分支到本地当前的分支
```

提示有冲突
![image.png|560](https://raw.githubusercontent.com/24849748/PicBed/main/ob/202307121648166.png)

vscode里可以直接点击修改
![image.png|360](https://raw.githubusercontent.com/24849748/PicBed/main/ob/202307121650725.png)

![image.png|650](https://raw.githubusercontent.com/24849748/PicBed/main/ob/202307121653498.png)

因为这两个文件是rtt工程的配置文件，比较奇葩需要用git管理，所以上传了，这里就用采用本地的修改，点击“采用当前更改”后，保存一下文件
然后点击左侧**合并更改**里冲突文件的+号，git add修改后的冲突文件
继续合并
```shell
git merge --continue
```
修改一下commit内容
![image.png|470](https://raw.githubusercontent.com/24849748/PicBed/main/ob/202307121715101.png)
合并完成
![image.png|510](https://raw.githubusercontent.com/24849748/PicBed/main/ob/202307121716934.png)

### git rm
删除已git add的某个文件，使用gitignore没有起作用
适用场景：
1. 之前错误push了某个项目配置文件，后面pull下来后一直有冲突
2. 打算远程和本地都删除改文件

```shell
git rm -r -n --cached <file/dir> # 查看文件或目录是否在本地或远程

git rm -r --cached <file/dir> # 删除
```


### git stash

git push前如果有代码没有提交，会被打断的
我们可以使用stash来保存当前的改动，然后再push或pull，操作完后再把改动恢复回来

适用场景：
1. 写完部分代码，但有部分代码还不想提交

```shell
git stash  # 放入暂存区
git stash pop # 恢复之前暂存的改动
```

举例：
* 功能开发一半，改了一个bug
* bug比较重要需要先提交

```shell
git commit bug # commit bug
git stash # 把其他内容暂存起来
git pull --rebase # 以rebase方式拉取更新远程最新的代码
git push # 上传commit的bug
git stash pop # 恢复之前暂存内容
```


### 修改commit内容

**修改最近一次**
```shell
git commit --amend # 然后进入vi编辑器
```

**修改之前**
```shell
git rebase -i HEAD~2 # 修改倒数两次commit记录
#然后在vi界面将pick更改成edit，保存退出
#然后终端会有git commit --amend
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

### GIT解决换行符LF CRLF warning
眼不见为净
```shell
# 查看core.autocrlf属性
git config --global --get core.autocrlf
git config --get core.autocrlf

# 设置为true
git config --global core.autocrlf true
git config core.autocrlf true
```

### 团队提交流程

1. 写代码前先 `git pull` 拉取更新，如果你本地有文件没有 `commit` 要 `commit` 一下
2. 写完代码后，先  `git add`、`git commit` 提交到本地仓库
3. `git push` 前再 `git pull` 一次保证远程所有更新都有获取到，确保你写代码过程中远程没有更新
    1. 没有更新就会提示 `Already up to date`
    2. 有更新，没有冲突 -> 自动合并到当前分支了
    3. 有更新，有冲突 -> 提示 `merge failed` ，需要手动修改冲突
4. `git push`


#### 常见冲突
* 本地和远程对同一段代码作了修改，git不知道要使用哪一个
* 一边删除了一个文件，另一边修改了这个文件



#### 我们的开发模型：
-   master分支为编译可用版本，dev分支为开发分支
-   每个人拉取仓库后，自己在本地仓库新建一个自己的dev_yourname分支
    -   dev_yourname分支保持与dev分支同步
    -   完成一个阶段后，小组讨论后将dev_yourname分支合并到dev分支，并将dev分支push到远程仓库
-   根据自己分配的任务在本地dev_yourname分支的基础上创建一个功能分支，比如feat#433分支，写完功能分支后，rebase到dev_yourname分支上


### GIT 本地和远程仓库都有改动

发生冲突
适用场景：

做法1：
1. 首先需要将本地分支改动commit到暂存区去
2. 然后使用 `pull` 同步远程仓库的改动，如果有冲突需要手动修改


### GIT同步远程仓库

适用场景：
* 远程仓库有改动
* 本地仓库想与远程仓库一样

首先需要确保本地仓库当前的分支是要同步的分支
1. 使用 `git branch` 查看当前分支
2. 使用 `git checkout <branch-name>` 切换目标分支

做法一：
```shell
# 获取远程仓库origin最新改动的信息到本地master分支上
# 如提交、改动、标签等，但不会与本地master分支合并
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
# 如果有冲突，需要手动修改，然后再add再commit，再push确保本地改动与远程同步
```



### GIT删除远程分支
```shell
git remote -v # 查看远程分支
git remote rm <origin-name> # 删除

# 或者
git push origin -d <branch-name>

# 再或者
# 简单粗暴上gitlab手动删除
```

### GIT多个本地仓库提交同一远程仓库不同分支

适用场景：
* 希望在本地有多个仓库可以同时打开
* 不想再创建多个远程仓库

做法：
跟新建仓库流程一样

git push 命令，会在远程仓库创建和branch名字一样的分支
```shell
git push origin branch
```
加上-u，会把该分支设置为上游分支，设置了上游分支后，后面push不需要再指定origin和本地branch
可以使用以下命令手动设置上游分支
```shell
git branch --set-upstream-to=<remote_name>/<remote_branch>
# 或者
git branch -u <remote_name>/<remote_branch>
```


### Git回滚历史版本

适用场景：
* 提交代码到错误的分支
* 提交的代码不需要上线了，而同一分支有需要上线的代码
* 提交了不需要提交的代码

```shell
git reset --hard HEAD^ # 回退到上个版本。 
git reset --hard HEAD~n # 回退到前n次提交之前，若n=3，则可以回退到3次提交之前。 
git reset --hard commit_sha # 回滚到指定commit的sha码，推荐使用这种方式。
```

commit_sha可以在远程仓库里、或者git log命令查看
例如：
```shell
git reset --hard 05ac0bfb2929d9cbwiener75e52ecb011950fb
```

--hard是强制执行的意思，执行完上述命令后，使用以下命令可以强推到远程仓库
```shell
git push origin HEAD --force
```

git reset 三个参数：
* --soft：只撤销 `git commit`，不撤销 `git add`，不删除工作空间代码改动
* --hard：撤销 `git commit`、`git add`，删除工作空间代码改动，恢复到上一次 `git commit` 的状态
* --mixed：撤销 `git commit`、 `git add`，不删除工作空间代码改动，reset默认参数

### 为Github和Gitlab添加ssh公钥

1. 分别为github、gitlab生成ssh密钥，邮箱要和git config --global的一样
```shell
ssh-keygen -t rsa -C "yourEmail@mail.com" -f ~/.ssh/github_rsa
ssh-keygen -t rsa -C "yourEmail@mail.com" -f ~/.ssh/gitlab_rsa
    ```
2. ssh-add添加密钥
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

4. 用记事本打开~/.ssh/github_rsa.pub，复制里面的内容到github `SSH and GPG keys` 的 `SSH keys` 里，gitlab也一样
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



### GIT命令

```shell
git add
git commit

git branch # 列出本地所有分支
git branch -a # 列出本地和远程所有分支
git branch <branch-name> # 新建 <branch-name> 分支，但不切换

git checkout <branch-name> # 切换到 <branch-name> 分支
git checkout -b <branch-name> # 新建并切换到 <branch-name> 分支
git branch -f master HEAD~3 # 让master分支强制指向HEAD节点的上上上次提交记录

git merge <branch-name>  # 把 <branch-name> 分支合并到当前分支
git rebase <target-branch-name> # 将当前分支提交记录，一个一个取出，合并到目标分支上去
```

切换当前节点
```shell
git checkout <hash> # 幸好git处理hash比较人性，只需要输入前几个字符就好

git checkout HEAD^  # 切换到HEAD节点上个提交记录
git checkout HEAD^^^ # 切换到HEAD节点上上上个提交记录

git checkout HEAD~4  # 切换到HEAD节点前4个提交记录
```

撤销变更
```shell
git reset <hash> # 撤销更改，但对远程分支无效

git revert # 在当前HEAD后面创建一个与HEAD^相同的节
```


整理提交记录
```shell
git cherry-pick <hash>  # 将对应commit hash复制一份到当前分支节点后面，支持多个<hash>

git rebase -i HEAD~4 # 用vi以文本形式整理HEAD往前4个分支提交记录
```

Tag
```shell
git tag <tag-name> <commitHash> # 在 <commitHash> 提交记录上添加标签 <tag-name>，不指定 <commitHash> 默认为HEAD节点

git checkout <tag-name> #快速切换到相应位置
```


