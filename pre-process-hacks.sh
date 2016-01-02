#!/bin/bash

# Wanted to maintain light & dark themes for the site, and wanted to use git/jekyll for the site
# To do this, resorted to pre-processing files to duplicate files and swap themes statically
# ( and post-processing to duplicate paginated index.html to index-dark.html. )

# Remove all alternate-theme files and create directories again
# ( Currently supporting two themes: light (original), and dark
for dir in dark archives/dark _posts/dark; do
  echo -e "\nProcessing $dir:"
  rm -rv "$dir" | grep '\.'
  mkdir "$dir" # Make directory again ... ( there may be a better than these two commands ) 
done

# Copy working files to new theme(s)
cp -a light/* dark
cp -a archives/light/* archives/dark
cp -a _posts/light/* _posts/dark

# Sed-switch files in new theme(s) to match yaml of new theme(s)
for dir in dark archives/dark _posts/dark; do
  # switch custom 'theme' attribute:
  find "$dir" -type f -exec sed -i '' 's/theme: light/theme: dark/g' {} +
  # switch all possible layouts
  find "$dir" -type f -exec sed -i '' 's/layout: default_light/layout: default_dark/g' {} +
  find "$dir" -type f -exec sed -i '' 's/layout: post/layout: post_dark/g' {} +
done

# switch 'categories: light' to new theme(s)
# very hacky ... to avoid needing to specify permalinks for every post
find "$dir" -type f -exec sed -i '' 's/categories: light/categories: dark/g' {} +


