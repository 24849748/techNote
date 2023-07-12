

高级语法与低级语法：
高低级是相对于机器而言的，越高级人越容易阅读理解，越低级机器执行越高效

|  Python  |     C      |
|:--------:|:----------:|
| 高级语言 | 非高级语言 |
|  解释性  |   编译性   |

解释性带来的好处就是可以，一行一行执行，编译性需要全部编译成一个可执行文件再执行

## 基础语法

与C一些区别：
* python无需 `;` 分号
* python不区分单双引号，但前后要匹配
* python对 缩进/空格敏感
* python不需要特意声明变量


### 输入输出

python的输入输出比C方便，没有%格式符
输出：`print()` 已作为python的内置函数
输入：`input()` 

PS：`input()` 输入默认为字符串

### 类型
* int
* float
* bool
* str
可以使用 `type()` 查看类型

```python
a = bool(0) # 构造函数，可用于强转
type(a) # 输出 bool
print(a) # 输出 False
```

### 运算

普通加减乘与C一样

对于两个字符串，可以使用+法进行**字符串拼接**
```python
"123"+"321" # 输出123321
```

python的乘法对于字符串变量有特殊效果
```python
a = "1"
a*5 # 输出: 11111
```

python的除法有特殊之处：
1. 普通除 `/` ，会自动处理精度问题
2. 地板除 `//`，效果等同于C
```python
2/3    # 输出: 0.66666
2//3   # 输出: 0
```

还有 `& | !`
python可以写成英文字母
```python
True and False # True & False
True or False # True | False
not True # !True
```

### 三目运算

```python
1 if 1>2 else 2 # python的三目运算，1?1>2:2
```

### 判断
```python
if (n := len(a)) > 10:
    #do something

if 1 in a:
    #do something

if 1 not in a:
```
`:=` 是海象运算符
上述 `if` 条件中不能创建变量n，使用海象运算符就可以进行**创建并赋值**

### 循环 

**while**（常用）
```python
a = 0
while a < 10:
    a += 1
    print(a)
```

**for**
```python
a = [3,4,5]
# for i in a:  # 从a拿一个元素赋值给i
#     print(i)
# i

for i in range(len(a)):
    print(a[i])
# list(range(1,7))

for i,index in enumerate(a):  # i,index用了拆包语法
    print(f"i:{i},index:{index}")


# for语法也有break else
a = [1,2,3]
for i in a:
    print(i)
    # break      # break解释for循环
else:   # 上面运行完，默认执行一下else
    print("asd")
```


range(5)：产生一个 含有5个元素的对象



### 全局变量与局部变量

global

nonlocal

## 高级/特殊语法

### 函数嵌套定义

即 函数里面可以定义函数

```python
def func1():
    a = 123
    def func2():
        print(a)
    return func2   # 闭包，返回func2函数，等于c返回函数指针
```

### 拆包语法

```python
a,b,c=[1,2,3]
print(a,b,c)    # 1,2,3
```

* python中 `...` 或 `pass` 相当于c语言的空语句 ` ;`
* // 地板除
* ** 平方乘

### 闭包语法

```python
def func1():
    a = 123
    def func2():
        print(a)
    return func2   # 闭包，返回func2函数，等于c返回函数指针

b = func1()
b() # 等于运行func2()
func1()() # 同上

# func1()里a的值会传给func2(),func2赋值给b
# 执行结果
# 123
# 123
```

### 异常处理

