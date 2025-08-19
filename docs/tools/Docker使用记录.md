---
title: Docker使用记录
date: 2024-11-14 02:05:44
# description: 
# mermaid: true
categories:
  - tools
tags:
  - docker
published: false
---

## 使用笔记

### Permission denied
docker进程使用Unix Socket而不是TCP端口。而默认情况下，Unix socket属于root用户，需要root权限才能访问。
解决方法：需要将当前用户添加到docker用户组中
```shell
#添加docker用户组
sudo groupadd docker
#将登陆用户加入到docker用户组中
sudo gpasswd -a $USER docker
#更新用户组
newgrp docker
#测试docker命令是否可以使用sudo正常使用
docker ps
```

## 安装
```bash
# 使用一键脚本安装并使用阿里云的源
sudo curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun

# 查看安装是否成功
sudo docker run hello-world
# 有以下输出说明安装成功
## Hello from Docker!
## This message shows that your installation appears to be working correctly.
```

## 命令
```bash
# 运行
docker run [img] [cmd] 
# 查看运行的容器
docker ps
# 停止容器
docker stop [img]

# 查看docker版本
docker -v

# 查看cpu架构
uname -a

# 查看docker本机镜像
docker images
# 删除镜像
docker rmi [img]
```

## docker的状态
- created（已创建）
- restarting（重启中）
- running 或 Up（运行中）
- removing（迁移中）
- paused（暂停）
- exited（停止）
- dead（死亡）