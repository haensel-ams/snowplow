#!/bin/bash

ALL_RUNS=s3://${CLIENT_NAME}-snowplow-out/enriched/good/
MONGO_ARCHIVE=s3://${CLIENT_NAME}-snowplow-mongodb-archive/

MONGO_STORAGE_RESOURCES=/snowplow/4-storage/mongo-storage

for RUN_RESULTS in `aws s3 ls ${ALL_RUNS} | grep PRE | awk '{print $NF}'`; do
    for EVENT_FILE in `aws s3 ls ${ALL_RUNS}${RUN_RESULTS} | grep part | awk '{print $NF}'`; do
        echo Importing $EVENT_FILE
        aws s3 cp ${ALL_RUNS}${RUN_RESULTS}${EVENT_FILE} /tmp/snowplow_events
        DOWNLOAD_EXIT_STATUS=$?
        if [ ${DOWNLOAD_EXIT_STATUS} -ne 0 ]; then
            >&2 echo "Download of the event file ${EVENT_FILE} has failed!"
            aws ses send-email --destination ToAddresses=peter@haensel-ams.com --message 'Subject={Data="Snowplow loader has failed for '${CLIENT_NAME}'",Charset=utf-8},Body={Text={Data="This is an automated email. Check logs on the snowplow instance for details.",Charset=utf-8}}' --from peter@haensel-ams.com
            exit $DOWNLOAD_EXIT_STATUS
        fi
        if [ ${REMOVE_DUPLICATES} = "true" ]; then
            echo " removing duplicates..."
            echo "  original size: `du -sh /tmp/snowplow_events`"
            ${MONGO_STORAGE_RESOURCES}/remove_duplicates.sh /tmp/snowplow_events
            echo "  size with duplicates removed: `du -sh /tmp/snowplow_events`"
        fi
        echo " importing to mongo..."
        mongoimport --host ${MONGO_HOST} --db ${MONGO_DB} --collection ${MONGO_COLLECTION} --type tsv --file /tmp/snowplow_events --fieldFile "${MONGO_STORAGE_RESOURCES}/atomic_events_header.csv"
        IMPORT_EXIT_STATUS=$?
        if [ ${IMPORT_EXIT_STATUS} -ne 0 ]; then
            >&2 echo "Import of the event file ${EVENT_FILE} into MongoDB has failed!"
            aws ses send-email --destination ToAddresses=peter@haensel-ams.com --message 'Subject={Data="Snowplow loader has failed for '${CLIENT_NAME}'",Charset=utf-8},Body={Text={Data="This is an automated email. Check logs on the snowplow instance for details.",Charset=utf-8}}' --from peter@haensel-ams.com
            exit $IMPORT_EXIT_STATUS
        fi
        rm -f /tmp/snowplow_events
    done
done

echo "Moving imported results to mongodb archive..."
aws s3 mv --recursive --include='*' ${ALL_RUNS} ${MONGO_ARCHIVE}
