* git仓库中保存记录就是快照
* branch前面带 `*` 号为当前分支

```shell
git add
git commit

git branch # 列出本地所有分支
git branch -a # 列出本地和远程所有分支
git branch <branch-name> # 新建 <branch-name> 分支，但不切换

git checkout <branch-name> # 切换到 <branch-name> 分支
git checkout -b <branch-name> # 新建并切换到 <branch-name> 分支

git merge <branch-name>  # 把 <branch-name> 分支合并到当前分支

# 第二种合并方式
git rebase 

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
* 


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
可以适用一下命令手动设置上游分支，但个人不推荐直接`git push` 或 `git pull`
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
