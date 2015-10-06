---
layout:      post
title:       Python学习笔记-函数篇
category:    blog
description: 学习来源：http://python.xiaoleilu.com/ http://www.liaoxuefeng.com/wiki/001374738125095c955c1e6d8bb493182103fac9270762a000
---

![cover](http://img5.duitang.com/uploads/item/201408/31/20140831102529_Ht4Cs.thumb.700_0.png)

## 定义

### 返回单值

```python
def my_abs(x):
    if x >= 0:
        return x
    else:
        return -x
```

### 返回多值
返回多值就是返回一个tuple

```python
import math

def move(x, y, step, angle=0):
    nx = x + step * math.cos(angle)
    ny = y - step * math.sin(angle)
    return nx, ny
```

### 空函数

```python
def nop():
    pass
```

### 指定默认参数
必选参数在前，默认参数在后。默认参数需指向不可变对象（默认参数值在函数定义时被计算）

```python
def power(x, n=2):
    s = 1
    while n > 0:
        n = n - 1
        s = s * x
    return s
```

### 可变参数

```python
def calc(*numbers):
    sum = 0
    for n in numbers:
        sum = sum + n * n
    return sum
```

调用可变参数的函数方法

```python
>>> calc(1, 2)
5
>>> calc()
0
>>> nums = [1, 2, 3]
>>> calc(*nums)
14
```

### 关键字参数

```python
def person(name, age, **kw):
    print 'name:', name, 'age:', age, 'other:', kw
```

调用关键字参数的方法

```python
>>> person('Michael', 30)
name: Michael age: 30 other: {}
>>> person('Bob', 35, city='Beijing')
name: Bob age: 35 other: {'city': 'Beijing'}
>>> person('Adam', 45, gender='M', job='Engineer')
name: Adam age: 45 other: {'gender': 'M', 'job': 'Engineer'}
>>> kw = {'city': 'Beijing', 'job': 'Engineer'}
>>> person('Jack', 24, **kw)
name: Jack age: 24 other: {'city': 'Beijing', 'job': 'Engineer'}
```

注：

* 参数定义的顺序必须是：必选参数、默认参数、可变参数和关键字参数。
* 对于任意函数，都可以通过类似`func(*args, **kw)`的形式调用它，无论它的参数是如何定义的。

## 递归
如果一个函数在内部调用自身本身，这个函数就是递归函数。

### 尾递归
在函数返回的时候，调用自身本身，并且，return语句不能包含表达式。

## 高阶函数
* 变量可以指向函数（函数可以赋值给一个变量）
* 函数名也是变量（函数名可以赋值其他值）
* 函数可以做为函数的参数（高阶函数）

### map(func, list)
map()函数接收两个参数，一个是函数，一个是序列，map将传入的函数依次作用到序列的每个元素，并把结果作为新的list返回。

```python
>>> def f(x):
...     return x * x
...
>>> map(f, [1, 2, 3, 4, 5, 6, 7, 8, 9])
[1, 4, 9, 16, 25, 36, 49, 64, 81]
```

### reduce(func_with_two_params, list)
reduce把一个函数作用在一个序列[x1, x2, x3...]上，这个函数必须接收两个参数，reduce把结果继续和序列的下一个元素做累积计算。

```python
reduce(f, [x1, x2, x3, x4])
#相当于：
f(f(f(x1, x2), x3), x4)
```

```python
>>> def add(x, y):
...     return x + y
...
>>> reduce(add, [1, 3, 5, 7, 9])
25
```

### filter(func_return_bool, list)
把传入的函数依次作用于每个元素，然后根据返回值是True还是False决定保留还是丢弃该元素。

```python
def is_odd(n):
    return n % 2 == 1

filter(is_odd, [1, 2, 4, 5, 6, 9, 10, 15])
# 结果: [1, 5, 9, 15]
```

### sorted
对于两个元素`x`和`y`，如果认为`x < y`，则返回`-1`，如果认为`x == y`，则返回`0`，如果认为`x > y`，则返回`1`，

```python
>>> sorted([36, 5, 12, 9, 21])
[5, 9, 12, 21, 36]
```

高阶函数用法

```python
def reversed_cmp(x, y):
    if x > y:
        return -1
    if x < y:
        return 1
    return 0

>>> sorted([36, 5, 12, 9, 21], reversed_cmp)
[36, 21, 12, 9, 5]
```

## 函数做为返回值

```python
def lazy_sum(*args):
    def sum():
        ax = 0
        for n in args:
            ax = ax + n
        return ax
    return sum

>>> f = lazy_sum(1, 3, 5, 7, 9)
>>> f
<function sum at 0x10452f668>
>>> f()
25
```

注：每次调用`lazy_sum()`都会返回一个新的函数，即使传入相同的参数。

### 闭包

```python
def count():
    fs = []
    for i in range(1, 4):
        def f():
             return i*i
        fs.append(f)
    return fs

f1, f2, f3 = count()
>>> f1()
9
>>> f2()
9
>>> f3()
9
```
原因是调用count的时候循环已经执行，但是`f()`还没有执行，直到调用其时才执行。所以返回函数不要引用任何循环变量，或者后续会发生变化的变量。

## 匿名函数（lambda表达式）

```python
lambda x: x * x
```

等价于:

```python
def f(x):
    return x * x
```

关键字`lambda`表示匿名函数，冒号前面的`x`表示函数参数。

### 匿名函数做为返回值

```python
def build(x, y):
    return lambda: x * x + y * y
```

## 装饰器（@func）
在代码运行期间动态增加功能的方式，称之为“装饰器”（Decorator），本质上，decorator就是一个返回函数的高阶函数。

```python
def log(func):
    def wrapper(*args, **kw):
        print 'call %s():' % func.__name__
        return func(*args, **kw)
    return wrapper

@log
def now():
    print '2013-12-25'

>>> now()
call now():
2013-12-25

#相当于执行：

now = log(now)
```

### 带参数的装饰器

```python
def log(text):
    def decorator(func):
        def wrapper(*args, **kw):
            print '%s %s():' % (text, func.__name__)
            return func(*args, **kw)
        return wrapper
    return decorator

@log('execute')
def now():
    print '2013-12-25'

#执行结果
>>> now()
execute now():
2013-12-25

#相当于执行：

>>> now = log('execute')(now)
```

剖析：首先执行`log('execute')`，返回的是`decorator`函数，再调用返回的函数，参数是`now`函数，返回值最终是`wrapper`函数。

### `__name__`
由于函数的`__name__`已经改变，依赖于此的代码就会出错。因此使用`functools.wraps`。

```python
import functools

def log(func):
    @functools.wraps(func)
    def wrapper(*args, **kw):
        print 'call %s():' % func.__name__
        return func(*args, **kw)
    return wrapper

#对于带参函数

import functools

def log(text):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kw):
            print '%s %s():' % (text, func.__name__)
            return func(*args, **kw)
        return wrapper
    return decorator
```

## 偏函数（固定函数默认值）

```python
>>> import functools
>>> int2 = functools.partial(int, base=2)
>>> int2('1000000')
64
>>> int2('1010101')
85

#相当于：

def int2(x, base=2):
    return int(x, base)
```

```python
max2 = functools.partial(max, 10)
```

相当于为`max`函数指定了第一个参数

```python
max2(5, 6, 7)

#相当于：

max(10, 5, 6, 7)
```