FROM iron/java:1.8

MAINTAINER Gabriel Xia <ga.xiajin@gmail.com>

RUN mkdir -p /etc/snowplow/ && \
    mkdir -p /opt/snowplow/ && \
    mkdir -p /pipe/

ENV SNOWPLOW_COLLECTOR_ZIP snowplow_scala_stream_collector_0.9.0.zip
ENV SNOWPLOW_COLLECTOR_JAR snowplow-stream-collector-0.9.0

ENV SNOWPLOW_ENRICH_ZIP snowplow_stream_enrich_0.10.0.zip
ENV SNOWPLOW_ENRICH_JAR snowplow-stream-enrich-0.10.0

ENV SNOWPLOW_ELASTICSEARCH_ZIP snowplow_kinesis_elasticsearch_sink_0.8.0_2x.zip
ENV SNOWPLOW_ELASTICSEARCH_JAR snowplow-elasticsearch-sink-0.8.0-2x

WORKDIR /opt/snowplow/

RUN wget http://dl.bintray.com/snowplow/snowplow-generic/${SNOWPLOW_COLLECTOR_ZIP} && \
    unzip ${SNOWPLOW_COLLECTOR_ZIP} && \
    rm ${SNOWPLOW_COLLECTOR_ZIP} && \
    mv ${SNOWPLOW_COLLECTOR_JAR} snowplow-stream-collector.jar && \
    wget http://dl.bintray.com/snowplow/snowplow-generic/${SNOWPLOW_ENRICH_ZIP} && \
    unzip ${SNOWPLOW_ENRICH_ZIP} && \
    rm ${SNOWPLOW_ENRICH_ZIP} && \
    mv ${SNOWPLOW_ENRICH_JAR} snowplow-stream-enrich.jar && \
    wget http://dl.bintray.com/snowplow/snowplow-generic/${SNOWPLOW_ELASTICSEARCH_ZIP} && \
    unzip ${SNOWPLOW_ELASTICSEARCH_ZIP} && \
    rm ${SNOWPLOW_ELASTICSEARCH_ZIP} && \
    mv ${SNOWPLOW_ELASTICSEARCH_JAR} snowplow-elasticsearch-sink.jar

RUN mkdir -p /etc/snowplow/enrichments/

COPY config/ /etc/snowplow/config/

COPY docker-entrypoint.sh /opt/snowplow/
RUN chmod +x /opt/snowplow/docker-entrypoint.sh

RUN apk add --update curl

EXPOSE 14654

ENTRYPOINT ["/opt/snowplow/docker-entrypoint.sh"]
