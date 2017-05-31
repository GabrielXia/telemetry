FROM iron/java:1.8

MAINTAINER Gabriel Xia <ga.xiajin@gmail.com>

RUN mkdir -p /etc/snowplow/ && \
    mkdir -p /opt/snowplow/ && \
    mkdir -p /pipe

VOLUME /pipe

ENV SNOWPLOW_ZIP snowplow_scala_stream_collector_0.9.0.zip
ENV SNOWPLOW_JAR snowplow-stream-collector-0.9.0

WORKDIR /opt/snowplow/
RUN wget http://dl.bintray.com/snowplow/snowplow-generic/${SNOWPLOW_ZIP} && \
    unzip ${SNOWPLOW_ZIP} && \
    rm ${SNOWPLOW_ZIP} && \
    mv ${SNOWPLOW_JAR} snowplow-stream-collector.jar

COPY config/collector.conf /etc/snowplow/collector.conf

EXPOSE 80

COPY docker-entrypoint.sh /opt/snowplow/
RUN chmod +x /opt/snowplow/docker-entrypoint.sh

ENTRYPOINT ["/opt/snowplow/docker-entrypoint.sh"]
