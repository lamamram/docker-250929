#!/bin/bash
######## IMDEMPOTENCY ########

# docker ps
# -q: affiche uniquement le hash
# --filter name=stack-php: filtre par la colonne name
[[ -z $(docker ps -aq --filter name=stack-php) ]] || docker rm -f $(docker ps -aq --filter name=stack-php)

docker network ls | grep stack-php > /dev/null
if [[ "$?" -eq 0 ]]; then
  docker network rm stack-php
fi

######## RESEAU ########

# réseau bridge custom: nous donne une résolution dns interne avec le nom du conteneur
# cf vhost.conf
docker network create \
       --driver bridge \
       --subnet 172.19.0.0/16 \
       --gateway 172.19.0.1 \
       stack-php

######## CONTAINERS ########

# --env MARIADB_USER=test \
# --env MARIADB_PASSWORD=roottoor \
# --env MARIADB_DATABASE=test \
# --env MARIADB_ROOT_PASSWORD=roottoor \

## --env VAR=valeur : définit une variable d'environnement dans le conteneur
## --env-file .env : définit plusieurs variables d'environnement dans le conteneur à partir d'un fichier
# cf .env
## -v <name>:/path: volume nommé: permet la persistance des données gérée par docker
docker run \
       --name stack-php-mariadb \
       -d --restart unless-stopped \
       --net stack-php \
       --env-file .env \
       -v ./mariadb-init.sql:/docker-entrypoint-initdb.d/mariadb-init.sql \
       -v db_data:/var/lib/mysql \
       mariadb:11.4

# docker exec stack-php-mariadb bash -c 'mysql -u test -proottoor test < ./init.sql'

docker run \
       --name stack-php-fpm \
       -d --restart unless-stopped \
       -v ./index.php:/srv/index.php \
       -v ./pdo_mysql.so:/usr/local/lib/php/extensions/no-debug-non-zts-20230831/pdo_mysql.so \
       -v ./pdo.ini:/usr/local/etc/php/conf.d/pdo.ini \
       --env-file .env \
       --net stack-php \
       php:8.3.26-fpm-trixie
     
# docker cp ./index.php stack-php-fpm:/srv

# --name: nom du contneur
# -d: rend le processus lancé indépendant du terminal
# --restart unless-stopped: redémarre le conteneur sauf s'il a été arrêté manuellement
# -p 8080:80 : publish: redirige le port 8080 de toutes les interfaces de la machine hôte 
#                       vers le port 80 du conteneur (par défaut de l'interface docker0)
# -v ./...:/... : bind mount: monte le CHEMIN local du fichier dans le CHEMIN du même ficher du conteneur
docker run \
       --name stack-php-nginx \
       -d --restart unless-stopped \
       -p 8080:80 \
       -v ./vhost.conf:/etc/nginx/conf.d/vhost.conf \
       --net stack-php \
       nginx:1.29-bookworm-perl

## plus besoin de çà
# docker cp ./vhost.conf stack-php-nginx:/etc/nginx/conf.d
# recharge la conf nginx
# docker restart stack-php-nginx