
## CORS

CORS（Continuously Operating Reference Stations）就是网络基准站，通过网络收发GPS差分数据。用户访问CORS后，不用单独架设GPS基准站，即可实现GPS流动站的差分定位。

## ntrip

NTRIP（ Networked Transport of RTCM via Internet Protocol）

要访问 CORS 系统，需要网络通讯协议

nrtip 是 RTCM 数据的网络传输协议

ntrip 是应用层协议

![ntrip 系统组成](https://i-blog.csdnimg.cn/blog_migrate/a1f2d733801ae8a8a8e08098112d0f98.png)

- NtripSource：用来产生 GPS 差分数据，并把差分数据提交给 NtripServer
- NtripServer：负责把 GPS 差分数据提交给 NtripCaster
- NtripCaster：差分数据中心，负责接收、发送 GPS 差分数据
- NtripClient：登录 NtripCaster 后，NtripCaster 把 GPS 差分数据发送给它

`NtripSource`  和 `NtripServer` 一般集成在一台 GPS 基站内，GPS 基站产生差分数据（`NtripSource` 角色），再通过网络发送给 `NtripCaster`（`NtripServer` 角色）

`NtripCaster` 一般就是一台固定IP地址的服务器，它负责接收、发送差分数据。给 `NtripClient` 发送差分数据时有两种方案：
1. 直接转发 `NtripSource` 产生的差分数据；
2. 通过解算多个NtripSource的差分数据，为 `NtripClient` 产生一个虚拟的基准站（即VRS）。


### 使用方式

4G 模组这边是 `NtripServer`

NtripServer访问NtripCaster的步骤

1. 与NtripCaster建立TCP连接；
2. 给NtripCaster发送如下数据
   ```bash
   SOURCE letmein /Mountpoint\r\n # Mountpoint是挂载点名称，注意它前面的 / 不能省略，NtripServer可能有多个，挂载点用来区分它们。
   Source-Agent:NTRIP NtripServerCMD/1.0\r\n # 不是必需的，表示 NtripServer 的软件名（NtripServerCMD）和版本（1.0）
   \r\n
   ```
3. NtripCaster给NtripServer的回复
   ```bash
   ICY 200 OK\r\n # 挂载点、密码均有效

   ERROR - Bad Password\r\n # 挂载点或密码无效
   ```
4. NtripServer给NtripCaster发送差分数据


TODO [NtripClient访问NtripCaster的步骤](https://blog.csdn.net/mayue_web/article/details/121020565)