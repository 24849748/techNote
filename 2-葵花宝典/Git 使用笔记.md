* git仓库中保存记录就是快照
* branch前面带 `*` 号为当前分支

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
* --soft：
* --hard：
* --mixed：

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


