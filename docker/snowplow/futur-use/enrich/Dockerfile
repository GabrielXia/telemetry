FROM iron/java:1.8

MAINTAINER Gabriel Xia <ga.xiajin@gmail.com>

RUN mkdir -p /etc/snowplow/ && \
    mkdir -p /opt/snowplow/ && \
    mkdir -p /pipe

VOLUME /pipe

ENV SNOWPLOW_ZIP snowplow_stream_enrich_0.10.0.zip
ENV SNOWPLOW_JAR snowplow-stream-enrich-0.10.0

WORKDIR /opt/snowplow/
RUN wget http://dl.bintray.com/snowplow/snowplow-generic/${SNOWPLOW_ZIP} && \
    unzip ${SNOWPLOW_ZIP} && \
    rm ${SNOWPLOW_ZIP} && \
    mv ${SNOWPLOW_JAR} snowplow-stream-enrich.jar

RUN mkdir -p /etc/snowplow/enrichments/

COPY config/enrich.conf /etc/snowplow/enrich.conf
COPY config/resolver.json /etc/snowplow/resolver.json


COPY docker-entrypoint.sh /opt/snowplow/
RUN chmod +x /opt/snowplow/docker-entrypoint.sh

ENTRYPOINT ["/opt/snowplow/docker-entrypoint.sh"]
