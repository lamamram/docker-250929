#!/bin/bash
######## IMDEMPOTENCY ########

# docker ps
# -q: affiche uniquement le hash
# --filter name=stack-php: filtre par la colonne name
[[ -z $(docker ps -q --filter name=stack-php) ]] || docker rm -f $(docker ps -q --filter name=stack-php)

######## CONTAINERS ########

# --name: nom du contneur
# -d: rend le processus lancé indépendant du terminal
# --restart unless-stopped: redémarre le conteneur sauf s'il a été arrêté manuellement
# -p 8080:80 : publish: redirige le port 8080 de toutes les interfaces de la machine hôte 
#                       vers le port 80 du conteneur (par défaut de l'interface docker0)
docker run \
       --name stack-php-nginx \
       -d --restart unless-stopped \
       -p 8080:80 \
       nginx:1.29-bookworm-perl


docker run \
       --name stack-php-fpm \
       -d --restart unless-stopped \
       php:8.3.26-fpm-trixie
       
