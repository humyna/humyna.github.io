---
layout:      post
title:       常用的Linux、Mysql和Java命令
category:    blog
description: 这篇博客主要是我平时使用到的一些命令，在此做标记用于速查
---

## Linux相关

### 上传下载（ssh客户端）
    rz -y #上传并覆盖原有文件
    sz    #发送到本地
    
### 远程拷贝
    scp filePath 192.168.1.1:/home/me

### 快速查看文本格式文件
    less filePath
    
### 使用SSH公钥
    ssh-keygen -t rsa                                          #生成公钥
    scp ~/.ssh/id_rsa.pub 192.168.1.1:~/.ssh/authorized_keys   #加入公钥信任
    #或者
    ssh-copy-id -i ~/.ssh/id_rsa.pub  192.168.1.2              #加入公钥信任
** 此处需要注意，当前用户目录和.ssh目录权限必须是700或755（貌似非本人不给写权限既可），authorized_keys权限必须是600（644貌似也可以） **

### 根据IP反查DNS
    host IP     #Linux
    nslookup IP #Windows

### tar打包、解包    
    tar zcvf XXX.tar.gz 文件或目录            #打包
    tar zxvf XXX.tar.gz                       #解包
    
    tar -jcvf XXX.tar.bz2 被打包的文件或目录 #打包
    tar -jxvf XXX.tar.bz2 -C 解压到的目录    #解包

### 查询当前运行的名称为tomcat的进程
    ps -ef|grep tomcat

### 查找文件包含某些字符
    find . -name *.xml|xargs grep '字符' #查找所有xml内容中包含特定字符的文件
    ls | xargs grep '关键字'             #查找当前目录下所有文件内容中包含特定字符的文件
    
### 磁盘内存信息
    free -m     #查看内存信息
    du -sh 目录 #查看某个目录文件和文件大小
    df -h       #磁盘总的使用情况
    
### 行切分
    awk -F '分隔符' '{print $n}' #$n表示切分后的第几部分，从1开始计数
    #按照某个字符做split -d 后跟分隔符，默认空格，-f 后跟取第几部分，从0计数
    cut -d'分隔符' -f2
    
### 排序和去重
    sort     #排序
    sort -n  #反序
    sort -u  #去重
    sort -rn #依照数值大小反序
    
    uniq -c #统计重复行数
    
    sort file.name | uniq -c #显示重复行的计数，原理是先排序，再计算重复数
    cat 一堆文件 | awk '{ if (!seen[$0]++) { print $0; } }' #大文本去重
    
### 转换编码
    iconv -f gb2312 -t utf-8 -c my_database.sql > new.sql #-c表示忽略不能转换的

### 配置文件立即生效
    source 配置文件名
    
### 分许标准nginx日志，统计指定规则行的行数（多用于PV统计）
    egrep -o 同 grep -ef 使用完整的正则规则, -o表示只输出匹配的部分
    egrep -o 'GET /[0-9]{6}/index.html' ${nginx_log_file} | cut -d'/' -f2 | sort | uniq -c | sort -rn
    
### 通过inode节点找到文件删除
    ls -i
    find -inum XXX  |xargs -I {} rm {}

-------------------------------------------------------------------------------------------------------------
## Java相关

### Jar包
    jar -cvfM0 name.war ./ #把当前目录下的所有文件打包成name.war
    jar -xvf game.war      #解压到当前目录

### Java命令
    java -cp .:./lib/* com.company.xxx.xxx #运行Java命令行程序
    jstat -gcutil -h10 <pid> 3s 1000 #监测Java垃圾回收情况

### 启动Tomcat并显示日志
    bin/startup.sh ; tail -f logs/catalina.out

### Maven相关
    #快速新建
    mvn archetype:generate -DgroupId=com.mycompany.baseUtils -DartifactId=baseUtils -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
    
    #下载源码
    mvn -DdownloadSources=true -DdownloadJavadocs=true -DoutputDirectory=target/eclipse-classes eclipse:eclipse
    
    #创建Web项目
    mvn archetype:create -DgroupId=com.mycompany.app -DartifactId=my-webapp -DarchetypeArtifactId=maven-archetype-webapp
    
    #加入POM
    mvn install:install-file  -DgroupId=com.mycompany -DartifactId=app -Dversion=1.1 -Dfile=./target/app-1.1-release.jar -Dpackaging=jar -DgeneratePom=true

--------------------------------------------------------------------------------------------------------------
## MySQL数据库

### 备份
    mysqldump dbName > dbName.sql                                      #备份
    mysqldump -h192.168.1.1 -uusername -ppassword dbName > dbName.sql  #备份远程

### 授权
    CREATE USER 'username'@'host' IDENTIFIED BY 'password';           #创建用户
    GRANT privileges ON databasename.tablename TO 'username'@'host'   #授权用户
    REVOKE all ON *.* FROM 'username'@'host';                         #取消授权
    
    #允许任何IP地址（上面的 % ）的电脑 用root帐户和密码（1234）来访问这个MySQL
    grant all on *.* to root@'%' identified by '1234' with grant option; 