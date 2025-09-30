docker rm -f stack-php-nginx stack-php-fpm stack-php-mariadb
docker rm network stack-php

docker network create --driver bridge --subnet 172.19.0.0/16 --gateway 172.19.0.1 stack-php

docker run --name stack-php-mariadb -d --restart unless-stopped --net stack-php --env MARIADB_USER=test --env-file .env -v ./mariadb-init.sql:/docker-entrypoint-initdb.d/mariadb-init.sql -v db_data:/var/lib/mysql mariadb:11.4
docker run --name stack-php-fpm -d --restart unless-stopped -v .\index.php:/srv/index.php -v .\pdo_mysql.so:/usr/local/lib/php/extensions/no-debug-non-zts-20230831/pdo_mysql.so -v .\pdo.ini:/usr/local/etc/php/conf.d/pdo.ini --env-file .env --net stack-php php:8.3.26-fpm-trixie
docker run --name stack-php-nginx -d --restart unless-stopped -v .\vhost.conf:/etc/nginx/conf.d/vhost.conf --net stack-php -p 8080:80 nginx:1.29-bookworm-perl

