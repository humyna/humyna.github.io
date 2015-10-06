---
layout:      post
title:       将项目发布到Maven中央库
category:    blog
description: 前几天参考@黄勇 大神的博客http://my.oschina.net/huangyong/blog/226738成功将我的Hutool项目发布到了Maven的中央库，发表这篇博客以做纪念，顺便重新整理步骤并说明一下在发布过程中遇到的一些原博客中没有说明的问题。
---

前几天参考[@黄勇][1] 大神的博客 [http://my.oschina.net/huangyong/blog/226738](http://my.oschina.net/huangyong/blog/226738) 成功将我的Hutool项目发布到了Maven的中央库，发表这篇博客以做纪念，顺便重新整理步骤并说明一下在发布过程中遇到的一些原博客中没有说明的问题。

其实总结下来发布的过程是与[Sonatype][2]工作人员交互的过程，这个过程是在[Sonatype][3]的JIRA平台上完成的，过程如下：

1. 注册
2. 提交一个issue（提出一个发布申请），告诉工作人员我要创建一个构件。
3. 等待工作人员审批，会给你发邮件，在这个issue下给你comment说明通过或者哪里有问题。
4. 上传构件
5. 发布构建，并在哪个issue下告诉工作人员我发布了
6. 等待审核，如果通过会告诉你需要release一下并在issue上告诉工作人员我release了
7. 发布成功

这个过程比较漫长，慢在审核的过程，所以这个过程最好在晚上进行（我23点进行的，过了几分钟就回复我了），等待也是焦急而激动的，总体说来整个过程还是很有成就感滴~

---------------------------------------------------------------------------------------------

## 1. 注册帐户
注册地址是 [https://issues.sonatype.org/secure/Signup!default.jspa](https://issues.sonatype.org/secure/Signup!default.jspa)
![sonatype注册页面][4]

字段我就不细说了，一看就懂，不过Email非常重要，之后和工作人员的交流全靠这个邮件了。

## 2. 创建一个 Issue
地址是 [https://issues.sonatype.org/secure/CreateIssue.jspa?issuetype=21&pid=10134](https://issues.sonatype.org/secure/CreateIssue.jspa?issuetype=21&pid=10134)
![创建Issue][5]

这里需要特别说明的是Group Id，如果你是托管在Github或者Git@OSC 可以使用com.github.XXX或者net.oschina.XXX，我之前注册了个自己的域名com.xiaoleilu，所以在此填写这个group，剩下的可以依照实际情况填写，例如托管的地址等等。

## 3. 等待Issue审批
审批过程中出现过一些问题，第一次提交是因为我的Group Id 不符合规范（我用的looly.github），工作人员给我修正为com.github.looly了，然后告诉我可以进行下一步了，当时没理解，以为没通过，结果我又重新提交了一个Issue（就是com.xiaoleilu的Group Id），然后工作人员确认这个域名是否是我自己的，我回复是（在JIRA这个Issue下加个Comment），接着就通过了。
![通过审核][6]

截图为这个Issue的截图，当看到 `Configuration has been prepared, now you can:` 这句话的时候，说明你已经通过了Issue的审批，可以上传构建了。

## 4. 使用 GPG 生成密钥对
这个步骤是不是很突然？GPG是干嘛的？我开始也很迷茫，后来看官方文档说是签名构建用的，貌似为了保证你的构件不被第三方篡改，用于验证，神马原理呢？就是用这个东西在本地生成一个公钥和一个私钥，把公钥上传上去，当发布的时候用私钥签名一下（这个由maven-gpg-plugin搞定，不用我们自己来）。其实这个步骤也折腾了我好久，按照原博客的步骤，下载Gpg4win-Vanilla，我下载的2.1版本，系统是Windows8.1，并不能正常使用（在输入密码那段老是过不去），于是我转向Cygwin，步骤如下：

1. 安装
我使用apt-cyg安装的，具体不介绍了，如果不会就参考[Windows下安装Cygwin及包管理器apt-cyg](http://my.oschina.net/looly/blog/214857)，然后运行
    
        apt-cyg install gnupg

如果你是Linux，也可以用包管理工具安装`gnupg`这个包。

2. 生成公钥私钥
    
        gpg --gen-key

一路回车，然后输入用户名、邮箱等，最后重复两次输入Passphase（这个在发布的时候需要，在此牢记），如果你还是不清楚，看下这篇博客[GPG入门教程](http://www.ruanyifeng.com/blog/2013/07/gpg.html)

3. 查看公钥私钥
    
        gpg --list-keys
        /home/loolly/.gnupg/pubring.gpg
        -------------------------------
        pub   2048R/C990D076 2014-05-28
        uid                  Looly <loolly@gmail.com>
        sub   2048R/48F6CC72 2014-05-28

其中 `C990D076` 是需要传到服务器的

4. 发布公钥
        
        gpg --keyserver hkp://pool.sks-keyservers.net --send-keys C990D076

执行这一步在Cygwin下可能会报错

    gpg: 警告：配置文件‘/home/loolly/.gnupg/gpg.conf’权限不安全
    gpg: 警告：配置文件‘/home/loolly/.gnupg/gpg.conf’的关闭目录权限不安全

原因是.gnupg的权限太大，这个目录必须只有当前用户本人有写权限，所以执行

    chmod 700 .gnupg

我开始的时候修改权限失败了，原因是这个目录的组是`None`，所以执行

    chown loolly:Users .gnupg

给定了一个组名，这样chmod命令就可以正常执行了。

5. 查看是否成功

        gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys C990D076

好的，我们的密钥对已经准备好了，至于如何使用，请看接下来的步骤。

## 5. 修改setting.xml
`setting.xml`这个文件存在于两个地方，一个是用户的Maven配置文件，在`${user}/.m2/setting.xml`，`${user}`表示你的用户目录，这个文件只对当前用户有效，另一个在你Maven安装目录的conf/setting.xml文件，这个是全局的配置文件，考虑到我的电脑只有自己用，所以只用全局配置文件添加内容如下：
    
    <settings>
        ...
        <servers>
            <server>
                <id>oss</id>
                <username>用户名</username>
                <password>密码</password>
            </server>
        </servers>
        ...
    </settings>

这里的用户名密码就是我们在第一部注册的时候的用户名和密码。

## 6. 修改pom.xml文件
pom.xml在Maven中央库的审核比较严格，必须有固定的一些字段，还有发布的构件必须包含字节码jar、源码jar、文档jar，这些都可以通过maven插件搞定，具体这个文件我就不贴了，请查看我的pom做参考：
[https://github.com/looly/hutool/blob/master/pom.xml](https://github.com/looly/hutool/blob/master/pom.xml)
其中必须字段是：

- name
- description
- url
- licenses
- developers
- scm

这里我按照原博客的方法，把发布限制在了一个profile里（Profile理解为一个构建行为的配置，每种行为对应一个profile，例如线上、测试的某些配置不同，就可以分为不同的profile执行，如果你还不明白就自行百度吧~），发布需要的source插件、javadoc插件、gpg插件都在这个profile里，这样只有在发布的时候才会生成源码包、文档API包和做gpg签名。`distributionManagement`则是定义了`release`和`snapshot`发布的地址，这个在Issue通过审核后工作人员会给你，还有就是`snapshotRepository` 与 `repository` 中的 `id` 一定要与 `setting.xml` 中 `server` 的 `id` 保持一致。

## 7. 发布到OSS
这一步主要是生成相应的一些jar包和签名文件，并上传到OSS的服务器，命令也比较简单

     mvn clean deploy -P release -Dgpg.passphrase=你的Passphase

这一步特别说明下，按照原博主的说法，执行`mvn clean deploy -P release`会自动弹出一个对话框，我这里没有弹出来……而且报签名异常，后来百度之，得加上`-Dgpg.passphrase=你的Passphase`这个参数，用你自己的Passphase，就可以成功了（我严重怀疑Cygwin的问题……）还有-P参数表示使用的profile名，就是profile下<id>release</id>这个标签的内容。

## 8. 发布构建
进入[https://oss.sonatype.org](https://oss.sonatype.org)并登陆，会在左侧有个`staging Repositories`点击进入，在右侧面板找到你的构件，状态应该是open，你要将其置为closed，点击上方的`close`按钮即可（这个按钮我找了10分钟我会明说么::>_<:: ）。
![关闭按钮][7]

接下来系统会自动验证有效性，如果你的Group Id和pom.xml没有错误，状态会自动变成closed，如果有问题，会在下面提示你那里有问题，加入有问题你可以点击drop按钮删掉这个构件，修改后重新执行步骤7。

接下来你需要点击`release`按钮发布你的构件。

## 9. 在Issue中通知工作人员
然后回到JIRA中你的Issue，写个comment，我写的是`Component has been successfully issued.`告诉工作人员我发布完成了，等待他们审核。审核通过后我们就可以在中央库搜索到我们的构件了！搜索的地址是：
    http://search.maven.org/

![搜索hutool][8]    

## 10. 总结
当可以搜索出来自己的构件的那一刻实在抑制不住心中的激动，各种朋友圈去发截图炫耀（虽然朋友圈里的同学都看不懂我截图这玩意儿是干啥的……），有种公司在美国上市的赶脚有木有！没办法，屌丝只有这些追求，让自己的代码被更多的人使用，会感到非常有成就感。

PS.说下发布中的一些细节，在执行第8步的时候，我只是简单的close，没有release，结果工作人员发来邮件说"Almost done! Looks like you still need to release the staging repository"，然后我才点击release，再加了个comment才发布成功。

![多一个步骤][9]

令人欣慰的是总算完成了，感谢 [@黄勇][1]。


## 参考博客
[http://my.oschina.net/huangyong/blog/226738](http://my.oschina.net/huangyong/blog/226738)



  [1]: http://my.oschina.net/huangyong
  [2]: http://www.sonatype.org/
  [3]: http://www.sonatype.org/
  [4]: http://static.oschina.net/uploads/space/2014/0529/155428_Pk4Z_730640.png
  [5]: http://static.oschina.net/uploads/space/2014/0529/160502_me1z_730640.png
  [6]: http://static.oschina.net/uploads/space/2014/0529/161913_TRrd_730640.png
  [7]: http://static.oschina.net/uploads/space/2014/0529/173458_UDIH_730640.png
  [8]: http://static.oschina.net/uploads/space/2014/0529/174502_1WqL_730640.png
  [9]: http://static.oschina.net/uploads/space/2014/0529/175121_e6Ab_730640.png