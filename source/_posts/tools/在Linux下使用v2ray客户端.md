---
title: 在Linux下使用v2ray客户端
date: 2024-04-27 23:55:32
categories:
- tools
tag: 
- Linux
- v2ray
published: false
---

## 环境
- ubuntu 22.04 lts

## 准备工作
* 下载 v2ray-core https://github.com/v2fly/v2ray-core/releases/tag/v4.31.0
* 懒得配置，直接使用 windows 端的 config.json 配置

## 安装

```shell
# 解压，可以先替换自己的 config.json 到目录下
unzip v2ray-linux-64.zip -d v2ray-linux-64

# 创建一些文件夹防止 mv 报错
sudo mkdir /usr/local/share/v2ray
sudo mkdir /var/log/v2ray
sudo mkdir /etc/systemd/system

# 手动移动到对应路径
cd ~/v2ray-linux-64
sudo mv v2ray /usr/local/bin/v2ray
sudo mv v2ctl /usr/local/bin/v2ctl
sudo mv geoip.dat /usr/local/share/v2ray/geoip.dat
sudo mv geosite.dat /usr/local/share/v2ray/geosite.dat
sudo mv config.json /usr/local/etc/v2ray/config.json
sudo mv v2ray.service /etc/systemd/system/v2ray.service
sudo mv v2ray@.service /etc/systemd/system/v2ray@.service

sudo mv access.log /var/log/v2ray/access.log
sudo mv error.log /var/log/v2ray/error.log

# 如果这两个 log 文件没有就改成 touch
sudo touch /var/log/v2ray/access.log
sudo touch /var/log/v2ray/error.log

# 启动 v2ray
sudo systemctl start v2ray

# 查看状态
sudo systemctl status v2ray

# 设置开机自启
sudo systemctl enable v2ray

```

## 设置快速代理 alias
把下面内容保存为 proxy.sh 脚本，并在在`.bashrc` 或 `.zshrc` 中 source 一下
```shell
function set_proxy() {
    # 自动获取宿主 Windows 的 IP 地址
    export http_proxy=http://127.0.0.1:10809
    export HTTP_PROXY=$http_proxy
    export https_proxy=$http_proxy
    export HTTPS_PROXY=$http_proxy
    echo "设置代理为：$http_proxy"
}

function unset_proxy() {
  unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY
  curl -s "https://ip.jackjyq.com" | grep -E -i "ip:|country:"
  echo "清除代理设置"
}

alias showproxy='echo $http_proxy'        #（Show）查看当前代理设置
alias proxy='set_proxy'               #（Proxy）设置代理挂载到宿主机
alias unproxy='unset_proxy'             #（X）清除当前 WSL 的代理设置
alias checkproxy="curl 'https://ip.jackjyq.com'"   #（Check）测试代理状态 （是否成功及打印代理信息）
```