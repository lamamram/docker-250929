# exécuter le Docerfile dans le contexte de build => dossier qui contient le Dockerfile
# docker build -t stack-java-httpd:0.1 .

## image qui contient un curl en un seul binaire
FROM shakefu/curl-static AS curl-static

## faire qqch dans le stage curl-static

## pour créer une image de distrution on utiliser FROM scratch
FROM httpd:2.4

## métadonnées != couche de système de fichiers
LABEL author="matt"
LABEL created_at="2025-09-30"
LABEL app="stack-java"
LABEL app.tiers="httpd"

# copie != montage d'un fichier/dossier dans "l'image" => couche en écriture
COPY ./httpd.conf /usr/local/apache2/conf

# RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# exécuter une commande dans l'image
RUN mkdir /usr/local/apache2/conf/sites

COPY ./java_app.conf /usr/local/apache2/conf/sites

#                      src: shakefu/curl-static dst: httpd
COPY --from=curl-static /usr/local/bin/curl /usr/bin/curl

# exposer un nouveau port
EXPOSE 80 443


## lancement du serveur
# donne la partie non substituable de la commande
# ENTRYPOINT [ "httpd" ]
# donne la partie substituable de la commande par une commande custom dans le docker run
# ou la clé command: dans un docker compose
# CMD [ "-D", "FOREGROUND" ]

# CMD ["httpd", "-D", "FOREGROUND"]

# healthcheck PERIODIQUE tout les 20s puisque pas de RETRIES
HEALTHCHECK \
            --start-period=5s \
            --timeout=10s \
            --interval=20s \
            CMD curl http://127.0.0.1:80