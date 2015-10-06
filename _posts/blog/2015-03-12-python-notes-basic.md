---
layout:      post
title:       Python学习笔记-基础篇
category:    blog
description: 学习来源：http://python.xiaoleilu.com/ http://www.liaoxuefeng.com/wiki/001374738125095c955c1e6d8bb493182103fac9270762a000
---

![cover](http://wanzao2.b0.upaiyun.com/system/avatars/427582/original/u.jpg)

## 安装

### Linux
Linux已经自带Python了，我的Centos7自带Python2.7.4，我通过源码安装来更新版本。

```bash
#!/bin/bash
#源码安装
wget https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz
tar -zxvf Python-2.7.9.tgz
cd Python-2.7.9

#编译安装
./configure
make
make install
```

### 安装pip（推荐安装，非必需）
pip是一个包管理器，安装后方便之后框架和依赖包的安装使用。推荐安装。

```bash
#!/bin/bash
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
```

## Hello World
```python
>>> print 'hello, world'
hello, world
>>> exit()
```

### 编辑器
推荐Vim，Windows下使用Notepad++。

### hello_world.py

```python
#!/usr/bin/env python
# -*- coding:utf8-*-

#第一行用于在Linux下被识别从而直接运行
#第二行用于定义此文件的字符编码是utf8，防止乱码，这是一个好习惯

#print可以使用以下两种形式来输出字符到控制台，推荐第二种，可以兼容Python3
print 'Hello World'
print('Hello World')
#可以用逗号分隔每个字符串，打印出来遇到逗号会输出一个空格
print 'Hello','World'

#读取用户输入的字符并赋予name变量
name = raw_input()
```

### 运行

```bash
python hello_world.py
```

## 基础

* `#`开头是注释
* `:`结尾是代码块，代码块缩进推荐**四个空格**

### 数据类型

#### 数字
* 整数： 例如`1` `100`，16进制以`0x`开头，例如`0xff00`
* 浮点数： 例如`3.14`，科学记数法把10用e替代，1.23x10的9次方的就是`1.23e9`或者`12.3e8`
注：整数运算永远精确，浮点数可能存在四舍五入

#### 字符串
* 以`''`或`""`括起来的任意文本，转义使用`\`，用于转义单引号、双引号和特殊字符（例如换行符）
* `r''`表示原始字符串，不需要转义
* `'''我是内容'''`这种三个引号（单双都行）扩起来表示可以换行的文本
* `r'''我是内容'''`表示多行原始字符串，不需要转义
* `u''`表示Unicode字符串
* 字符串格式化 'Hello, %s' % 'world'



#### 布尔值
* `True`
* `False`
布尔值可以用`and`、`or`和`not`运算

#### 空值
`None`

### 变量
变量的类型取决于第一次赋值的类型。
```python
a = 1
```

### 常量
Python中无常量，约定全部大写的变量为常量（值依旧可以变）。

```python
PI = 3.14
```

###类型判断和转换

```python
a = '123'
# 判断类型
type(a)
# 转换为int，其他类型同理
int(a)

## 转换函数表
int(x [,base ])                #将x转换为一个整数
long(x [,base ])             # 将x转换为一个长整数
float(x )                        #将x转换到一个浮点数
complex(real [,imag ])  #创建一个复数
str(x )                           #将对象 x 转换为字符串
repr(x )                        #将对象 x 转换为表达式字符串
eval(str )                      #用来计算在字符串中的有效Python表达式,并返回一个对象
tuple(s )                       #将序列 s 转换为一个元组
list(s )                           #将序列 s 转换为一个列表
chr(x )                          #将一个整数转换为一个字符
unichr(x )                     #将一个整数转换为Unicode字符
ord(x )                          #将一个字符转换为它的整数值
hex(x )                          #将一个整数转换为一个十六进制字符串
oct(x )                           #将一个整数转换为一个八进制字符串
```

### 序列
#### list（列表）

```python
classmates = ['Michael', 'Bob', 'Tracy']
#list中元素个数（得到3）
len(classmates)
#最小元素（得到'Bob'）
min(classmates)
#最大元素（得到'Tracy'）
max(classmates)
# 访问元素（得到'Michael'）
classmates[0]
# 倒数第一个元素（得到'Tracy'）
classmates[-1]
# 追加元素
classmates.append('Adam')
# 位置1插入元素，后面元素会依次后推 
classmates.insert(1, 'Jack')
# 删除末尾元素
classmates.pop()
# 删除位置 1 的元素
classmates.pop(1)
del classmates[1]
# 删除片段
del classmates[i: j]
# 替换元素
classmates[1] = 'Sarah'
#切片（选取第一个到第二个元素组成新列表）
classmates[1: 2]
#切片（选取第一个到第三个元素组成新列表，每隔两个，按照原始list，得到'Bob'）
classmates[1: 3: 2]
# 不同类型元素
L = ['Apple', 123, True]
# list嵌套（list做为list的一个元素）
s = ['python', 'java', ['asp', 'php'], 'scheme']
#取得'php'（相当于二维数组）
print(s[2][2])
#序列连接（两个列表组成新列表）
classmates  + ['lucy', 'joe']
#序列中的元素重复三次
classmates * 3
#元素在列表中是否存在
isHave = 'Bob' in classmates
#转为序列（得到['P', 'y', 't', 'h', 'o', 'n']）
list('Python')
```

#### tuple（元组）
一旦定义不可变。获取元素和list相同，如果元组中只有一个元素，必须补一个逗号，用于和运算符区分。

```python
classmates = ('Michael', 'Bob', 'Tracy')
# 单元素元组
classmates = ('Michael',)
```

### dict和set
#### dict

```python
d = {'Michael': 95, 'Bob': 75, 'Tracy': 85}
#取值（不存在报错）
d['Michael']
#取值，不存在返回`None` 
d.get('Thomas')
#取值，不存在返回自定义值`-1` 
d.get('Thomas', -1)
#定义值
d['Adam'] = 67
#删除键值对
d.pop('Bob')
del (d['Bob'])
#键列表
dict.keys()
#值列表
dict.values()
#键值对元组列表
dict.items()
#遍历
for (k, v) in dict.items():
    print 'dict[%s] =' % k, v
```

#### set
不重复的元素集合。

```python
#定义，需要将list转化为set，自动过滤重复
s = set([1, 2, 3])
#添加
s.add(4)
#删除
s.remove(4)
#交集
set([1, 2, 3]) & set([2, 3, 4])
#并集
set([1, 2, 3]) | set([2, 3, 4])
```

### 条件判断和循环

#### 条件
elif和else都可以省略。条件中非零数值、非空字符串、非空list等，就判断为`True`，否则为`False`。

```
if <条件判断1>:
    <执行1>
elif <条件判断2>:
    <执行2>
elif <条件判断3>:
    <执行3>
else:
    <执行4>
```

#### 循环

```python
#遍历列表
names = ['Michael', 'Bob', 'Tracy']
for name in names:
    print name

# 便利列表2
for x in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]:
    print x

# 遍历列表3，等效2
for x in range(101):
    print x

# while循环（按条件循环）
n = 99
while n > 0:
    print n
    n = n - 2
```

