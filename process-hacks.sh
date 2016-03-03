#!/bin/bash

# I wanted to maintain light & dark themes for the site, and to use git/jekyll for the site
# To do this, resorted to 'pre-processing' files to duplicate files and swap themes statically
# ( and 'post-processing' to duplicate paginated index.html to index-dark.html, and to swap in theme-switch URLs. )

# Remove all alternate-theme files and create directories again
# ( Currently supporting two themes: light (original), and dark

for dir in dark archives/dark _posts/dark; do
  echo -e "\nCulling $dir:"
  rm -rv "$dir" | grep '\.'
  mkdir "$dir" # Make directory again ... ( there may be a better than these two commands ) 
done

echo
echo 'Copying working files to new theme(s):'
echo
cp -av light/* dark
cp -av archives/light/* archives/dark
cp -av _posts/light/* _posts/dark

echo
echo "Sed'ing YAML in new files:"
echo
# Sed-switch files in new theme(s) to match yaml of new theme(s)
for dir in dark archives/dark _posts/dark; do
  echo "Sed'ing files in $dir."
  # switch custom 'theme' attribute:
  find "$dir" -type f -exec sed -i '' 's/theme: light/theme: dark/g' {} +
  # switch all possible layouts
  find "$dir" -type f -exec sed -i '' 's/layout: default_light/layout: default_dark/g' {} +
  find "$dir" -type f -exec sed -i '' 's/layout: post/layout: post_dark/g' {} +
done

echo
# switch 'categories: light' to new theme(s)
# very hacky ... to avoid needing to specify permalinks for every post
find "$dir" -type f -exec sed -i '' 's/categories: light/categories: dark/g' {} +

# It turns out that 'pre-processing' and 'post-processing' need to be run at the same time:
# Anytime a change is made prior to rendering a page on the site.

sleep 5

echo


# One directive that is important to me with blogging is that I not spend too much time on maintaining it.
# This script is here to 'patch' anything that happens with Jekyll that I don't like.
# I try to find the 'right' ways to do things, but sometimes it seems like chasing perfection exceeds the limits of the time I have for non-income generating projects.

# For some reason, Jeckyll pagination plug-in currently only supports pagination of one index page per site.
# In my case, I currently only want to support static theme-switching, so I just need to copy the file and mangle it, after generation.

echo "Running post-process hacks."

cp _site/index.html _site/light/index.html
cp _site/index.html _site/dark/index.html

# Force-fit dark side
sed -i .bak 's#colors-light#colors-dark#g' '_site/dark/index.html'
sed -i .bak 's#href="/">Home#href="/dark">Home#g' '_site/dark/index.html'
sed -i .bak 's#/light"#/dark"#g' '_site/dark/index.html'
sed -i .bak 's#/light/#/dark/#g' '_site/dark/index.html'



echo
echo 'Embedding theme-switching URLs...'
echo
./embed-theme-switch-URLs.py

echo


