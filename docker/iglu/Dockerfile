FROM postgres:9.6

MAINTAINER Gabriel Xia <ga.xiajin@gmail.com>

ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgres

RUN mkdir -p /etc/iglu/ && \
    mkdir -p /opt/iglu/

WORKDIR /opt/iglu/

RUN apt-get update \
    && apt-get install default-jre -y \
    && apt-get install curl -y

COPY ./iglu-server-0.2.0.jar    /opt/iglu/iglu-server-0.2.0.jar
COPY ./config/                  /etc/iglu/config/
COPY ./script/iglu-upload.sh    /opt/iglu/iglu-upload.sh
COPY ./iglu-terasology/         /etc/iglu/iglu-terasology/

COPY ./script/iglu-start.sh     /docker-entrypoint-initdb.d/iglu-start.sh

RUN chmod +x /opt/iglu/iglu-upload.sh

EXPOSE 8080
