# JEKYLL_RUNTIME_IP=$(docker-machine ip jekyll-runtime) docker-compose up

docker run \
 --env FORCE_POLLING=true \
 --env JEKYLL_ENV=development \
 --env VERBOSE=true \
 --interactive \
 --label=jekyll \
 --name=jekyll_runtime \
 --tty \
 --publish "$(docker-machine ip jekyll-runtime):4000:80" \
 --rm \
 --volume="$(pwd):/srv/jekyll" \
jekyll/jekyll:pages jekyll build --watch
