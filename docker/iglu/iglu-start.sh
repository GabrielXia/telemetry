#!/bin/bash

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER snowplow PASSWORD 'snowplow';
    CREATE DATABASE iglu;
    GRANT ALL PRIVILEGES ON DATABASE iglu TO snowplow;
EOSQL

java \
    -Dconfig.file=../config/application.conf \
    -jar ../iglu-server-0.2.0.jar com.snowplowanalytics.iglu.server.Boot
