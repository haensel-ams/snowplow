This is an example of a folder which needs to be copied to the client machine (typically the same one that runs the MongoDB).
It contains several configuration files, notably the iglu JSON schema for HAMS universal unstruct event data (with dataLayer)
and an example configuration for the Snowplow EMR ETL runner.

The `run_snowplow.sh` should contain the client name, the internal IP of the mongo instance
and the AWS credentials for the snowplow IAM user and the configuration file for the emr-etl-runner, which needs to contain SSH key name
and subnet ID for the EMR cluster.

The snowplow config YAML (`spot_emr-config.yml`) should contain the EMR cluster subnet and SSH key.

The `iglu_resolver.json` should contain URL of the bucket with the JSON schema.

For the configuration files to work as expected, the S3 buckets should be setup in the usual way
(see the structure of SP buckets for any client or the trial setup on HAMS development account).

When this folder is copied to the home directory of the ubuntu user, the docker should mount the home directory as `/mnt/` volume.
The container can be started on the EC2 machine like this:

    sudo docker run -d --name snowplow -v/home/ubuntu/:/mnt/ --entrypoint /mnt/snowplow/run_snowplow.sh <image_id>; sudo docker rm snowplow

which should run the snowplow and remove the container afterwards.

The logs from the run are redirected to a file in ~/logs directory (needs to exist) named in this format: `snowplow_run_YYYY-mm-dd_HH.MM.log`.

Mongo loader is run automatically after a successful EMR run. If any of the steps in the snowplow run fails, email notification should be sent.

The snowplow user should have permission to access S3, run EMR clusters and send emails using SES.
