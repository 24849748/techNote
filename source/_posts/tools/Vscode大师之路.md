---
title: Vscode使用笔记
date: 2024-04-29 00:11:32
categories:
- tools
tags:
- Vscode
- Snippet
published: false
---

## 修改外部默认终端
* 快捷键 `ctrl+shift+c`
* 默认使用的是 cmd `C:\WINDOWS\System32\cmd.exe`
* 打开设置，搜索外部
* 修改 Windows Exec， 我改的是 pwsh `C:\Program Files\PowerShell\7\pwsh.exe`

## 创建自定义块注释
1. `ctrl+shift+p` 打开键盘快捷方式 (JSON)
2. 添加
```json
{
    "key": "shift+alt+q",
    "command": "editor.action.insertSnippet",
    "when": "editorTextFocus && foldingEnabled",
    "args": {
        "snippet": "$BLOCK_COMMENT_START -------- $0 start -------- $BLOCK_COMMENT_END\n$TM_SELECTED_TEXT\n$BLOCK_COMMENT_START -------- $0 end --------- $BLOCK_COMMENT_END"
    }
}
```
3. 在代码中选中要折叠的代码块，按快捷键` ctrl+shift+q ` 触发

## 自定义创建代码折叠块

1. `ctrl+shift+p` 打开键盘快捷方式 (JSON)
2. 添加
```json
{
    "key": "ctrl+shift+'",
    "command": "editor.createFoldingRangeFromSelection",
    "when": "editorTextFocus && foldingEnabled"
}
```
3. 在代码中选中要折叠的代码块，按快捷键` ctrl+shift+' ` 触发

折叠代码快捷键：
* `ctrl+shift+[`，折叠
* `ctrl+shift+]`，展开

## 隐藏智能补全的 .o 等文件

1. ctrl + shift + p 选择以 json 打开用户 settings.json 文件
2. 添加
```json
    "C_Cpp.files.exclude": {
        "**/*.o": true,  // 需要隐藏的文件类型
        "**/.vscode": true,
        "**/.vs": true
    },
```

## 远程免密登录
### 1、生成本地 ssh 密钥

```bash
ssh-keygen
```

一路回车，完成后可以在用户目录下`.ssh`文件夹里看到密钥：
id_rsa    // 私钥
id_rsa.pub   // 我们要上传的公钥

### 2、上传密钥到远程服务器

```bash
ssh-copy-id [remote ip]
```

或者可以用 WindTerm 拖动上传

远程服务器：
1. 在远程服务器 `mkdir` 新建一个 `.ssh` 文件夹
3. 把本地 `id_rsa.pub` 上传到 `.ssh` 文件夹里
4. 改名： `mv ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys`
5. 改权限 
    1. chmod 644 .ssh/authorized_keys
    2. chmod 755 .ssh

搞定~
