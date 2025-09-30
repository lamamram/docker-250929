#!/bin/bash
######## IMDEMPOTENCY ########

# docker ps
# -q: only display hash
# --filter name=stack-php: filter by name
[[ -z $(docker ps -q --filter name=stack-php) ]] || docker rm -f $(docker ps -q --filter name=stack-php)

######## CONTAINERS ########

# --name: container name
# -d: detached mode
# --restart unless-stopped: restart policy
# -p 8080:80 : publish port 80 of container to port 8080 of every interfaces of host
docker run \
       --name stack-php-nginx \
       -d --restart unless-stopped \
       -p 8080:80 \
       nginx:1.29-bookworm-perl


docker run \
       --name stack-php-fpm \
       -d --restart unless-stopped \
       php:8.3.26-fpm-trixie
       
