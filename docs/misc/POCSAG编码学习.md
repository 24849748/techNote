
![20230515144752](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20230515144752.png)

![20230515172456](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20230515172456.png)

POCSAG码使用1200bps和512bps的传输速率

* 每次传输包括一个前置码（同步码）
* 后面是n个码组（batch）
* 每个码组由32bit同步码（7C D2 15 D8）和８帧数据组成
* 一帧数据由两个码字（codeword）组成（消息码字`1`&地址码字`0`）
* 一个码字（codeword）32bits，4bytes
    * 地址码字 第1位：0
    * 信息码字 第1位：1



即 接收一帧数据（两个码字）8bytes数据

一码组batch = 32bit 同步码+ ((8frame * 2codeword * 4bytes) = (64bytes))

**BCH（31，21）编码解码**


列车LBJ数据显示示例：
![20230516180612](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20230516180612.png)

8字节

![20230518165545](https://cdn.jsdelivr.net/gh/24849748/PicBed/ob/20230518165545.png)


