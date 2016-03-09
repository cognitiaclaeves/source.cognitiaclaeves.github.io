---
layout: post
title:  "Blogging with VDJG: Part 1 - Vagrant, Docker & Jekyll"
date:   2016-03-03 08:08:00
categories: light
tags:
 - vagrant
 - docker
 - github
 - jekyll
 - blogging
theme: light
comments: True
---

_This blog is set up so that I can write new blog posts in text files, without internet, and even see what they look like locally, before logging in, pushing changes into github's source repository, and then pushing site changes that publish the content automatically. Note there is no formatting in that list. I go from markdown files to static HTML files, letting containerized code do the hard work inbetween._

_I set up this process after trying out a blogging process that was demonstrated by Boyd at a devops / docker / cloud meetup, which he later published on [his blog](http://behemphi.github.io/github-pages/docker/2015/12/02/github-pages-with-docker.html)_

_Blogging with VDJG covers the process that I set up to make this happen. In the first part, I cover everything short of publishing it live. In the second part, I cover publishing it live, and in the third part, I cover what it looks like when I create a new blog entry._

I like to show all my work.  But if you just want to get a blog up in a hurry with this method, I made a short cut!

( This post is currently in progress; there will be clean-up later. )

{% highlight Bash Session %}
~/personal
➔ mkdir phusion-jekyll; cd phusion-jekyll

~/personal/phusion-jekyll
➔ git clone https://github.com/phusion/baseimage-docker.git
Cloning into 'baseimage-docker'...
remote: Counting objects: 1193, done.
remote: Total 1193 (delta 0), reused 0 (delta 0), pack-reused 1193
Receiving objects: 100% (1193/1193), 1.48 MiB | 1.57 MiB/s, done.
Resolving deltas: 100% (699/699), done.
Checking connectivity... done.

~/personal/phusion-jekyll
➔ cd baseimage-docker

personal/phusion-jekyll/baseimage-docker on master
➔ ls
CONTRIBUTING.md Makefile README_zh_tw.md install-tools.sh
Changelog.md README.md Vagrantfile test
LICENSE.txt README_ZH_cn_.md image tools

personal/phusion-jekyll/baseimage-docker on master
➔ vagrant up

{% endhighlight %}


I want a folder in the VM to directly reference my work folder (future github) folder, so I add this line:


```config.vm.synced_folder "data", "/home/vagrant/data"```

{% highlight Bash Session %}
➔ tail -6 Vagrantfile
    config.vm.provision :shell, :inline => $script
  end

  config.vm.synced_folder "data", "/home/vagrant/data"

end
{% endhighlight %}

Then I create the data folder and restart the vagrant box:

{% highlight Bash Session %}
personal/phusion-jekyll/baseimage-docker on master [!]
➔ mkdir data; vagrant halt; vagrant up

==> default: Attempting graceful shutdown of VM...

Bringing machine 'default' up with 'virtualbox' provider...
...
{% endhighlight %}

My new folder is at the top of this list:

{% highlight Bash Session %}
==> default: Mounting shared folders...
default: /home/vagrant/data => /Users/jnorment/personal/phusion-jekyll/baseimage-docker/data
default: /vagrant/baseimage-docker => /Users/jnorment/personal/phusion-jekyll/baseimage-docker
default: /vagrant => /Users/jnorment/personal/phusion-jekyll/baseimage-docker
{% endhighlight %}

Next, I run the following in the vagrant session, to build the initial files:

{% highlight Bash Session %}
cd data
docker run \
  --interactive \
  --label=jekyll \
  --publish 4000:4000 \
  --rm \ 
  --tty \
  --volume=$(pwd):/srv/jekyll 
  jekyll/jekyll:pages jekyll new . --force
{% endhighlight %}

( TODO: Docker warning here? )

( TODO: Screen-shot )

( TODO: What a clean install looks like )

.. and create this file (phusion-jekyll/baseimage-docker/exec-jekyll.sh), to run the jekyll container:

{% highlight Bash Session %}
cd /home/vagrant/data
docker stop jekyll_runtime 2> /dev/null
docker rm -v jekyll_runtime 2> /dev/null
docker run \
    --env FORCE_POLLING=true \
    --env JEKYLL_ENV=development \
    --env VERBOSE=true \
    --label=jekyll \
    --name=jekyll_runtime \
    --publish "0.0.0.0:4000:80" \
    --rm \
    --volume="$(pwd):/srv/jekyll" \
    jekyll/jekyll:pages jekyll build --watch
{% endhighlight %}

... and make the file executable:

```chmod +x exec-jekyll.sh```

To make the webserver in the container accessible, and to execute my new script, I add these lines to the Vagrantfile that I edited before:

{% highlight Bash Session %}
...

  config.vm.synced_folder "data", "/home/vagrant/data"
  config.vm.network :forwarded_port, guest: 4000, host: 4000
  config.vm.provision "shell", path: "exec-jekyll.sh"
end
{% endhighlight %}

```vagrant provision``` runs the script:

{% highlight Bash Session %}
personal/phusion-jekyll/baseimage-docker on master [!]
➔ vagrant provision
==> default: Running provisioner: shell...
        default: Running: /var/folders/9s/320v29913qs9j6kzxnqv7smclw01rh/T/vagrant-shell201
60302-97040-1s32frt.sh
==> default: stdin: is not a tty
==> default: jekyll_runtime
==> default: Github does not allow user dependencies.
==> default: Configuration file: /srv/jekyll/_config.yml
==> default: Source: /srv/jekyll
==> default: Destination: /srv/jekyll/_site
==> default: Generating...
==> default: done.
==> default: Auto-regeneration: enabled for '/srv/jekyll'
{% endhighlight %}

Now, I can browse to: http://localhost:4000, and click on the "Welcome to Jekyll" link.

This link was generated from data/_posts/[date]-welcome-to-jekyll.markdown

I switch to another terminal and edit the file locally:

{% highlight YAML %}
---
layout: post
title: "Welcome to Jekyll!"
date: ... 
categories: jekyll update
---
You’ll find this post in your `_posts` directory. ...

{% endhighlight %}

I change the above to:

{% highlight YAML %}
---
layout: post
title: "Welcome to Jekyll!"
date: ... 
categories: jekyll update
---
You’ll find this SAMPLE post in your `_posts` directory. ...

{% endhighlight %}

and when I save the file, I see activity in the previous terminal session:

{% highlight Bash Session %}
...
==> default: done.
==> default: Auto-regeneration: enabled for '/srv/jekyll'
==> default: Regenerating: 1 file(s) changed at 2016-03-02 23:47:21
{% endhighlight %}

Finally, when I refresh the localhost:4000, it's updated! 

( TODO: Image here )

When I'm finished updating my site, I take the vagrant box down:

{% highlight Bash Session %}
==> default:       Regenerating: 1 file(s) changed at 2016-03-03 15:00:13
==> default: ...done in 0.860794742 seconds.
^C==> default: Waiting for cleanup before exiting...
^C==> default: Exiting immediately, without cleanup!

personal/phusion-jekyll/baseimage-docker on master [!?]
➔ vagrant halt
==> default: Attempting graceful shutdown of VM...

personal/phusion-jekyll/baseimage-docker on master [!?]
{% endhighlight %}

In this way, I take advantage of containers to run a Jekyll process that converts markdown files to a static web site, which I can see from your localhost's ( workstation ) browser. Then, when everything looks exactly as I want it, I publish the site on github pages.

I actually do a little more work to get the switchable theme in my static website. This work amounts to mangling the generated files with the use of a bash and a python script.

For the next blog in this series, I'll post how to easily work github pages into this, and then my steps to create a new blog entry, after all the setup is done.
