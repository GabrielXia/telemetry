#!/bin/sh

kill `ps -ef | grep "/usr/bin/java -jar collector/./snowplow-stream-collector-0.9.0 --config configs/collector.config" | cut -d" " -f 5`
kill `ps -ef | grep snowplow-elasticsearch-sink-0.8.0-2x | cut -d" " -f 5`
kill `ps -ef | grep iglu-server-0.2.0.jar | cut -d" " -f 5`
kill `ps -ef | grep kibana-4.6.4-darwin-x86_64 | cut -d" " -f 5`
kill `ps -ef | grep elasticsearch-2.4.4 | cut -d" " -f 5`
kill `ps -ef | grep logstash | cut -d" " -f 5`
