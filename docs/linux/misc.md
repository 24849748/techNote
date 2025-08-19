---
categories:
  - linux
tags:
  - linux
published: false
---

## 重定向输出

> https://gwaslab.org/2021/11/28/linux-redirection/

## 有用的脚本

```sh
function runExe() {
    if [ $# -lt 1 ]; then
        echo -e "\033[1;31mERR: require at least input EXE name!!\033[0m"
        return
    fi

    printf "\033[1;32m"
    printf "#################################\n"
    printf "#   START %-21s #\n" $1
    printf "#################################"
    printf "\033[0m\n"

    # Run EXE bin here
    start_time=$(date +%s)
    $@
    end_time=$(date +%s)
    spent_time=$((end_time - start_time))
    echo "$1 start spent time: $spent_time s"
    sleep 1
}
```

## 后台运行

在程序中处理
```c
    if (argc > 1 && strcmp(argv[1], "-b") == 0) {
        signal(SIGCHLD, SIG_IGN);
        signal(SIGHUP, SIG_IGN);
        pid_t pid = fork();
        if (pid < 0) {
            printf("fork failed");
            exit(-1);
        } else if (pid != 0) {
            return 0;
        }
    }
```

## perror 和 fprintf

如果有错误码, perror 后面会带空格和系统的输出

* fprintf 通常用于打印通用的错误或调试信息。
* perror 更适合在处理涉及系统调用的错误时使用，因为它可以提供更多上下文信息。


## 串口回环测试

查看串口
```bash
ls -l /dev/ttyS*
```
* 串口: `/dev/ttyS*`
* USB: `/dev/ttyUSB*`

配置串口属性
```bash
stty -F /dev/ttyS0 115200 parodd

# 获取当前串口配置
stty
```

发送数据
```bash
echo "hello world" > /dev/ttyS1
```

读数据
```bash
cat /dev/ttyS1
```


