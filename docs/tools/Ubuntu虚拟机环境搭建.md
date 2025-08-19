

## 虚拟机共享目录设置

> https://www.cnblogs.com/MaRcOGO/p/16463460.html


## nfs 共享配置

> https://kubesphere.io/zh/docs/v3.4/reference/storage-system-installation/nfs-server/
> https://help.fanruan.com/finereport/doc-view-3053.html

安装
```bash
sudo apt install nfs-kernel-server -y
```

创建共享目录
```bash
sudo mkdir -p /mnt/nfs
# 修改权限
sudo chown nobody:nogroup /mnt/nfs
sudo chmod 777 /mnt/nfs
```

配置
```bash
sudo vim /etc/exports
# 允许所有ip连接
/mnt/nfs *(rw,sync,no_subtree_check,no_root_squash)
```

检查服务是否启动
```bash
cat /var/lib/nfs/etab
```

重启nfs服务器
```bash
sudo systemctl restart nfs-kernel-server
```


## 网卡失效

现象：
1. vmware 右下角网卡图标存在
2. ubuntu 右上角没有网卡
3. ifconfig 只剩下 127.0.0.1

可能是虚拟机未正常关闭导致网卡失效

## 方法一
```bash
# 查看网卡是否还在
ifconfig -a

# 可能这一步就出来了
sudo dhclient [网卡]

# up 一下
ifconfig [网卡] up
```

## 方法二

> https://www.lanmo.ltd/post/32688.html

```bash
# 先切换管理权限方便操作
sudo -i

# 查看网卡信息，如果没有那就只能重装
lshw -c network

# 先停止网络服务
service NetworkManager stop

# 备份
cp /var/lib/NetworkManager/NetworkManager.state /var/lib/NetworkManager/NetworkManager.state.backup
# 删除
rm  /var/lib/NetworkManager/NetworkManager.state

# 将 managed 后面的 false 修改为 true
vim /etc/NetworkManager/NetworkManager.conf

# 启动
service NetworkManager start
```



## 更改主目录中文文件名为英文

在终端中输入以下命令
```shell
export LANG=en_US
xdg-user-dirs-gtk-update
```
在询问是否将目录转化为英文的窗口中选择同意

使用命令将系统语言转化为中文
```shell
epxort LANG=zh_CN
```

## vscode 无法在这个大型工作区中监视文件更改

[vscode官方文档解释](https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc)

工作区很大并且文件很多，导致VS Code文件观察程序的句柄达到上限。

```bash
# 查看当前限制
cat /proc/sys/fs/inotify/max_user_watches

# 修改限制
sudo vim /etc/sysctl.conf
## 在文件末尾插入
fs.inotify.max_user_watches=524288

## 保存
sudo sysctl -p
```

## 文件夹显示隐藏文件

文件夹内 ctrl + h

## ~~WSL 子系统和 windows 共用一套 .ssh 配置~~
场景：
* windows 把 ssh 密钥添加到 gitlab 上
* 子系统使用要重新配置
* 让子系统也使用 windows 的。ssh 文件

```shell
# wsl
## 备份原先的。ssh 文件
mv ~/.ssh ~/.ssh_bak

## 创建软连接
cd ~
ln -s /mnt/c/Users/<Your Name>/.ssh .

## wsl 修改。ssh 生效
sudo vim /etc/wsl.conf
## 填入下面的内容
### [automount]
### options = "metadata"

# windows
## 重启 wsl
wsl.exe --shutdown

# wsl
## 给。ssh 配置权限
cd ~/.ssh
chmod 644 config  
chmod 400 id_rsa
```

## ZSH 终端
```shell
sudo apt-get install zsh
chsh -s /bin/zsh
```

## oh my zsh
```shell
sh -c "$(curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh)"
```

安装常用插件
```shell
# 自动补全
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# 语法高亮
git clone https://gitee.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
编辑 `.zshrc`
```shell
#主题
ZSH_THEME="gentoo"
#插件
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
```
source 我的配置
```shell
# .zshrc
source ~/bosco.sh

