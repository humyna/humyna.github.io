---
layout: post
title: "[最佳实践]Windows7下搭建写博环境"
description: ""
category: 
tags: [jekyll]
---
{% include JB/setup %}


##软件下载
- Windows 7 64bit
- [RubyInstaller 1.9.3](http://rubyforge.org/frs/download.php/76054/rubyinstaller-1.9.3-p194.exe)
- [DevKit-DevKit-tdm-32-4.5.2-20111229-1559-sfx.exe](https://github.com/oneclick/rubyinstaller/downloads/)
- Jekyll 1.4.2
- Rdiscount
- Github客户端
- Gvim7.3

##安装配置
- 1.下载RubyInstaller并安装，然后在命令行终端下输入gem update --system来升级gem，然后分别输入ruby -v和gem -v检验安装版本
- 2.下载最新的DevKit(DevKit是windows平台下编译和使用本地C/C++扩展包的工具。它就是用来模拟Linux平台下的make,gcc,sh来进行编译。这个方法目前仅支持通过RubyInstaller安装的Ruby)并双击运行解压到C:\DevKit。然后打开终端cmd，输入下列命令进行安装：
    cd C:\DevKit
    ruby dk.rb init
    ruby dk.rb install
- 3.完成上面的准备就可以安装Jekyll了,因为Jekyll是用Ruby编写的,最好的安装方式是通过RubyGems(gem):
    gem install Jekyll --version "=1.4.2"
- 4.安装Rdiscount，这个用来解析Markdown标记的包，使用如下命令：
    gem install rdiscount
- 5.安装Github on windows，安装完桌面有Github和git shell两个快捷方式
- 6.安装Gvim7.3，并配置markdown插件

##写作环境搭建
    1.在github.com注册账号
    2.创建名为humyna.github.io的仓库
    3.Clone in Desktop
    4.打开git shell,使用如下命令clone Jekyll-Bootstrap到本地 
    git clone https://github.com/plusjade/jekyll-bootstrap.git Jekyll-Bootstrap
    5.将Jekyll-Bootstrap文件夹中除.git外的所有文件copy到humyna.github.io文件夹中
    6.修改_config.yml中相关的配置，设置博客主题
    7.在git shell中，cd到humyna.github.io文件夹下，执行命令jekyll serve --watch(不加--watch则不会检测文件夹内的变化，即修改后需要重新启动jekyll),即可以通过http://localhost:4000访问本地的博客环境
    8.执行rake post title="hello world"即可在_posts文件夹下生成一个md文件，使用vim编辑进行博客创作，保存后可以在浏览器中看到效果。
    9.完成写作后，使用github的客户端完成提交，这样就能将完成的博文发布到网上(humyna.github.io)

##注意事项
    1.Ruby默认安装后在用户环境变量中已添加（path=C:\Ruby193\bin）无需再配置
    2.Ruby和DevKit解压路径不能有空格
    3.Jekyll应该安装1.4.2版本(使用jekyll -v检查是否安装成功)并配置用户环境变量解决中文编码问题LC_ALL=en_US.UTF-8和Lang=en_US.UTF-8
    如果此时使用gem 安装软件会报错：
    ERROR:  While executing gem ... (ArgumentError)
    invalid byte sequence in UTF-8
    需要先删除这两个环境变量，等完装完再加上。
    4.Gvim需要设置默认编码为utf-8,不然打开含有中文文件会有乱码
    5.可以绑定自己的域名，在根目录下闯将CNAME文件并将域名加进去，同时配置域名映射即可。
