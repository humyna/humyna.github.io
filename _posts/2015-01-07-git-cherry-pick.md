---
layout: post
title: "git cherry-pick使用场景"
description: ""
category: 
tags: [git, cherry-pick]
---
{% include JB/setup %}

- git cherry-pick用法 


> git cherry-pick commit_id1 commit_id2


- 功能说明 

	"复制"一个或多个已提交节点并在当前分支做一次完全一样的新提交，这个新的提交的哈希值和原来的不同，但标识名一样

- 功能示意图

![](http://i.imgur.com/YWowgd7.png)

- 使用场景

我们在dev1上进行bug修复，并作了一次提交，然后被告知，“抱歉，今天需要紧急上线dev1分支代码，你这个bug没有时间测试，需要将这次提交移到dev2分支上进行测试。“ 这时候就是cherry-pick显神威的地方了。
可以进行如下操作:

1.切换到dev2分支，注意需要确保dev2分支干净

> git checkout dev2

2.然后执行cherry-pick命令

> git cherry-pick commit_id

3.对于dev1分支的提交，切换到执行revert命令,撤销此次提交

>  git checkout dev1	

>  git revert <commit id>

(完)
本文使用MarkdownPad 2编辑完成