# bosco.sh
#### 终端代理
function set_proxy() {
    # 自动获取宿主 Windows 的 IP 地址
    proxy_server=`cat /etc/resolv.conf|grep nameserver|awk '{print $2}'`
    # proxy_port默认为clash的7890（set_proxy默认不传参时），
    #需设置其他端口时第一个参数填入端口即可
    if [[ $# = 0 ]]
    then
        proxy_port=10809
    else
        proxy_port=$1
    fi
    export http_proxy=http://$proxy_server:$proxy_port
    export HTTP_PROXY=$http_proxy
    export https_proxy=$http_proxy
    export HTTPS_PROXY=$http_proxy
    echo "设置代理为:$http_proxy"
}

function unset_proxy() {
  unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY
  curl -s "https://ip.jackjyq.com" | grep -E -i "ip:|country:"
  echo "清除代理设置"
}

alias showproxy='echo $http_proxy'        #（Show）查看当前代理设置
alias proxy='set_proxy'               #（Proxy）设置代理挂载到宿主机
alias unproxy='unset_proxy'             #（X）清除当前WSL的代理设置
alias checkproxy="curl 'https://ip.jackjyq.com'"   #（Check）测试代理状态 (是否成功及打印代理信息)

```


source .zshrc

## 配置 ssh

生成密钥

```shell
ssh-keygen -t ed25519 -C "1270112821@qq.com" -f ed25519_gitee
```
将 pub 密钥拷贝到 ubuntu .ssh/authorized_keys

配置权限
用户目录权限为 755 或者 700，就是不能是 77x。
.ssh 目录权限一般为 755 或者 700。
rsa_id.pub 及 authorized_keys 权限一般为 644
rsa_id 权限必须为 600

```shell
chmod 755 ~
chmod 755 .ssh
chmod 644 .ssh/authorized_keys
```

## changyong.txt
```
3 git 设置代理
git config --global http.proxy http://192.168.8.200:10809
git config --global https.proxy https://192.168.8.200:10809
git config --global --unset http.proxy
git config --global --unset https.proxy

sudo gedit /etc/proxychains4.conf

sudo mount -t nfs  mao@192.168.8.180:/home /mnt/mao

export http_proxy=http://192.168.43.1:10809
export https_proxy=http://192.168.43.1:10809
env |grep -i proxy

unset http_proxy
unset https_proxy

git config --global http.proxy http://192.168.43.1:10809
git config --global https.proxy https://192.168.43.1:10809
设置 http 代理
git config --global http.proxy http://192.168.43.1:10809
设置 https 代理
git config --global https.proxy https://192.168.43.1:10809
取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy
设置 socks5 代理
git config --global http.proxy 'socks5://192.168.8.200:10809'
git config --global https.proxy 'socks5://192.168.8.200:10809'
取消代理
git config --global --unset  http.proxy
git config --global --unset  https.proxy
只对 github.com
git config --global http.https://github.com.proxy socks5://192.168.8.200:10809
#取消代理
git config --global --unset http.https://github.com.proxy

一般只要设置 http.proxy 就可以了。https.proxy 不用设置。

sudo mount -t nfs 192.168.8.180:/home /mnt/mao

### Ubuntu 20.04 设置 DNS 的方法
https://www.cnblogs.com/mouseleo/p/14976527.html
首先修改 /etc/systemd/resolved.conf 文件，在其中添加 dns 信息，例如：

DNS=8.8.8.8 114.114.114.114
然后退出保存。

然后以 root 身份在 ubuntu 终端中依次执行如下命令：

sudo systemctl restart systemd-resolved
sudo systemctl enable systemd-resolved

sudo mv /etc/resolv.conf /etc/resolv.conf.bak
sudo ln -s /run/systemd/resolve/resolv.conf /etc/
再查看/etc/resolv.conf 文件就可以看到新的 dns 信息已经写入其中了。

sudo gedit ~/.pip/pip.conf

上不了网时记得看 windows 网络连接里 VMnet8 的网段是否正确

https://blog.csdn.net/xu624735206/article/details/108797471
解决 ubuntu20.04 虚拟机无法上网的问题
二、解决方式
为什么还是无法 ping 通外网呢？查找相关博客，缺少 inet 地址（即 ipv4 的 ip 地址）。

1、使用 DHCP 动态分配 IP 地址
找到一种配置的方式，使用命令：sudo dhclient -v
再查看网络配置信息，我们会发现，inet 的 ip 地址，能够正常 ping 通外网：
这种方式有个弊端，每次重启虚拟机的时候，都要再次执行上面的指令。

2、配置静态 IP 地址
2、设置静态 IP 地址
Ubuntu 20.04 使用 netplan 作为默认的网络管理器。netplan 的配置文件存储在/etc/netplan 目录下。我们可以通过以下命令在/etc/netplan 目录下找到这个配置文件：
ls /etc/netplan

sudo gedit /etc/netplan/01-network-manager-all.yaml

ubuntu swap 交换空间增加与关闭
https://blog.csdn.net/ABC_ORANGE/article/details/121842642

sudo mount -t vboxsf Project ~/share_dir/Project

balena-etcher
```
