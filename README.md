# [source].cognitiaclaeves.github.io

This blog is Jekyll-based, in the following manner:
-Jekyll runs inside a docker container, and is run whenever I want to
update the site.
-After changes are made, scripts are run to mangle both the contents of
the source files that Jeckyll processes, and the contents of the \_site
files that Jeckyll produces. ( This is done for finer control of the end
result of the site. )
-The source code is pushed to github.com/../source.cognitiaclaeves.github.io.git, and the
resulting site is pushed to github.com/../cognitiaclaeves.github.io.git, updating
http://cognitiaclaeves.github.io.

The end result is a site that is maintained by quickly adding markup
files whose appearance can be switched between a light theme and a dark
theme.

