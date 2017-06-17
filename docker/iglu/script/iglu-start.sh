#!/bin/sh
set -e

stdout_log="/var/run/postgresql/iglu.log"
stderr_log="/var/run/postgresql/iglu.err"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER snowplow PASSWORD 'snowplow';
    CREATE DATABASE iglu;
    GRANT ALL PRIVILEGES ON DATABASE iglu TO snowplow;
EOSQL

echo "Initialising postgres data base"
java -Dconfig.file=/etc/iglu/config/application.conf -jar /opt/iglu/iglu.jar com.snowplowanalytics.iglu.server.Boot >> "$stdout_log" 2>>"$stderr_log" &

sleep 5

# Insert apikeys
until PGPASSWORD=snowplow psql --username=snowplow --dbname=iglu -c "INSERT INTO apikeys (uid, vendor_prefix, permission, createdat) VALUES ('980ae3ab-3aba-4ffe-a3c2-3b2e24e2ffce','*','super',current_timestamp);"
do
  >&2 echo "iglu not available, will try later"
  sleep 5
done
echo "Insert apikeys for iglu successfully"

# Upload schemas
sleep 10
echo "Uploading terasology event schemas, will try 3 times"
counter=0
until /opt/iglu/iglu-upload.sh http://iglu:8080 980ae3ab-3aba-4ffe-a3c2-3b2e24e2ffce /etc/iglu/iglu-terasology/schemas
do
  if $counter -gt 2
  then
    break
  fi
  echo "trying the $counter-th time"
  let counter=counter+1
done
