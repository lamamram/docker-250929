## nous allons utiliser une image debian:12-slim
FROM debian:12-slim

## documenter l'image
LABEL author="matt"
LABEL created="2025-10-01"
LABEL app="stack-java"
LABEL stack.tiers="tomcat"

ARG TOMCAT_VERSION_MAJOR=9
ARG TOMCAT_VERSION_FULL

## BEST PRACTICE 1. gradient de fréquence de changement des couches
## BEST PRACTICE 2. enchainer les commandes pour créer / modifier / supprimer des fichiers/dossiers dans les mêmes couches
## BEST PRACTICE 2bis. travailler en flux et non en fichier par défaut ( curl | tar )
## BEST PRACTICE 3. enchainer les RUN autant que possible
RUN apt-get update -q && apt-get install -y -q openjdk-17-jre-headless curl && \
    rm -rf /var/lib/apt/cache/lists/* && \
    mkdir /opt/tomcat && \
    curl https://downloads.apache.org/tomcat/tomcat-${TOMCAT_VERSION_MAJOR}/v${TOMCAT_VERSION_FULL}/bin/apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz | \
    tar -xzv -C /opt/tomcat --strip-components=1 && \
    useradd -M -d /opt/tomcat -U tomcat

WORKDIR /opt/tomcat/webapps

ADD https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war .

RUN chown -R tomcat:tomcat /opt/tomcat

USER tomcat

VOLUME [ "/opt/tomcat/webapps" ]

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run" ]

# quand le docker run est lancé
# le CMD ci dessus est lancé
# 1. on attent <start-period>
# 2. le CMD du HEALTHCHECK est lancé
# 3.1. le // termine avant le <timeout> avec le code 0 => SUCESS => (healthy) dans le STATUS du docker ps
# 3.2. le // termine avant le <timeout> avec un code non-zero => ERROR (unhealthy)
# 3.3. le // ne termine pas avant le <timeout>
# si 3.2 ou 3.3 => on reessaye <retries> fois
# si 3.2 ou 3.3 => avant de réessayer on attend <interval>s
## REM: le CMD doit être écrit sans JSON
HEALTHCHECK \
            --start-period=3s \
            --timeout=5s \
            --retries=3 \
            --interval=3s \
            CMD grep "Server startup" /opt/tomcat/logs/catalina.*.log