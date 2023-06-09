
### GIT删除远程分支
```shell
git remote -v # 查看远程分支
git remote rm <origin-name> # 删除
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
