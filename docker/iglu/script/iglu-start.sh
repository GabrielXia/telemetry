#!/bin/sh

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER snowplow PASSWORD 'snowplow';
    CREATE DATABASE iglu;
    GRANT ALL PRIVILEGES ON DATABASE iglu TO snowplow;
EOSQL

echo "Initialising postgres data base"
java -Dconfig.file=/etc/iglu/config/application.conf -jar /opt/iglu/iglu-server-0.2.0.jar com.snowplowanalytics.iglu.server.Boot &

sleep 60

VALUE=$(PGPASSWORD=snowplow psql  -v ON_ERROR_STOP=1 --username=snowplow --dbname=iglu <<-EOSQL
    INSERT INTO apikeys (uid, vendor_prefix, permission, createdat) VALUES ('980ae3ab-3aba-4ffe-a3c2-3b2e24e2ffce','*','super',current_timestamp);
EOSQL)

echo $VALUE

echo "uploading terasology event schemas"
/opt/iglu/iglu-upload.sh http://iglu:8080 980ae3ab-3aba-4ffe-a3c2-3b2e24e2ffce /etc/iglu/iglu-terasology/schemas
