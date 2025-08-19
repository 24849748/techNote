

> [USB标准请求及描述符在线分析](https://www.usbzh.com/tool/usb.html)
> 


```c
0x05, 0x01,        // Usage Page (Generic Desktop Ctrls)
0x09, 0x06,        // Usage (Keyboard)
0xA1, 0x01,        // Collection (Application)
0x85, 0x01,        //   Report ID (1)
0x05, 0x07,        //   Usage Page (Kbrd/Keypad)
0x19, 0xE0,        //   Usage Minimum (0xE0)
0x29, 0xE7,        //   Usage Maximum (0xE7)
0x15, 0x00,        //   Logical Minimum (0)
0x25, 0x01,        //   Logical Maximum (1)
0x75, 0x01,        //   Report Size (1)
0x95, 0x08,        //   Report Count (8)
0x81, 0x02,        //   Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
0x95, 0x01,        //   Report Count (1)
0x75, 0x08,        //   Report Size (8)
0x81, 0x01,        //   Input (Const,Array,Abs,No Wrap,Linear,Preferred State,No Null Position)
0x95, 0x05,        //   Report Count (5)
0x75, 0x01,        //   Report Size (1)
0x05, 0x08,        //   Usage Page (LEDs)
0x19, 0x01,        //   Usage Minimum (Num Lock)
0x29, 0x05,        //   Usage Maximum (Kana)
0x91, 0x02,        //   Output (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position,Non-volatile)
0x95, 0x01,        //   Report Count (1)
0x75, 0x03,        //   Report Size (3)
0x91, 0x01,        //   Output (Const,Array,Abs,No Wrap,Linear,Preferred State,No Null Position,Non-volatile)
0x95, 0x06,        //   Report Count (6)
0x75, 0x08,        //   Report Size (8)
0x15, 0x00,        //   Logical Minimum (0)
0x25, 0xFF,        //   Logical Maximum (-1)
0x05, 0x07,        //   Usage Page (Kbrd/Keypad)
0x19, 0x00,        //   Usage Minimum (0x00)
0x29, 0xFF,        //   Usage Maximum (0xFF)
0x81, 0x00,        //   Input (Data,Array,Abs,No Wrap,Linear,Preferred State,No Null Position)
0xC0,              // End Collection

// 65 bytes
```

## 描述结构

hid report descriptor 没有固定的数据结构，有开发者自行组装，这个组装的原材料 HID 规范定义为 ITEM

> [HID 报告描述符详解](https://www.usbzh.com/article/detail-525.html)
> [HID Report Descriptor](https://www.usb.org/sites/default/files/documents/hid1_11.pdf)

有三种类型的 ITEM

* ITEM TAG, 分为 main, global 和 local item 三种类型。
* ITEM TYPE, 指 ITEM 的功能
* ITEM SIZE, 后跟数据长度

### Usage Page

常见page:
1. 0x07 - Keyboard
2. 0x0C - Consumer "特殊设备功能，非系统的"


### report ID

用于标识不同的 report，比如键盘和鼠标的 report ID 是不同的。


### Logical

### Usage

### report size 和 report count

* report size 表示字段大小，单位为 bit
* report count 表示字段个数

每次报告大小 = size x count

```c
// 字段为 8 * 1
0x95, 0x01,        //   Report Count (1)
0x75, 0x08,        //   Report Size (8)
```

