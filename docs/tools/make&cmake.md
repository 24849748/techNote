
在我现阶段接触到的知识里，make、cmake，包括最近接触的rt thread使用的scons，都是一些辅助编译程序的工具。这类工具比keil这些可以一键编译的ide来说，本质都是调用gcc gnu这些底层一点的编译工具链。

# gcc

正式开始前先复习一下gcc相关命令

```shell
# 一步到位
gcc test.c -o test

# 预处理 Preprocessing
gcc -E test.c -o test.i
## 等于
gcc -E test.c

# 编译 Compilation
gcc -S test.i -o test.s

# 汇编 Assembly
gcc -c test.s -o test.o

# 链接 Linking
gcc test.o -o test


# 多个源文件一起编译
gcc test1.c test2.c -o test
## 相当于
gcc -c test1.c -o test1.o
gcc -c test2.c -o test2.o
gcc test1.o test2.o -o test
```

gcc的一些编译选项
```shell
# 使gcc产生尽可能多的警告信息
gcc -Wall main.c -o main

# gcc在所有产生警告的地方停止编译
gcc -Werror main.c -o main

```

**库文件链接**

常见库文件后缀(.so .a .lib .dll)
Linux下标准函数头文件放在 `/usr/include`， 库文件放在`/usr/lib`下

```shell
# 编译成可执行文件
gcc -c -I /usr/include test.c -o test.o
gcc -L /usr/lib test.o -o test 
```

默认情况下，gcc链接时优先使用动态库，编译时加上-static强制使用静态库
```shell
# 在/usr/dev/mysql/lib目录下有链接时所需要的库文件libmysqlclient.so和libmysqlclient.a，为了让GCC在链接时只用到静态链接库
gcc –L /usr/dev/mysql/lib –static –lmysqlclient test.o –o test
```

静态库链接时搜索路径顺序
1. gcc命令种的`-L`参数
2. gcc环境变量`LIBRARY_PATH`
3. 内定目录 `/lib` `/usr/lib` `/usr/local/lib`
动态链接时、执行时搜索路径顺序:
1. 编译目标代码时指定的动态库搜索路径  
2. 环境变量LD_LIBRARY_PATH指定的动态库搜索路径  
3. 配置文件/etc/ld.so.conf中指定的动态库搜索路径  
4. 默认的动态库搜索路径/lib  
5. 默认的动态库搜索路径/usr/lib

# make
make在我大学时就接触了，当时学习linux应用编程，老师大概介绍了makefile的作用，当时不好好学，现在也不想学（笑嘻嘻）。我认为能达到了解、有个概念的程度就可以了

## makefile
**makefile文件中必须要以tab符号来开头**
make执行的时候，需要有个makefile文件来告诉make需要怎样区编译和链接程序。

### makefile的规则
* target：目标体
* prerequisties：依赖文件
* recipe：编译成目标需要执行的命令

```shell
# 例如
utils.o : uitls.c uitls.h
    cc -c utils.c

clean : 
    rm utils.o 
```

上面例子中，`utils.o` 是目标体，`uitls.c uitls.h` 是依赖文件，  `cc -c utils.c` 执行命令

### makefile变量


# cmake
首先，我的理解，cmake是一套像makefile一样的编译工具

### 常用变量
```cmake
# 工程顶层目录
${CMAKE_SOURCE_DIR} 
${PROJECT_SOURCE_DIR}

# 当前处理的 CMakeLists.txt 所在路径
${CMAKE_CURRENT_SOURCE_DIR}

# 返回Cmakelists.txt开头通过 PROJECT 指令定义的项目名称
${PROJECT_NAME}

# 分别用来重新定义最终结果（可执行文件、动静态库文件）的存放目录
${EXECUTABLE_OUTPUT_PATH}
${LIBRARY_OUTPUT_PATH}
```

## 模板


```cmake
cmake_minimum_required(VERSION 3.9)
project(myProject)
 
#设定编译参数

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_BUILD_TYPE "Debug")
 
#设定源码列表.cpp
set(SOURCE_FILES ./main.cc)
#设定所有源码列表 ：aux_source_directory(<dir> <variable>)
#比如:aux_source_directory(${CMAKE_SOURCE_DIR} DIR)  将${CMAKE_SOURCE_DIR}目录下，也就是最顶级目录下所有的.cpp文件放入DIR变量中，后面的add_executable就可以很简化
#    add_executable(hello_world ${DIR})
 
 
#设定头文件路径
include_directories(../include/)
#include_directories("路径1"  “路径2”...)
 
 
#设定链接库的路径（一般使用第三方非系统目录下的库）
link_directories(../build/)
#link_directories("路径1"  “路径2”...)
 
 
#添加子目录,作用相当于进入子目录里面，展开子目录的CMakeLists.txt
#同时执行，子目录中的CMakeLists.txt一般是编译成一个库，作为一个模块
#在父目录中可以直接引用子目录生成的库
#add_subdirectory(math)
 
 
#生成动/静态库
#add_library(动/静态链接库名称  SHARED/STATIC(可选，默认STATIC)  源码列表)
#可以单独生成多个模块
 
 
#生成可执行文件
add_executable(myLevealDB   ${SOURCE_FILES} )
#比如：add_executable(hello_world    ${SOURCE_FILES})
 
 
target_link_libraries(myLevealDB  pthred glog)#就是g++ 编译选项中-l后的内容，不要有多余空格
 
ADD_CUSTOM_COMMAND( #执行shell命令
          TARGET myLevelDB 
          POST_BUILD #在目标文件myLevelDBbuild之后，执行下面的拷贝命令，还可以选择PRE_BUILD命令将会在其他依赖项执行前执行  PRE_LINK命令将会在其他依赖项执行完后执行  POST_BUILD命令将会在目标构建完后执行。
          COMMAND cp ./myLevelDB  ../
) 
```


