---
layout: post
title:  "Blogging with VDJG: Part 2 - Git & Github"
date:   2016-03-03 18:08:00
categories: light 
tags:
 - draft
 - blogging-w-vdjg
 - vagrant
 - docker
 - github
 - jekyll
 - blogging
theme: light
comments: True
---

> This blog is set up to be able to add and view new entries offline ( as text files ), and then push changes into a source repository to trigger live site updates ( as website files ). I use a Jekyll Docker container running in Vagrant to take the site from text files to HTML.
> 
> My process was inspired by a blogging process demonstrated by Boyd Boyd Hemphill at a devops / docker / cloud meetup, which he published on [his blog](http://behemphi.github.io/github-pages/docker/2015/12/02/github-pages-with-docker.html)
> 
> This series covers the process I set up, in detail. In the first part, I cover everything short of publishing it live. In the second part, I cover publishing it live, and in the third part, I cover what it looks like when I create a new blog entry.


( This post is currently in progress; there will be clean-up later. )

#### What is git / Github / Github Pages?

Git is a source code repository designed to store and track changes in text files. You do most of your work with git locally, and then push the changes made to your local repo into a remote repository. In this case, the remote repository is Github. Github then created Github Pages, where the same revision control can be applied to a website on servers managed by Github.


#### Why Publish on GitHub Pages?


- It's free
- I don't have to maintain the server
- There is source control ( backup ) built right into the process

( The one thing to really watch out for is the moment you backup up your changes, they go live. )

#### How is it done?

I started by [creating a new page for my blog](https://pages.github.com/).

After following the link above, I integrated the git repo in the `data` directory I set up in the last post. 

{% highlight Bash Session %}

phusion-jekyll/temp/baseimage-docker on master
➔ pwd                                                                                                                                                                               
/Users/jnorment/personal/phusion-jekyll/temp/baseimage-docker





{% endhighlight %}


Here is how I set up my blog. ( This post will be a little involved.)  Also, this post is currently in progress; there will be clean-up later.

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
