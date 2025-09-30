docker rm -f stack-php-nginx stack-php-fpm
docker rm network stack-php

docker network create --driver bridge --subnet 172.19.0.0/16 --gateway 172.19.0.1 stack-php

docker run --name stack-php-fpm -d --restart unless-stopped -v .\index.php:/srv/index.php --net stack-php php:8.3.26-fpm-trixie
docker run --name stack-php-nginx -d --restart unless-stopped -v .\vhost.conf:/etc/nginx/conf.d/vhost.conf --net stack-php -p 8080:80 nginx:1.29-bookworm-perl


