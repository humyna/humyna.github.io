---
layout: post
title: "如何彻底删除已经提交至github上的一次提交(commit)"
description: ""
category: blog
tags: [git,Github]
---

昨天不小心提交个人代码至github时，在提交记录中带上了公司的邮箱信息。原因是github desktop使用本地的git配置信息，在提交前忘了修改。

公司安全同学为了防止公司代码信息泄露，会定期扫描github，我相信邮箱后缀肯定在关键词列表中。为了避免不必要的麻烦，我决定删除这条记录。

一般已经push的代码回滚会使用git revert命令，但是这样还会保留原提交记录，不满足我的需求。
而git reset --hard虽然可以回滚源码和提交记录，但是只适用于本地代码仓库。

所以为了删除这条提交记录唯一的方法只能是： **先删除github上的仓库https://github.com/xxx/test,然后新建一个空项目test，接着把本地代码回滚至上一版本，最后再重新修改git配置提交代码，并push到github上。**

### Step1:删除github上的仓库test。直接登录网站操作即可。

### Step2:本地代码回滚至上一版本
1. 先备份代码
2. git log确定上一提交的commit id
3. 执行命令git reset --hard [commit id]回滚至上一次提交
4. 将备份代码覆盖回滚代码文件，并提交(务必注意修改git config中user信息)

### Step3：提交至github
1. 新建一个Github仓库test
2. 通过命令行cd进本地仓库；
3. 使用以下语句将本地代码及记录push到远程仓库：

> git remote add origin1 https://github.com/xxx/test
> 
> git push -u origin1 master

参考：https://www.cnblogs.com/qq952693358/p/7806152.html
