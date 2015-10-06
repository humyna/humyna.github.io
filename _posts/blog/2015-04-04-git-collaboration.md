---
layout:      post
title:       Git常用命令和Github协同流程
category:    blog
description: 这两天翻译Elasticsearch权威指南有很多小伙伴加入，非常开心。但是Pull Request过来的内容我没法Merge，于是写一篇协同流程。
---

## 符号约定
* `<xxx>` 自定义内容
* `[xxx]` 可选内容
* `[<xxx>]` 自定义可选内容

## 初始设置
1. `git config --global user.name "<用户名>"` 设置用户名
2. `git config --global user.email "<电子邮件>"` 设置电子邮件

## 命令

### 本地操作
1. `git add [-i]` 保存更新，`-i`为逐个确认。
2. `git status` 检查更新。
3. `git commit [-a] -m "<更新说明>"` 提交更新，`-a`为包含内容修改和增删， `-m`为说明信息，也可以使用 `-am`。

### 远端操作
1. `git clone <git地址>` 克隆到本地。
2. `git fetch` 远端抓取。
3. `git merge` 与本地当前分枝合并。
4. `git pull [<远端别名>] [<远端branch>]` 抓取并合并,相当于第2、3步
5. `git push [-f] [<远端别名>] [<远端branch>]` 推送到远端，`-f`为强制覆盖
6. `git remote add <别名> <git地址>` 设置远端别名
7. `git remote [-v]` 列出远端，`-v`为详细信息
8. `git remote show <远端别名>` 查看远端信息
9. `git remote rename <远端别名> <新远端别名>` 重命名远端
10. `git remote rm <远端别名>` 删除远端
11. `git remote update [<远端别名>]` 更新分枝列表

### 分枝相关
1. `git branch [-r] [-a]` 列出分枝，`-r`远端 ,`-a`全部
2. `git branch <分枝名>` 新建分枝
3. `git checkout <分枝名>` 切换到分枝
4. `git checkout -b <本地branch> [-t <远端别名>/<远端分枝>]` `-b`新建本地分枝并切换到分枝, `-t`绑定远端分枝

## 协同流程
1. 首先fork远程项目
2. 把fork过去的项目也就是你的项目clone到你的本地
3. 运行 `git remote add <远端别名> <别人的远端分枝>` 把别人的库添加为远端库
4. 运行 `git pull <远端别名> <远端分枝>` 拉取并合并到本地
5. 编辑内容
6. commit后push到**自己**的库（`git push <自己的远端别名> <自己的远端分枝>`）
7. 登陆Github在你首页可以看到一个 `pull request` 按钮，点击它，填写一些说明信息，然后提交即可。

1~3是初始化操作，执行一次即可。在本地编辑内容前必须执行第4步同步别人的远端库（这样避免冲突），然后执行5~7既可。

--------------------------------------------------------
参考：[http://neverno.me/hello-world/git-commands-github.html](http://neverno.me/hello-world/git-commands-github.html)