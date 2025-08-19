---
title: Windows 使用技巧
date: 2024-11-15 00:11:40
# description: 
# mermaid: true
categories:
  - tools
tags:
  - windows
---

## 文件夹显示别名

* 打开文件夹选项-查看-隐藏受保护的操作系统文件
* 修改文件夹下 `desktop.ini` 文件
```ini
[.ShellClassInfo]
LocalizedResourceName=
InfoTip=@%SystemRoot%\system32\shell32.dll,-12688
IconResource=%SystemRoot%\system32\imageres.dll,-113
IconFile=%SystemRoot%\system32\shell32.dll
IconIndex=-236
```
* win11 是 UTF-16 LE 编码
* 重启电脑

## 开启网络代理打不开微软商店

终端执行：
```shell
CheckNetIsolation.exe loopbackexempt -a -p=S-1-15-2-1609473798-1231923017-684268153-4268514328-882773646-2760585773-1760938157

# 取消
CheckNetIsolation.exe loopbackexempt -c
# 或者
CheckNetIsolation.exe loopbackexempt -d -p=S-1-15-2-1609473798-1231923017-684268153-4268514328-882773646-2760585773-1760938157
```

参考：
> [配置 Microsoft Store 等软件绕过 V2ray 全局代理](https://zhuanlan.zhihu.com/p/413730301)

## win11 恢复 win10 鼠标右键菜单

```shell
# 改 win10：
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

# 改 win11：
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
```
