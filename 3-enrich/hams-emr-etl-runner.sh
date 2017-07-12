#!/bin/bash

source ~/.rvm/scripts/rvm
ruby --version

SNOWPLOW_HOME=/snowplow

# use default enrichments from the SP installation
RUNNER_ENRICHMENTS=${SNOWPLOW_HOME}/3-enrich/config/enrichments

SP_CONFIG_PATH=/mnt/snowplow

# resolver config should contain URI of HAMS JSON schema (unified data layer)
RUNNER_RESOLVER=${SP_CONFIG_PATH}/iglu_resolver.json

# the two configurations differ in EMR settings
# first one uses spot instances to run the EMR (cheper) and the other ondemand
RUNNER_CONFIG=${SP_CONFIG_PATH}/spot_emr-config.yml

# how many times to restart the data import on error before giving up
TOTAL_RETRIES=2

SNOWPLOW_PROCESSING=s3://${CLIENT_NAME}-snowplow-processing/processing/
SNOWPLOW_LOGS=s3://${CLIENT_NAME}-snowplow-logs/

EMR_RUNNER_EXIT_STATUS=0
for ATTEMPT in `seq $TOTAL_RETRIES`
do
    echo "Running EmrEtlRunner (attempt $ATTEMPT/$TOTAL_RETRIES)..."
    
    ${SNOWPLOW_HOME}/3-enrich/emr-etl-runner/bin/snowplow-emr-etl-runner --skip shred --config ${RUNNER_CONFIG} --resolver ${RUNNER_RESOLVER} --enrichments ${RUNNER_ENRICHMENTS}
    EMR_RUNNER_EXIT_STATUS=$?

    # reset the buckets to their initial state if the EMR run failed
    if [ $EMR_RUNNER_EXIT_STATUS -ne 0 ]; then
        >&2 echo "Error running EmrEtlRunner!"
        >&2 echo "The EMR ETL runner process returned with code ${EMR_RUNNER_EXIT_STATUS}."

        >&2 echo "Resetting the S3 buckets to their pre-run state."
        aws s3 mv --recursive --include='*' ${SNOWPLOW_PROCESSING} ${SNOWPLOW_LOGS}
    else
        echo "The EMR ETL runner has finished successfully!"

        # the EMR ETL run was successful and we have enriched data
        # escape the for-loop and do not run it again
        break
    fi
done

if [ ${EMR_RUNNER_EXIT_STATUS} -ne 0 ]; then
    aws ses send-email --destination ToAddresses=peter@haensel-ams.com --message 'Subject={Data="Snowplow EMR ETL run has failed for '${CLIENT_NAME}'",Charset=utf-8},Body={Text={Data="This is an automated email. Check logs on the snowplow instance for details.",Charset=utf-8}}' --from peter@haensel-ams.com
fi

# we count on the correct value of this exit code in the parent calling script
exit $EMR_RUNNER_EXIT_STATUS
