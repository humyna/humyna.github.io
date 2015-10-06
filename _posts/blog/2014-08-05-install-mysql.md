---
layout:      post
title:       linux下MySQL 5.6源码安装
category:    blog
description: 发现编译安装的灵活性最大，根据网上的帖子参考，总结以下编译安装过程。
---

## 1、下载：当前mysql版本到了5.6.20
[http://dev.mysql.com/downloads/mysql](http://dev.mysql.com/downloads/mysql)

选择`Source Code`

## 2、必要软件包
    yum -y install  gcc gcc-c++ gcc-g77 autoconf automake zlib* fiex* libxml* ncurses-devel libmcrypt* libtool-ltdl-devel* make cmake

## 3、编译安装

### 添加用户
    groupadd mysql
    useradd -r -g mysql mysql

### 编译安装
    tar -zxvf mysql-5.6.20.tar.gz
    cd mysql-5.6.20

    #默认情况下是安装在/usr/local/mysql
    cmake .
    make && make install

### 编译参数
    cmake .
    -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
    -DMYSQL_DATADIR=/usr/local/mysql/data \
    -DSYSCONFDIR=/etc \
    -DWITH_MYISAM_STORAGE_ENGINE=1 \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_MEMORY_STORAGE_ENGINE=1 \
    -DWITH_READLINE=1 \
    -DMYSQL_UNIX_ADDR=/var/lib/mysql/mysql.sock \
    -DMYSQL_TCP_PORT=3306 \
    -DENABLED_LOCAL_INFILE=1 \
    -DWITH_PARTITION_STORAGE_ENGINE=1 \
    -DEXTRA_CHARSETS=all \
    -DDEFAULT_CHARSET=utf8 \
    -DDEFAULT_COLLATION=utf8_general_ci

编译的参数可以参考[http://dev.mysql.com/doc/refman/5.6/en/source-configuration-options.html](http://dev.mysql.com/doc/refman/5.6/en/source-configuration-options.html)

### 改变目录所有者
    chown -R mysql.mysql /usr/local/mysql

## 4、初始化数据库
    cd /usr/local/mysql/scripts
    ./mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data

## 5、注册为服务
    cd /usr/local/mysql/support-files

    #注册服务
    cp mysql.server /etc/rc.d/init.d/mysql

    #使用默认配置文件
    cp my-default.cnf /etc/my.cnf

    #让chkconfig管理mysql服务
    chkconfig --add mysql

    #开机启动
    chkconfig mysql on

## 6、启动MySQL服务
    service mysql start

## 7、改变编码，防止乱码
    SHOW VARIABLES LIKE 'character%'

修改mysql的my.cnf文件

    [client]
    default-character-set=utf8

    [mysqld]
    character-set-server=utf8

    [mysql]
    default-character-set=utf8

## 8、将mysql的bin加入到path中
    cd ~
    #我把path添加到当前用户目录的bashrc中，如果需要全局设定，请修改`/etc/profile`
    vi .bashrc

    #加入以下内容
    PATH=/usr/local/mysql/bin:$PATH
    export PATH

## 9、配置用户密码和远程访问权限
    mysql -uroot  
    SET PASSWORD = PASSWORD('123456');

    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;

-----------------------------------------------------------

参考：
http://blog.163.com/liyinhui20080527@126/blog/static/815232582013885310900/
http://www.cnblogs.com/xiongpq/p/3384681.html