docker rm -f stack-php-nginx stack-php-fpm

docker run --name stack-php-fpm -d --restart unless-stopped -v .\index.php:/srv/index.php php:8.3.26-fpm-trixie
docker run --name stack-php-nginx -d --restart unless-stopped -v .\vhost.conf:/etc/nginx/conf.d/vhost.conf -p 8080:80 nginx:1.29-bookworm-perl


