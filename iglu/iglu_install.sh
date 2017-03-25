#!/bin/sh

java \
-Dconfig.file=./application.conf \
-jar iglu-server-0.2.0.jar com.snowplowanalytics.iglu.server.Boot
