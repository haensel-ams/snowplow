#!/bin/bash

export AWS_ACCESS_KEY_ID=add_here
export AWS_SECRET_ACCESS_KEY=add_here

export CLIENT_NAME=add_here
export MONGO_HOST=add_here

export MONGO_DB=snowplow
export MONGO_COLLECTION=atomic

export REMOVE_DUPLICATES=false # relevant only for klikki

LOGS=/mnt/logs/`date +snowplow_run_%Y-%m-%d_%H.%M.log`

(/snowplow/3-enrich/hams-emr-etl-runner.sh && /snowplow/4-storage/mongo-storage/hams-mongo-loader.sh) 2>&1 | tee >> ${LOGS}
