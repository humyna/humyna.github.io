---
layout:      post
title:       CentOS6下安装Python
category:    blog
description: 由于工作需求，很多系统是CentOS6,自带Python2.6，此篇文章我们将介绍如何升级Python为2.7
---

## 下载解压
```sh
wget https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz
tar -zxvf Python-2.7.10.tgz
cd Python-2.7.10

./confiure
make && make install
```

## 建立软连接

```sh
ln -s /usr/local/bin/python2.7 /usr/bin/python
#检查版本
python -V
```

## 修复yum兼容问题

```sh
vim /usr/bin/yum
```

将文件头部的

```python
#!/usr/bin/python
```

改成

```python
#!/usr/bin/python2.6
```