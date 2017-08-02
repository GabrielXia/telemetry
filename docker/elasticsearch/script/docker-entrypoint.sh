#!/bin/bash

set -e

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- elasticsearch "$@"
fi

# Drop root privileges if we are running elasticsearch
# allow the container to be started with `--user`
if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
	# Change the ownership of user-mutable directories to elasticsearch
	for path in \
		/usr/share/elasticsearch/data \
		/usr/share/elasticsearch/logs \
	; do
		chown -R elasticsearch:elasticsearch "$path"
	done

	set -- gosu elasticsearch "$@"
	#exec gosu elasticsearch "$BASH_SOURCE" "$@"
fi

# As argument is not related to elasticsearch,
# then assume that user wants to run his own process,
# for example a `bash` shell to explore this image
exec "$@" &

sleep 15
until curl -XGET http://localhost:9200
do
	sleep 5
done

echo 'adding mappings'

curl -XPUT 'http://localhost:9200/_template/all' -d '
{
        "order": 0,
        "template": "*",
        "settings": {
            "index.number_of_shards": "1"
        },
        "mappings": {
            "_default_": {
                "dynamic_templates": [
                    {
                        "string": {
                            "mapping": {
                                "index": "not_analyzed",
                                "type": "string"
                            },
                            "match_mapping_type": "string"
                        }
                    }
                ]
            }
        },
        "aliases": {}
    }
}
'

while true;do sleep 5;done
