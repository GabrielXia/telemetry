#!/bin/sh

collector_cmd="/usr/bin/java -jar snowplow-stream-collector.jar --config /etc/snowplow/config/collector.conf"

enrich_cmd="/usr/bin/java -jar snowplow-stream-enrich.jar --config /etc/snowplow/config/enrich.conf --resolver file:/etc/snowplow/config/resolver.json --enrichments file:/etc/snowplow/enrichments/"

elasticsearch_good_cmd="java -jar -Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.SimpleLog -Dorg.apache.commons.logging.simplelog.defaultlog=off \
snowplow-elasticsearch-sink.jar --config /etc/snowplow/config/elasticsearch-sink-good.hocon"

elasticsearch_bad_cmd="java -jar -Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.SimpleLog -Dorg.apache.commons.logging.simplelog.defaultlog=off \
snowplow-elasticsearch-sink.jar --config /etc/snowplow/config/elasticsearch-sink-bad.hocon"

# log path
elaticsearch_sink_good_stdout_log="/var/log/elasticsearch_sink_good.log"
elaticsearch_sink_good_stderr_log="/var/log/elasticsearch_sink_good.err"
elaticsearch_sink_bad_stdout_log="/var/log/elasticsearch_sink_bad.log"
elaticsearch_sink_bad_stderr_log="/var/log/elasticsearch_sink_bad.err"

raw_events_pipe="/pipe/raw_events_pipe"
enriched_pipe="/pipe/enriched_pipe"
bad_1_pipe="/pipe/bad_1_pipe"

mkfifo "$raw_events_pipe"
mkfifo "$enriched_pipe"
mkfifo "$bad_1_pipe"

sleep 30
echo "Starting snowplow elasticseach sink bad"
cat "$bad_1_pipe" | $elasticsearch_bad_cmd >> "$elaticsearch_sink_bad_stdout_log" 2>> "$elaticsearch_sink_bad_stderr_log" &

echo "Starting snowplow elasticsearch sink good"
cat "$enriched_pipe" | $elasticsearch_good_cmd >> "$elaticsearch_sink_good_stdout_log" 2>> "$elaticsearch_sink_good_stderr_log" &

echo "Starting snowplow stream enrich"
cat "$raw_events_pipe" | $enrich_cmd >> "$enriched_pipe" 2>> "$bad_1_pipe" &

echo "Starting snowplow stream collector"
$collector_cmd  >> "$raw_events_pipe" 2>> "$bad_1_pipe" &

# In case of exceptions
sleep 60
until curl http://localhost:80/health
do
  echo "Collector shuts down, will try set up again"

  echo "Starting snowplow elasticseach sink bad"
  cat "$bad_1_pipe" | $elasticsearch_bad_cmd >> "$elaticsearch_sink_bad_stdout_log" 2>> "$elaticsearch_sink_bad_stderr_log" &

  echo "Starting snowplow elasticseach sink good"
  cat "$enriched_pipe" | $elasticsearch_good_cmd >> "$elaticsearch_sink_good_stdout_log" 2>> "$elaticsearch_sink_good_stderr_log" &

  echo "Starting snowplow stream enrich"
  cat "$raw_events_pipe" | $enrich_cmd >> "$enriched_pipe" 2>> "$bad_1_pipe" &

  echo "Starting snowplow stream collector"
  $collector_cmd  >> "$raw_events_pipe" 2>> "$bad_1_pipe" &
  sleep 60
done

while true;do sleep 5;done
