# exécuter le Docerfile dans le contexte de build => dossier qui contient le Dockerfile
# docker build -t stack-java-httpd:0.1 .
FROM httpd:2.4

## métadonnées != couche de système de fichiers
LABEL author="matt"
LABEL created_at="2025-09-30"
LABEL app="stack-java"
LABEL app.tiers="httpd"

# copie != montage d'un fichier/dossier dans "l'image" => couche en écriture
COPY ./httpd.conf /usr/local/apache2/conf

# exécuter une commande dans l'image
RUN mkdir /usr/local/apache2/conf/sites

# exposer un nouveau port
EXPOSE 80 443


## lancement du serveur
# donne la partie non substituable de la commande
# ENTRYPOINT [ "httpd" ]
# donne la partie substituable de la commande par une commande custom dans le docker run
# ou la clé command: dans un docker compose
# CMD [ "-D", "FOREGROUND" ]

# CMD ["httpd", "-D", "FOREGROUND"]