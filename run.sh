#!/bin/sh

# commands
collecter_cmd="collector/./snowplow-stream-collector-0.9.0 --config configs/collector.config"

enrich_cmd="enrich/./snowplow-stream-enrich-0.10.0 --config configs/enrich.config --resolver file:configs/iglu_resolver.json"

elasticsearch_good_cmd="java -jar -Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.SimpleLog -Dorg.apache.commons.logging.simplelog.defaultlog=off \
elasticsearch/./snowplow-elasticsearch-sink-0.8.0-2x --config configs/elasticsearch-sink-good.hocon"

elasticsearch_bad_cmd="java -jar -Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.SimpleLog -Dorg.apache.commons.logging.simplelog.defaultlog=off \
elasticsearch/./snowplow-elasticsearch-sink-0.8.0-2x --config configs/elasticsearch-sink-bad.hocon"

iglu_cmd="java \
-Dconfig.file=./iglu/application.conf \
-jar ./iglu/iglu-server-0.2.0.jar com.snowplowanalytics.iglu.server.Boot"

iglu_upload_cmd="./iglu/./iglu_server_upload.sh http://localhost:8080 6135d9a2-346e-4beb-8735-cacc1fe0d352 ./iglu/iglu-terasology/schemas"

elasticsearch_cmd="/elasticsearch/elasticsearch-2.4.4/bin/./elasticsearch"

kibana_cmd="kibana-4.6.4-darwin-x86_64/bin/./kibana"

logstash_cmd="logstash-5.2.2/bin/./logstash -f configs/logstash.conf --debug"

# set up pipes
mkdir -p ./pipes
rm ./pipes/raw_events_pipe
rm ./pipes/enriched_pipe
rm ./pipes/bad_1_pipe
mkfifo ./pipes/raw_events_pipe
mkfifo ./pipes/enriched_pipe
mkfifo ./pipes/bad_1_pipe

raw_events_pipe="./pipes/raw_events_pipe"
enriched_pipe="./pipes/enriched_pipe"
bad_1_pipe="./pipes/bad_1_pipe"

# start Iglu-terasology
$iglu_cmd &
sleep 10

# upload shemas to Iglu-terasology
$iglu_upload_cmd

# start collector
echo "starting collector"
$collecter_cmd > "$raw_events_pipe" 2> "$bad_1_pipe" &

# start enrich
echo "starting enrich"
cat "$raw_events_pipe" | $enrich_cmd > "$enriched_pipe" 2> "$bad_1_pipe" &

# start elasticsearch good sink
echo "starting elasticsearch good sink"
cat "$enriched_pipe" | $elasticsearch_good_cmd 2> "$bad_1_pipe" &

# start elasticsearch bad sink
echo "starting elasticsearch bad sink"
cat "$bad_1_pipe" | $elasticsearch_bad_cmd &

# start elasticsearch
echo "starting elasticsearch"
command_path=$(pwd)
echo "$command_path$elasticsearch_cmd" > elasticsearch_cmd
chmod +x elasticsearch_cmd
open elasticsearch_cmd
sleep 5

# start kibana
echo "starting kibana"
$kibana_cmd &

# start logstash
$logstash_cmd
