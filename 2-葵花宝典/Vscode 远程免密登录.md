
### 1、生成本地ssh密钥

```shell
ssh-keygen
```

一路回车，完成后可以在用户目录下`.ssh`文件夹里看到密钥：
id_rsa    // 私钥
id_rsa.pub   // 我们要上传的公钥


### 2、上传密钥到远程服务器

```shell
ssh-copy-id [远程ip]
```

或者可以用WindTerm拖动上传

远程服务器：
1. 在远程服务器 `mkdir` 新建一个 `.ssh` 文件夹
3. 把本地 `id_rsa.pub` 上传到 `.ssh` 文件夹里
4. 改名： `mv ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys`
5. 改权限 
    1. chmod 644 .ssh/authorized_keys
    2. chmod 755 .ssh


搞定~