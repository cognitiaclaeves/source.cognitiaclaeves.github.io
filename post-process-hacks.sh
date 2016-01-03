
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

