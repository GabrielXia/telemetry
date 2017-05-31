FROM postgres:9.6
MAINTAINER Gabriel Xia <ga.xiajin@gmail.com>

ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgres

RUN apt-get update \
    && apt-get install default-jre -y

COPY ./iglu-server-0.2.0.jar ./iglu-server-0.2.0.jar
COPY ./config/application.conf ./config/application.conf
COPY ./iglu-start.sh ./docker-entrypoint-initdb.d/iglu-start.sh

EXPOSE 8080
