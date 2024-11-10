---
title: 【linux 学习笔记】POSIX 互斥锁
date: 2024-11-10 22:05:44
categories:
  - linux
tags:
  - linux
---

* 锁机制是 Linux 内核精髓所在
* Linux 锁种类很多：互斥锁、文件锁、读写锁等
* 信号量也是一种锁
* 互斥锁只有**开锁**和**闭锁**两种状态

只有一个线程能获取互斥锁，当持有互斥锁的线程再次获得该锁而不被阻塞，那这个锁就是**递归锁**，也叫**可重入锁**。

死锁：两个线程互相锁住对方，或者自己把自己阻塞住

要避免死锁，最好遵循：
1. 对共享资源操作前一定要获取锁
2. 完成操作后一定要释放锁
3. 占用锁的时间尽可能短
4. 有多个锁时，获取时是 ABC，释放时也应该是 ABC

互斥锁能降低信号量存在的优先级翻转问题带来的影响

## 互斥锁使用

```c
// 静态初始化
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

// 动态初始化，mutexattr = NULL 使用默认属性
int pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *mutexattr);

// 销毁
int pthread_mutex_destroy(pthread_mutex_t *mutex);

// 上锁，阻塞地取得所有权
int pthread_mutex_lock(pthread_mutex_t *mutex);

// 非阻塞上锁
int pthread_mutex_trylock(pthread_mutex_t *mutex);

// 解锁
int pthread_mutex_unlock(pthread_mutex_t *mutex);
```

代码示例：
```c
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <pthread.h>

#include "pt.h"

/* 
1. 即使 sleep，其他线程也不会得到执行
2. 期待结果应该是 3 个线程打印是连续的
 */

#define THREAD_NUM 3
pthread_mutex_t mutex;

static void *thread_mutex_test(void *arg)
{
    int idx = (unsigned long long)arg;

    int ret = 0;
    // 上锁
    ret = pthread_mutex_lock(&mutex);
    PT_LOGI("thread[%d] mutex lock\n", idx);
    if (ret != 0)
    {
        PT_LOGE("thread[%d] lock failed\n", idx);
        pthread_mutex_unlock(&mutex);
        pthread_exit(NULL);
    }

    PT_LOGI("thread[%d] running...\n", idx);
    sleep(2);

    PT_LOGI("thread[%d] mutex unlock\n", idx);

    // 解锁
    pthread_mutex_unlock(&mutex);

    pthread_exit(NULL);
}

int main(int argc, char *argv[])
{
    pthread_t tid[THREAD_NUM];
    int ret = 0;

    // 初始化互斥锁
    pthread_mutex_init(&mutex, NULL);

    for (int i = 0; i < THREAD_NUM; i++)
    {
        ret = pthread_create(&tid[i], NULL, (void *)thread_mutex_test, (void *)(unsigned long long)i);
        if (ret != 0)
        {
            PT_LOGE("thread[%d] create failed\n", i);
            exit(ret);
        }
    }

    for (int i = 0; i < THREAD_NUM; i++)
    {
        pthread_join(tid[i], NULL);
    }

    // 销毁互斥锁
    pthread_mutex_destroy(&mutex);

    return 0;
}

```