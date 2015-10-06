---
layout:      post
title:       Linux下恢复删除的文件
category:    blog
description: Linux有时候执行了 rm -rf 等操作误删了文件绝对是一件可怕的事情，好在有一些解决的办法可以临时救急。这时我们就要用到一款叫做extundelete的工具了。
---

Linux下执行 rm 并不会真正删除，而是将inode节点中的扇区删除，同时释放数据块。在数据块被系统重新分配前，这部分数据还是可以找回来的。

网上说在删除文件后要立即unmount这个分区，这样做其实是为了让外界不再写入，我们也可以设置为readonly模式代替。当然，如果为了不影响其它应用的运行，也可以不做unmount。

好的，现在就该神器extundelete上场了。以CentOS6.5为例

#### 依赖
    yum -y install e2fsprogs e2fsprogs-libs e2fsprogs-devel

#### 安装
    wget http://jaist.dl.sourceforge.net/project/extundelete/extundelete/0.2.4/extundelete-0.2.4.tar.bz2
    tar jxvf extundelete-0.2.4.tar.bz2
    cd extundelte-0.2.4
    ./configure
    make; make install
    
#### 查找要恢复的驱动器名
    df
    
    Filesystem             1K-blocks     Used   Available Use% Mounted on
    /dev/sda1                 495844    64150      406094  14% /boot
    
#### 运行恢复
默认恢复到当前目录下的RECOVERED_FILES目录中去

#### 恢复单个文件
    extundelete /dev/sdb1 --restore-file hosts
    
#### 恢复一个目录
    extundelete /dev/sdb1 --restore-files test/
    
#### 恢复整个分区
    extundelete /dev/sdb1 –-restore-all

这个工具貌似支持EXT4文件系统，经过实际测试，restore-all比较好用，在初次删除后可以很好的恢复文件及目录结构，但是如果我在相同位置新建了相同的文件名或者目录名，就会恢复失败（找不到了）。而恢复单独的文件或者目录则没有成功，如果有成功的可以告诉我。