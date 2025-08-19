
## wsl

选择wsl1的原因：
* wsl1和windows共用串口设备，对于idf烧录不用再去重新挂载

### 安装步骤：
1. 打开win菜单，搜索 “windows功能“ 打开 ”启用或关闭windows功能“，勾上 ”适用于Linux的Windows子系统“ 和 ”虚拟机平台“
2. 重启电脑
3. 打开终端，设置wsl默认安装版本
```shell
wsl --set-default-version 1
```
4. 打开微软应用商店，搜索ubuntu，安装自己想用的版本并打开，如果终端没有提示安装成功，大概率是内核版本没有更新
```shell
wsl --update # 更新wsl内核
```


### 子系统终端代理

* 打开v2ray-设置-参数设置-v2rayN设置-允许来自局域网的连接
* 记住左下角的端口
* 将以下内容复制到 bashrc 或 zshrc 中，并执行 . ./bashrc 或 source ./zshrc

```shell
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

#（Show）查看当前代理设置
alias showproxy='echo $http_proxy'
#（Proxy）设置代理挂载到宿主机
alias proxy='set_proxy'
#（X）清除当前WSL的代理设置
alias unproxy='unset_proxy'
#（Check）测试代理状态 (是否成功及打印代理信息)
alias checkproxy="curl 'https://ip.jackjyq.com'"   
```

## esp-idf

```shell
# 准备环境
sudo apt-get install git wget flex bison gperf python3 python3-pip python3-venv cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0

sudo ln -s /usr/bin/python3 /usr/bin/python # python3软链接


# 下载esp-idf仓库
mkdir -p ~/esp
cd ~/esp
git clone -b v5.1.1 --recursive https://github.com/espressif/esp-idf.git
# 或
git clone -b v4.4.1 --recursive https://github.com/espressif/esp-idf.git

# 配置安装工具网络环境
cd ~/esp/esp-idf
export IDF_GITHUB_ASSETS="dl.espressif.com/github_assets"

# 根据需要安装相应芯片工具
./install.sh 


# 可以在zshrc或bashrc里设置alias变量，快速export idf环境
alias idf='. $HOME/esp/esp-idf/export.sh'
```


## idf常用命令

```shell
idf.py menuconfig
idf.py -p (PORT) flash

idf.py -p (PORT) -b 921600 build flash monitor 

idf.py -p PORT erase-flash # 擦除flash
idf.py -p PORT erase-otadata # 擦除ota数据
```


## 参考
>https://learn.microsoft.com/zh-cn/windows/wsl/install
>https://lantern.cool/tool-wsl1/index.html
>https://www.wolai.com/kMgefBXMbXC9eBbpa9kx38
>https://docs.espressif.com/projects/esp-idf/zh_CN/v5.1.1/esp32/get-started/index.html#id2
>