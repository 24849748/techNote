---
title: 【linux 学习笔记】POSIX 信号量
date: 2024-11-10 22:05:27
categories:
  - linux
tags:
  - linux
---

* 可实现进程/线程之间同步或临界资源的**互斥**访问
* POSIX 信号量分为有名信号量和无名信号量
  * 无名直接保存在内存中，因此只能用于同一进程的线程间
  * 有名要求创建一个文件，常用于进程间

**临界资源**：同一时刻只允许有限个进程/线程读写的资源，通常包括硬件资源（cpu、内存、外设等）、软件资源（共享代码段、变量等）

信号量中存在一个非负整数，所有获取它的进程/线程会使该数减一，所有尝试获取信号量的进程/线程都将处于阻塞

信号量的操作分为两个：
* P 操作：
  1. 若资源可用（信号量大于 0），则占用资源（信号量减 1，进入临界区）
  2. 若资源不可用（信号量==0），则阻塞直到被系统分配
* V 操作
  1. 如果该信号量的等待队列有别的进程/线程在等，那就唤醒一个阻塞的进程/线程。
  2. 如果没有进程/线程，则释放资源（信号量加 1）

> 总结：P 操作是我想申请一个停车位，V 操作是我要离开停车位

执行顺序：
1. P 操作
2. 临界区操作
3. V 操作

## POSIX 信号量使用

### 有名信号量

有名信号量是一个文件，创建出来后在 `/dev/shm` 路径下有个 `sem.` 前缀的文件，完整名字是 `sem.name` 

```bash
bosco@2004 ~/Project/code $ ls -l /dev/shm
总用量 4
-rw-r--r-- 1 bosco bosco 32 11 月 10 15:30 sem.my_sem
```

```c
#include <semaphore.h>

// 如果信号量在，mode value 被忽略
sem_t *sem_open(const char *name, int oflag, mode_t mode, unsigned int value);

// P 操作
int sem_wait(sem_t *sem);

// 非阻塞的 P 操作
int sem_trywait(sem_t *sem);

// V 操作
int sem_post(sem_t *sem);

// 关闭，仅表示当前进程/线程不再使用，不会删除信号量
int sem_close(sem_t *sem);

// 主动删除操作
int sem_unlink(const char *name);
```

代码示例：
```c
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/wait.h>

#include "pt.h"

int main(int argc, char *argv[])
{
    int pid;
    sem_t *sem;
    const char *sem_name = "my_sem";

    pid = fork();

    if (pid < 0)
    {
        PT_LOGE("fork error\n");
    }
    else if (pid == 0)
    {
        sem = sem_open(sem_name, O_CREAT, 0644, 1);
        if (sem == SEM_FAILED)
        {
            PT_LOGE("create semaphone error\n");
            sem_unlink(sem_name);
            exit(-1);
        }

        // P 操作
        sem_wait(sem);

        for (int i = 0; i < 5; i++)
        {
            PT_LOGI("child running: %d\n", i);
            sleep(1);
        }

        // V 操作
        sem_post(sem);
    }
    else
    {
        sem = sem_open(sem_name, O_CREAT, 0644, 1);
        if (sem == SEM_FAILED)
        {
            PT_LOGE("create semaphone error\n");
            sem_unlink(sem_name);
            exit(-1);
        }

        // P 操作
        sem_wait(sem);

        for (int i = 0; i < 3; i++)
        {
            PT_LOGI("parent running: %d\n", i);
            sleep(1);
        }

        // V 操作
        sem_post(sem);

        // 等子进程结束
        wait(NULL);
        // 关闭信号量
        sem_close(sem);
        // 删除信号量
        sem_unlink(sem_name);
    }

    return 0;
}
```

### 无名信号量

* 仅在同一个进程内使用
* fork 出来的子进程不会继承信号量

```c
// 不能多次 init；pshared 只能取 0
int sem_init(sem_t *sem， int pshared， unsigned int value);

int sem_wait(sem_t *sem);

int sem_trywait(sem_t *sem);

int sem_post(sem_t *sem);

int sem_destroy(sem_t *sem);
```

代码示例：
```c
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/wait.h>

#include "pt.h"

#define THREAD_NUM 3

sem_t sem[THREAD_NUM];

static void *thread_sem_unname(void *arg)
{
    int idx = (unsigned long long)arg;

    // P 操作
    PT_LOGI("P sem[%d]\n", idx);
    sem_wait(&sem[idx]);

    PT_LOGI("thread[%d] start\n", idx);

    // 执行 5 次打印
    for (int i = 0; i < 5; i++)
    {
        PT_LOGI("thread[%d] running... %d\n", idx, i);
        sleep(1);
    }

    PT_LOGI("thread[%d] end\n", idx);

    // 接触进程
    pthread_exit(NULL);
}

int main(int argc, char *argv[])
{
    pthread_t tid[THREAD_NUM];
    int ret = 0;

    for (int i = 0; i < THREAD_NUM; i++)
    {
        // 创建无名信号量
        sem_init(&sem[i], 0, 0);

        // 创线程，并传入 index
        ret = pthread_create(&tid[i], NULL, thread_sem_unname, (void *)(unsigned long long)i);
        if (ret != 0)
        {
            PT_LOGE("thread[%d] create failed\n", i);
            exit(ret);
        }
    }

    PT_LOGI("thread create done! Wait finish...\n");

    for (int i = 0; i < THREAD_NUM; i++)
    {
        // V 操作
        PT_LOGI("V sem[%d]\n", i);
        sem_post(&sem[i]);
        ret = pthread_join(tid[i], NULL);
        if (!ret)
        {
            PT_LOGI("thread[%d] join done\n", i);
        }
        else
        {
            PT_LOGE("thread[%d] join failed\n", i);
        }
    }

    // 删除信号量
    for (int i = 0; i < THREAD_NUM; i++)
    {
        sem_destroy(&sem[i]);
    }

    return 0;
}
```