* try异常处理
    * try不能单独存在，必须与except、else、finally关键词搭配使用
    * python可以利用try异常处理实现c语言goto语法
    * python有自己一套标准的异常定义，`TypeError`、`ZeroDivisionError`等
        [菜鸟教程有对这些标准异常的详细介绍](https://www.runoob.com/python/python-exceptions.html)
    * 
```python
try: #捕获异常
    "abc"+123 # TypeError
    # 1/0       # ZeroDivisionError
except: # 异常处理
    print("error")
# except ZeroDivisionError as e: # 捕获指定异常,并取别名为e
#     print(e) # 打印报错的解释
#     print("error")
# except Exception as e: # 捕获所有异常
#     print(e) # 打印报错的解释
#     print("error")
# # except (ZeroDivisionError, TypeError): # 捕获多个指定异常
# #     print("error")
# else:   # 如果没有捕获到异常
#     print("靓仔,谋问题!")
finally: # 报不报错最终都会执行，且在报错前执行
    print("bye")
```

除了try，**assert**在python中同样适用，assert 判断后面True/False
```python
assert 1==1
```

### 匿名函数lambda

用lambda定义的函数可以不用取名，适用于只使用一次，取名困难症患者的福音
格式：`lambda 参数:返回值`

```python
lambda a : a**a
# 等于
def func(a):
    return a*a
    
b = (lambda a : a**a)(2) # lambda a : a**a 就是一个函数
# 等于
b = func(2)
```

### 装饰器 #Python装饰器

装饰器本质是闭包，相当于A函数被B函数包裹，用B装饰A
```python
# 例如，获取某个函数执行时间
import time
def func1(a):
    print(a)
    time.sleep(1)  

t1 = time.time()
func1(1)
t2 = time.time()
t2-t1

# 用装饰器来实现
def get_run_time(fun):
    def get_time():
        t1 = time.time()
        fun()
        t2 = time.time()
        print(t2-t1)
    return get_time

@get_run_time       # 装饰器用法，在func1外面叠加一个函数
def func1():
    print(123)
    time.sleep(1)

func1()
```

### 迭代器 #Python迭代器 

list_iterator

```python
a= [1,2,3,4]
b=iter(a)   # 生成迭代器
type(b)
next(b)  #1
next(b)  #2
next(b)  #3
next(b)  #4
# next(b)  #error
```

python的for语法里面就有迭代器（in后面的参数）
```python
# 如要使a所有元素+1
a= [1,2,3,4]
for index,i in enumerate(a):
    # i = i + 1
    a[index]+=1
a

# 上面简单写法
b = [i+1 for i in a]
## 等效于
# b=[]
# for i in a:
#     b.append(i+1)
b

## 要取部分内容，可以对a切片
# print(a[1:3])
# b = [i+1 for i in a[1:3]]
```

### 生成器 #Python生成器

生成器比迭代器更节省内存

关键字：yield
替代函数里的return

```python
c = [1,2,3,4]
def func(a):
    for i in a:         # a的值赋给i，后面对i操作
        yield i+1       # 第一次运行到这返回后，保存资源，第二次继续从这运行，体现“生成”
  
b = func(c)
next(b)
next(b)
next(b)
```

迭代器应用：斐波那契数列的实现
```python
# 斐波那契数列实现
def fib():
    a1,a2 = 0,1
    while True:
        yield a1
        a1,a2 = a2,a1+a2
  
a = fib()
for index,i in enumerate(a):
    print(i)
    if index == 10 :
        break

a = [1,2,3,4]    # []列表
(i+1 for i in a) # ()变成生成器
```


## 容器

### 字符串

标识：`" "`

python中str类型由容器实现，以 `a = "123456789"` 为例：

容器的操作：
* 索引，与C数组操作一样，支持**负数**索引
    * a[0]，取第0位数据，输出 `1`
    * a[-1]，取倒数第1位
* 切片，**左包括，右不包括**，必须从小到大
    * a[2:5]，取第2到第4位的数据，输出 `345`
    * a[-5,-2]，取倒数第5位到倒数第3位，输出 `567`
    * a[:5]，取0到第4位，输出 `12345`
    * a[4:]，取第4到最后一位，输出 `56789`
* 使用 `len()` 获取容器长度，类比 `strlen()`


### 列表

标识：`[ ]`
容器的索引切片同样适用
* 索引：取出来是元素
* 切片：切出来还是原来类型
* 赋值：可以直接更改列表里元素的值，a[2] = 9
* `+` 拼接；`*` 重复，与字符串一样，不能 `-`

方法：
* append：新增一个元素，如：[1,2,3] 整个放进去
* extend：新增一串元素，如：[1,2,3] 一个一个取出再放进去
* clear：清空
* copy：拷贝  // 区分c=a和c=a.copy()
    * c=a 相当于指针操作
    * c=a.copy() 内存拷贝
* count：计算重复的次数 // 不同len()
* index：从左到右找到元素位置
* insert：插入

`del a[0]` 删除

```python
a = [1,2,3,4,5,6,7,8]
a.append([1,2,3])    # 1,2,3,4,5,6,7,8,[1,2,3]
a.extend([1,2,3])    # 1,2,3,4,5,6,7,8,1,2,3
a.clear()
c = a    # 相当于a指针操作，后续对c操作同样会影响a
c = a.copy()    # 相当于内存拷贝，c和a各单独一份
a.count(4)    # 1,计算list中4重复的次数
a.index(4)    # 4,查找第index个元素
a.insert(2,[3,3])    
a    # 1,2,[3,3],3,4,5,6,7,8  在第2个位置插入[3,3]

del a[3]   # 删除
```


### 元组 

不能修改的list列表，相当于加了const
标识：可有可无`( )`

```python
a = 1,2,3
b = list(a)
type(a)  # list，然后就可以通过list操作元素了
```

### 字典 dict

标识：`{}` 
`{keys:valus}`

字典的嵌套使用
```python
 a{"key1":{"key2":123}}
 a[key1][key2]
```

### 集合 set

标识：`{}`
`{a,b,c}`

特性：
1. 有限性
2. 无序性
3. 唯一性

```python
a = {1,2,3} 
b = {4,5,6} # 无序性
a = {1,2,3,3} # 唯一性,可去重

a.add(4)
a.difference(b)
a.discard(1) # 删除
a.intersection(b) 
a.union(b) # 并集不会修改原来的a

A & B # 交集
A | B # 并集
A - B # 差集
A ^ B # 对称差集（在A或B中，但不会同时出现在AB中）

```


# 函数

* `def func(arg):`
* 支持默认参数 `arg=1`
* 支持指定赋值参数 
* 支持返回多个值 `return a,b,c`
* 函数重载
* 可以指定传入参数类型


```python
def func(a:int):    # 告诉python传入的是int类型，但不限定是int，期望、描述，你可以叛逆传入字符串等
    ...
```


## 文件操作

`f = open("路径/文件名","权限")`

权限：
| ----- |      -----       | ----- |       -----        |
|:-----:|:----------------:|:-----:|:------------------:|
|   w   |   打开只写文件   |  w+   |   打开可读写文件   |
|   r   |   打开只读文件   |  r+   |   打开可读写文件   |
|   a   | 追加打开只写文件 |  a+   | 追加打开可读写文件 |
|  -b   | 以二进制方式操作 |       |                    |


```python
# 读
f = open("test.txt","w")
f.write("hello world")
f.close()

# 写
f = open("test.txt","r")
txt = f.read()
f.close()
txt

# 追加
f = open("test.txt","a")
f.write("hello world")
f.close()
txt

# 上面的等效替代
# 这种写法无需考虑close，不用担心没有close文件
with open("test.txt","r") as f:
    txt = f.read()
print(txt)

with open("hello.txt","w") as d:
    d.write(txt)
```

后一种写法使用更方便，更安全
可以指定以某种编码方式打开文件，如
```python
with open("1.html","w",encoding="utf-8") as f:
    f.write(res.text)
```


# 类与对象

对象是**类的具象**：
* 对象是人要进行研究的具体事物
* 对象不仅能表示事物，还能表示抽象的规则、计划、事件
* 对象有属性（状态），我们用变量（value）来描述
* 对象有方法（行为），我们用函数（func）来描述

类是**对象的抽象**：
* 类是具有相同**特性**和**行为**的对象的概括、总结
* 类的**属性和方法**是对对象的**状态和行为**的抽象

关系：
类的实例化的结果就是对象
对象抽象化的结果就是类

```python
class people:
    def __init__(self,name): # class的构造函数，在class创建对象时默认调用
        self.name = name
        self.food = "没吃"
        print(f"创建了{self.name}")

    def __del__(self): # 析构函数，在对象删除时调用，用得不多
        print("del")

    def eat(self, food): # class里所有func第一个参数需要传self
        self.food = food
        print(f"{self.name}吃了一个{food}")
  
    def get_eat(self):
        print(f"今天吃了{self.food}")
  
person = people("张三") # 类创建对象的参数默认传给__init__函数
# person.__dir__() # 返回对象所有方法
# person.eat("apple")
person.get_eat()
del person # 使用del删除对象
del person.name # 使用del删除对象的属性
```

* **类里面的func第一个参数必须传self**，self参数是对类的当前实例的引用
* 类定义不能为空，可以使用pass语句避免错误


# 库

使用库
```python
import os # 普通导入
import os as o  # 导入os库并重命名为o

import os.path #导入os库里的path子模块
from os import path #效果同上，但上面的调用需要os.path,这个可以直接path
```

* os：系统库
* shutil：os库补充，专门用来操作文件
* requests：网络相关的

**可使用 `help()` 查看库或函数的帮助文档**：`help(os.path)`

### json库

**字符串**
* `json.dumps()`：编码
* `json.loads()`：解码
![](https://c1ns.cn/EqrgV)
![image.png|460](https://raw.githubusercontent.com/24849748/PicBed/main/ob/202306041840649.png)

python json类型对应表
编码：
|    Python    |  JSON  |
|:------------:|:------:|
|     dict     | object |
|  list,tuple  | array  |
|     str      | string |
| int,float... | number |
|     True     |  true  |
|    False     | false  |
|     None     |  null  |
|              |        |
解码：（不同）
| JSON          | Python |
| ------------- | ------ |
| array         | list   |
| number(int)   | int    |
| number(float) | float       |

**文件**
* `json.dump()`：编码
* `json.load()`：解码



# 未整理


`if __name__ == "__main__":`

tips：
1. 路径作为字符串前面要加上 `r`，因为包含 `\`，
2. os.walk返回的文件路径是当前python文件的路径


Todo：
- [ ] python 多任务
- [ ] 