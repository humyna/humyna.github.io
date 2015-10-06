---
layout:      post
title:       Python学习笔记-面向对象篇
category:    blog
description: 学习来源：http://python.xiaoleilu.com/ http://www.liaoxuefeng.com/wiki/001374738125095c955c1e6d8bb493182103fac9270762a000
---

![cover](http://img.hb.aicdn.com/1d5ebdc0c15cdbae263160f760f137ba1188e29922afa-pWXF70)

## 定义

```python
#创建类
class Student1:
    pass

#创建类，继承自object类
class Student1(object):
    pass

#带构造方法的类以及对象方法调用
class Student2(object):

    def __init__(self, name, score):
        self.name = name
        self.score = score

    def print_score(self):
        print('%s: %s' % (self.name, self.score))
```

##实例化和调用

```python
#实例化类
>>> bart = Student1()
>>> bart
<__main__.Student object at 0x10a67a590>
>>> Student1
<class '__main__.Student'>

>>> bart = Student2('Bart Simpson', 59)
>>> bart.print_score()
Bart Simpson: 59

#绑定属性
>>> bart.name = 'Bart Simpson'
>>> bart.name
'Bart Simpson'
```

## 访问限制
1. 双下划线`__`： 私有变量（解释器把双下划线改成了单下划线，依旧可以通过单下划线访问）
2. 单下划线`_`： 可以被外部访问，但约定俗称不要访问
3. 双下划线包围`__XXX__`： 特殊变量，可以访问

## 继承

```python
#父类、基类或者超类
class Animal(object):
    def run(self):
        print('Animal is running...')

#子类
class Dog(Animal):
    pass

class Cat(Animal):
    pass
```

## 多态
在继承关系中，如果一个实例的数据类型是某个子类，那它的数据类型也可以被看做是父类。但是，反过来就不行。

## 对象类型
1. `type()`: 判断对象类型
2. `isinstance()`：对象是否是某种类型
3. `dir()`：对象的所有属性和方法
4. `hasattr(obj, 'x')`：有属性'x'吗？
5. `setattr(obj, 'y', 19)`：设置一个属性'y'
6. `getattr(obj, 'y')`：获取属性'y'，属性不存在，抛出`AttributeError`

## 实例属性和类属性
```python
class Student(object):
    #类属性
    name = 'Student'

    #实例属性
    def __init__(self, name):
        self.name = name
```

## 动态绑定方法
```python
#给对象绑定方法
>>> def set_age(self, age): # 定义一个函数作为实例方法
...     self.age = age
...
>>> from types import MethodType
>>> s.set_age = MethodType(set_age, s) # 给实例绑定一个方法
>>> s.set_age(25) # 调用实例方法
>>> s.age # 测试结果
25

#给类绑定方法
>>> def set_score(self, score):
...     self.score = score
...
>>> Student.set_score = MethodType(set_score, Student)
```

## `__slots__`限制只能添加指定属性

```python
class Student(object):
    __slots__ = ('name', 'age') # 用tuple定义允许绑定的属性名称

>>> s = Student() # 创建新的实例
>>> s.name = 'Michael' # 绑定属性'name'
>>> s.age = 25 # 绑定属性'age'
>>> s.score = 99 # 绑定属性'score'
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'Student' object has no attribute 'score'
```

## `@property`简化setter和getter
```python
class Student(object):

    @property
    def score(self):
        return self._score

    @score.setter
    def score(self, value):
        if not isinstance(value, int):
            raise ValueError('score must be an integer!')
        if value < 0 or value > 100:
            raise ValueError('score must between 0 ~ 100!')
        self._score = value

#当调用属性赋值时，自动调用对应的setter方法
>>> s = Student()
>>> s.score = 60 # OK，实际转化为s.set_score(60)
>>> s.score # OK，实际转化为s.get_score()
60
>>> s.score = 9999
Traceback (most recent call last):
  ...
ValueError: score must between 0 ~ 100!
```

## 多重继承

```python
class Dog(Mammal, Runnable):
    pass

#需要“混入”额外的功能,使用叫做 MixIn 的设计
class Dog(Mammal, RunnableMixIn, CarnivorousMixIn):
    pass
```

## 定制类
1. `__str__`：类似于Java中的toString()方法
2. `__repr__()`：调试时使用的字符串
3. `__iter__`：返回迭代对象，用于`for ... in`循环
4. `__getitem__`：使用下标方式获取元素
5. `__getattr__`：没有找到属性的情况下调用此方法
6. `__call__`：把对象看成函数而直接调用所执行的方法

## 枚举类
```python
from enum import Enum

Month = Enum('Month', ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'))

#遍历
for name, member in Month.__members__.items():
    print(name, '=>', member, ',', member.value)

#派生
from enum import Enum, unique

@unique
class Weekday(Enum):
    Sun = 0 # Sun的value被设定为0
    Mon = 1
    Tue = 2
    Wed = 3
    Thu = 4
    Fri = 5
    Sat = 6

#@unique用于检查重复
```

## `type()`

### 查看类型
```python
>>> from hello import Hello
>>> h = Hello()
>>> h.hello()
Hello, world.
>>> print(type(Hello))
<class 'type'>
>>> print(type(h))
<class 'hello.Hello'>
```

### 创建类型

```python
#1.class名，2.父类集合，3.class的方法名称与函数绑定
>>> def fn(self, name='world'): # 先定义函数
...     print('Hello, %s.' % name)
...
>>> Hello = type('Hello', (object,), dict(hello=fn)) # 创建Hello class
>>> h = Hello()
>>> h.hello()
Hello, world.
>>> print(type(Hello))
<class 'type'>
>>> print(type(h))
<class '__main__.Hello'>
```

### metaclass