#!/bin/sh

cmd="/usr/bin/java -jar snowplow-stream-collector.jar --config /etc/snowplow/collector.conf"

raw_events_pipe="/pipe/raw_events_pipe"
enriched_pipe="/pipe/enriched_pipe"
bad_1_pipe="/pipe/bad_1_pipe"

mkfifo "$raw_events_pipe"
mkfifo "$enriched_pipe"
mkfifo "$bad_1_pipe"

$cmd > "$raw_events_pipe" 2> "$bad_1_pipe" &
echo "collector starting"

while true;do sleep 5;done
