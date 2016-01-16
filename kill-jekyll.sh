eval $(docker-machine env jekyll-runtime)

docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
