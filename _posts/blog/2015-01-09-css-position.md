---
layout:      post
title:       CSS Position学习
category:    blog
description: 之前一直对CSS定位理解的糊里糊涂，这篇日志对这一概念做个总结，便于理解。
---

## 介绍

### CSS Position有四个属性：

1. relative
2. absolute
3. fixed
4. static（默认）

## 样例
    <div id="parent">
         <div id="sub1">sub1</div>
         <div id="sub2">sub2</div>
    </div>

sub1和sub2是同级关系，parent是它们的父级元素。

## 1. relative（相对定位）
相对定位指的是相对于这个元素**原位置**的定位，且会占住原来的位置。

所谓**原位置**指不设置relative属性时它的位置（既static属性时的位置）

relative偏移相对的是margin的左上侧。

例如对sub1设置relative属性后，会根据top，right，bottom，left属性偏移，而sub2的位置不变（sub1会占住原来的位置）

 ![relative_sub1](http://static.oschina.net/uploads/space/2015/0109/172652_1Ycs_730640.png)

再对sub2设置relative属性，它也会相对其原来的位置偏移（sub2位置还会被占着）

![relative_sub1](http://static.oschina.net/uploads/space/2015/0109/172944_cCzR_730640.png)

## 2. absolute（绝对定位）
绝对定位是根据其**最近进行定位**的父对象的 **padding 的左上角**进行定位，基本分为以下两种情况：

1. 例如对sub1设置absolute，如果sub1的父级元素（parent或者其父级元素）设置了absolute或relative，那么sub1就会相对这个父元素定位。
2. 如果父级元素都没有设置absolute或relative，那sub1相对body定位。

这时由于sub1的位置“腾出来了”，sub2就会跑到sub1的位置（也可以理解sub1浮起来了，dreamweaver中叫做层），它的文档流就会基于parent。

![absolute_sub1](http://static.oschina.net/uploads/space/2015/0109/175333_2Rzd_730640.png)

如果再对sub2设置absolute，那其也是相对parent的。

![absolute_sub2](http://static.oschina.net/uploads/space/2015/0109/175532_jDoT_730640.png)

## 3. fixed

fixed是特殊的absolute，即fixed总是以body为定位对象的，按照浏览器的窗口进行定位。

## 4. static（默认）

position的默认值，一般不设置position属性时，会按照正常的文档流进行排列。

----------------------------------------

参考：

http://www.cnblogs.com/Zigzag/archive/2009/02/19/position.html

http://www.w3school.com.cn/css/css_positioning.asp
