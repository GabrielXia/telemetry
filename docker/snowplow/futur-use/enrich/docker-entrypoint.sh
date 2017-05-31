#!/bin/sh

cmd="/usr/bin/java -jar snowplow-stream-enrich.jar --config /etc/snowplow/enrich.conf --resolver file:/etc/snowplow/resolver.json --enrichments file:/etc/snowplow/enrichments/"

raw_events_pipe="/pipe/raw_events_pipe"
enriched_pipe="/pipe/enriched_pipe"
bad_1_pipe="/pipe/bad_1_pipe"

sleep 5

echo "sleep end"

cat "$raw_events_pipe" | $cmd > "$enriched_pipe" 2> "$bad_1_pipe" &

echo "enrich starting"

while true;do sleep 5;done
