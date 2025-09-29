#!/bin/bash
######## IMDEMPOTENCY ########

[[ -z $(docker ps -q --filter name=stack-php) ]] || docker rm -f $(docker ps -q --filter name=stack-php)

######## CONTAINERS ########

docker run \
       --name stack-php-nginx \
       -d --restart unless-stopped \
       -p 8080:80 \
       nginx:1.29-bookworm-perl


docker run \
       --name stack-php-fpm \
       -d --restart unless-stopped \
       php:8.3.26-fpm-trixie
       
