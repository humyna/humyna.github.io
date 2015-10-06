---
layout:      post
title:       Servlet一次乱码排查后的总结
category:    blog
description: 项目中多多少少出现过乱码，都是通过手动转码绕过问题，而没有了解为什么乱码，这回遇到此问题后，好好的学习了一番，总结了一些乱码的原因。
---

## 由来
在写一个小小的表单提交功能的时候，出现了乱码，很奇怪request上来的参数全部是乱码，而从数据库查询出来的中文显示到页面正常，锁定肯定是request对象那里出了问题。后来经过排查，发现是我封装的框架中出了问题，总结为在setCharacterEncoding方法之前，调用了getParameter方法，导致字符集改变失败。没看过Tomcat实现Servlet的源码，貌似是一旦调用getParameter方法Request的参数就会全部被解析，从而再调用setCharacterEncoding就无效了。

## 原理解析
其实编码问题本质还是两点:

1. 浏览器在封装Http请求的时候的编码和服务器在解析Http请求编码不一致
2. 服务器返回数据的时候编码和浏览器解析不同。

那么我们就从这两点入手解析。

## 浏览器请求
在点击提交表单的那一刻，浏览器把表单内容封装成一个Http请求，数据通过`a=1&b=2`这样的形式直接请求服务器，表单值会被浏览器最一次urlencode，对于不同的请求方式编码不同：

### Get和Post请求
浏览器会读取页面的编码（页面编码会在Content-type头中体现），用此编码对表单值做urlencode，那么到服务器的编码方式就是你Content-Type里的编码。很多通过JS提交表单为了规避浏览器的urlencode带来的编码混淆，会对数据首先做一次urlencode，这样在服务器上做一次urldecode既可（因为js做完urlencode后内容为ASCII字符，所以这样的字符无论浏览器用什么编码解码出来都是一样的）

### AJAX请求
在Jquery中AJAX请求全部使用utf8编码封装请求，如果你的页面和项目用的非utf8编码，一定会出现乱码

### 浏览器地址栏直接输入带参数的地址
这种情况就比较复杂，不同的浏览器编码也不相同。Chrome之类的浏览器默认使用utf8编码（urlencode），而IE则使用GBK（死变态IE！！！）。

## 服务器端解码
对于服务器端我在此只讨论Servlet。

### Get请求
对于Get请求，有两种方式解码：

1. 在Servlet容器中设置，例如Tomcat设置URIEncoding="UTF-8"，就会对Get请求用utf8解码（貌似Tomcat7会报无效，具体解决请百度，反正我不同这种方法）
2. `String name = new String(request.getParameter("name").getBytes("iso-8859-1"),"GBK"));`第一个编码就是你Servlet容器（例如Tomcat）里设置的编码，默认iso-8859-1，第二个参数就是你浏览器使用的编码格式。如果你用表单提交，那这个编码就是页面的编码（Content-Type里的charset=XXX），如果你直接用浏览器地址栏里敲，恭喜你，你得判断userAgent来使用不同编码了。这也是我为啥不提倡第一种方式，因为它遇到浏览器直接敲出来的参数就非常不灵活。

至于为什么要使用getBytes("iso-8859-1")，是因为在你浏览器用某种编码后，Servlet容器自作多情给你用iso-8859-1解码了一下，如果你设置了URIEncoding="UTF-8"它就会用utf8给你解码，运气好你浏览器用的也是这种编码，那解出来就直接用了，所以在ISO-8859-1的情况下你得再“原路返回”到二进制，重新用正确的编码解码一下。

### Post请求和Ajax请求
Post请求就比较简单一点了，同样你可以使用Get请求中的方法2来解决，不过比较麻烦，这时候我们就可以使用Servlet里的方法request.setCharacterEncoding方法设置你的解码类型，例如你的页面编码是utf8，表单则urlencode成utf8了，那么你在调用getParameter方法之前（记住，一定要之前！！在第一次调用getParameter之前！）使用setCharacterEncoding方法。
Ajax请求同理。

## 响应请求
响应也是相同道理，这回轮到服务器做编码，浏览器做解码。只需要设置response.setCharacterEncoding，就会自动在响应头的Content-Type中加入charset=XXX，返回的内容就可以被正常解析啦~

我想我说的相对比较清楚了，网上很多解决乱码的帖子都只是讲你加上某句代码就会解决，这样是不科学的，一定也要知道原理，也要知道每句代码背后做了哪些工作。其实我们在操作HttpServlet对象的时候，本质上是对Http头的一些信息做修改。

如果有什么问题或者理解错误的地方，欢迎指正讨论。
