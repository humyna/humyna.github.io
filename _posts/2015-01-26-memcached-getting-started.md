---
layout: post
title: "memcached入门(H1技术笔记第1天)"
description: ""
category: 
tags: [memcached]
---
{% include JB/setup %}

##Getting Started

###下载

 [下载地址](http://memcached.org/downloads)，最新版本为1.4.22

###安装

- Debian/Ubuntu: apt-get install libevent-dev 
- Redhat/Centos: yum install libevent-devel

>  wget http://memcached.org/latest
>  
>  tar -zxvf memcached-1.x.x.tar.gz
>  
>  cd memcached-1.x.x
>  
>  ./configure && make && make test && sudo make install

###启动
./memcached -d -m 1024 -l localhost -p 11211

这会以守护程序的形式启动 memcached（-d），为其分配 1GB 内存（-m 1024），并指定监听 localhost，即端口 11211。

###连接到memcached
telnet localhost 11211

如果一切正常，则应该得到一个 telnet 响应，它会指示 Connected to localhost（已经连接到 localhost）。

###常用命令说明
启动/结束
memcached -d -m 10 -u root -l localhost -p 11211 -c 256 -P /tmp/memcached.pid

- -d 选项是启动一个守护进程，
- -m 是分配给Memcache使用的内存数量，单位是MB，这里是10MB
- -u 是运行Memcache的用户，这里是root
- -l 是监听的服务器IP地址，如果有多个地址的话，这里指定了服务器的IP地址localhost 
- -p 是设置Memcache监听的端口，这里设置了12000，最好是1024以上的端口
- -c 选项是最大运行的并发连接数，默认是1024，这里设置了256，按照服务器的负载量来设定
- -P 是设置保存Memcache的pid文件
- kill `cat /tmp/memcached.pid`

###获取运行状态
- echo stats | nc localhost 11211
- watch "echo stats | nc localhost 11211" (实时状态)

##客户端命令详解


> 9 个memcached客户端命令可以分为三类：基本、高级、管理

###基本memcached客户端命令


> set、add、replace、get、delete



1. 前三个命令是用于操作存储在 memcached 中的键值对的标准修改命令。

####修改命令语法
`command <key> <flags> <expiration time> <bytes>` 

`<value>`

####修改命令参数说明

- key 用于查找缓存值
- flags 可以包括键值对的整型参数，客户机使用它存储关于键值对的额外信息
- expiration time 在缓存中保存键值对的时间长度（以秒为单位，0 表示永远）
- bytes 在缓存中存储的字节点
- value 存储的值（始终位于第二行）

#####set

set 命令用于向缓存添加新的键值对。如果键已经存在，则之前的值将被替换。

#####add

仅当缓存中不存在键时，add 命令才会向缓存中添加一个键值对。如果缓存中已经存在键，则之前的值将仍然保持相同，并且您将获得响应 NOT_STORED。

#####replace

仅当键已经存在时，replace 命令才会替换缓存中的键。如果缓存中不存在键，那么您将从 memcached 服务器接受到一条 NOT_STORED 响应。


后两个基本命令get和delete的语法

`command <key>`

#####get

#####delete

###高级memcached客户端命令

可以在memcached中使用的两个高级命令是gets和cas。gets和cas命令需要结合使用。使用这两个命令来确保不会将现有的名称/值对设置为新值（如果该值已经更新过）。

#####gets

gets命令的功能类似于基本的get命令。两个命令之间的差异在于，gets返回的信息稍微多一些：64位的整型值非常像名称/值对的“版本”标识符。

gets命令将返回一个额外的值，用于标识名称/值对。如果对此名称/值对执行另一个set命令，则gets 返回的额外值将会发生更改，以表明名称/值对已经被更新。 

#####cas

cas（check和set）是一个非常便捷的memcached命令，用于设置名称/值对的值（如果该名称/值对在您上次执行gets后没有更新过）。它使用与 set 命令相类似的语法，但包括一个额外的值：gets返回的额外值。

从本质上说，同时使用 gets和 cas命令可以防止使用自上次读取后经过更新的名称/值对。

###缓存管理命令
最后两个memcached命令用于监控和清理memcached实例。它们是stats和flush_all命令。

#####stats

stats 命令的功能正如其名：转储所连接的 memcached 实例的当前统计数据。

#####flush_all

flush_all 是最后一个要介绍的命令。这个最简单的命令仅用于清理缓存中的所有名称/值对。如果您需要将缓存重置到干净的状态，则 flush_all 能提供很大的用处。


##缓存性能
> 使用高级 memcached 命令来确定缓存的性能。
>
>stats 命令用于调优缓存的使用。

###有两种方法用于确定缓存的效率

####方法一

需要注意的两个最重要的统计数据是get_hits和get_misses。这两个值分别指示找到名称/值对的次数（get_hits）和未找到名称/值对的次数（get_misses）。结合这些值，我们可以确定缓存的利用率如何。

初次启动缓存时，可以看到get_misses会自然地增加，但在经过一定的使用量之后，这些get_misses值应该会逐渐趋于平稳 — 这表示缓存主要用于常见的读取操作。

如果看到get_misses继续快速增加，而get_hits逐渐趋于平稳，则需要确定一下所缓存的内容是什么。可能缓存了错误的内容。

####方法二

查看缓存的命中率（hit ratio）。缓存命中率表示执行get的次数与错过get的次数的百分比。要确定这个百分比，需要运行stats命令，用get_hits的数值除以cmd_gets。

在理想情况下，可能希望得到更高的百分比—比率越高越好。查看统计数据并不时测量它们可以很好地判定缓存策略的效率。

