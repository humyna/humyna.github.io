---
layout: post
title: "git 跨库push代码(A100技术笔记第1天)"
description: ""
category: 
tags: [git,push]
---
{% include JB/setup %}


###场景

项目代码从团队自己搭建的git库(A库)切换到基于gitlab的git库(B库),因此我在本地开发的代码需要提交到新库(B库)。

###具体操作步骤

 - 本地仓库与远程仓库建立连接

>humyna@god:~/gitpushtest$ git remote add gitlab_repo git@11.11.11.11:gittest/mygit.git

 - 列出已经存在的远程分支

>humyna@god:~/gitpushtest$ git remote -v

	git_repo git@10.10.10.10:gittest/mygit.git (fetch)
	git_repo git@10.10.10.10:gittest/mygit.git (push)
	gitlab_repo git@11.11.11.11:gittest/mygit.git (fetch)
	gitlab_repo git@11.11.11.11:gittest/mygit.git (push)

 - 检查当前状态

>humyna@god:~/gitpushtest$ git status

	位于分支 dev1
	您的分支与上游分支 'git_repo/dev1' 一致。

	无文件要提交，干净的工作区

- 将本地的提交push到gitlab的dev1分支上(注意：此处由于gitlab_repo上dev1分支的代码是基于本地上一个提交的代码，故不存在merge等操作，否则需要fetch-->merge-->push)

>humyna@god:~/gitpushtest$ git push gitlab_repo dev1

	Counting objects: 80, done.
	Delta compression using up to 4 threads.
	Compressing objects: 100% (30/30), done.
	Writing objects: 100% (46/46), 8.24 KiB | 0 bytes/s, done.
	Total 46 (delta 17), reused 0 (delta 0)
	To git@11.11.11.11:gittest/mygit.git
   		99a59be..6b0cf26  dev1-> dev1

**注意**

1.由于公司项目设计机密，就不发gitlab的提交成功截图了，另地址和显示均作了替换处理

2.git_repo只是git@10.10.10.10:gittest/mygit.git的别名而已，只要保证多个远程库别名不重复即可

3.以上思路也可用于同时push代码到多个远程库中，如下就是将代码同时push到git_repo和gitlab_repo的dev1分支

	git push git_repo dev1
	git push gitlab_repo dev1


----EOF----