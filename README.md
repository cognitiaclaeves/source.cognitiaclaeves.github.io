# [source].cognitiaclaeves.github.io

This blog is Jekyll-based, in the following manner:

- Jekyll runs inside a docker container, and is run whenever I want to
update the site.
- After changes are made, I manually run scripts to mangle both the contents of
the source files that Jeckyll processes, and the contents of the \_site
files that Jekyll produces. ( This is done for finer control of the end
result of the site. )
- The source code is pushed to https://github.com/cognitiaclaeves/source.cognitiaclaeves.github.io.git [^1] , and the
resulting site is pushed to github.com/cognitiaclaeves/cognitiaclaeves.github.io.git, updating the live site, 
http://cognitiaclaeves.github.io.


The end result is a static site that is maintained by quickly adding markup
files whose appearance can be switched between a light theme and a dark
theme by the user.


[^1]: Jekyll takes the markdown files under _posts and generates to a directory called \_sites from them, which is in the .gitigore file for source.cognitiaclaeves.github.io.git. The \_sites directory is cloned from cognitiaclaeves.github.io.git, which updates the live site.