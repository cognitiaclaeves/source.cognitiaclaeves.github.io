---
layout: post
title:  "Blogging with VDJG: Part 1.5 - Vagrant, Docker & Jekyll - Shortcut!"
date:   2016-03-08 23:00:00
categories: light
tags:
 - blogging-w-vdjg
 - vagrant
 - docker
 - github
 - jekyll
 - blogging
theme: light
comments: True
---

I just finished going through all of the steps of how I created the vagrant-docker-jekyll combo that I use to blog with.

... And then I realized ... the whole point of vagrant and docker is to be able to create an environment that can be replicated ... so it should theoretically be possible for me to set up the entire environment and provide a few short lines to get the whole thing working, right?  Right.

{% highlight Bash Session %}

git clone https://github.com/phusion/baseimage-docker.git
cd baseimage-docker
mkdir data
curl https://raw.githubusercontent.com/cognitiaclaeves/source.cognitiaclaeves.github.io/develop/source-files/Vagrantfile > Vagrantfile
curl https://raw.githubusercontent.com/cognitiaclaeves/source.cognitiaclaeves.github.io/develop/source-files/exec-jekyll.sh > exec-jekyll.sh
chmod +x exec-jekyll.sh
vagrant up

{% endhighlight %}


