-- AUTO-GENERATED BY schema-ddl DO NOT EDIT
-- Generator: schema-ddl 0.1.0
-- Generated: 2015-07-30 15:16

-- Source: iglu:com.snowplowanalytics.monitoring.batch/emr_job_status/jsonschema/1-0-0

CREATE SCHEMA IF NOT EXISTS atomic;

CREATE TABLE IF NOT EXISTS atomic.com_snowplowanalytics_monitoring_batch_emr_job_status_1 (
    "schema_vendor"            VARCHAR(128)  ENCODE RUNLENGTH NOT NULL,
    "schema_name"              VARCHAR(128)  ENCODE RUNLENGTH NOT NULL,
    "schema_format"            VARCHAR(128)  ENCODE RUNLENGTH NOT NULL,
    "schema_version"           VARCHAR(128)  ENCODE RUNLENGTH NOT NULL,
    "root_id"                  CHAR(36)      ENCODE RAW       NOT NULL,
    "root_tstamp"              TIMESTAMP     ENCODE RAW       NOT NULL,
    "ref_root"                 VARCHAR(255)  ENCODE RUNLENGTH NOT NULL,
    "ref_tree"                 VARCHAR(1500) ENCODE RUNLENGTH NOT NULL,
    "ref_parent"               VARCHAR(255)  ENCODE RUNLENGTH NOT NULL,
    "created_at"               TIMESTAMP     ENCODE LZO       NOT NULL,
    "jobflow_id"               VARCHAR(32)   ENCODE LZO       NOT NULL,
    "name"                     VARCHAR(255)  ENCODE LZO       NOT NULL,
    "state"                    VARCHAR(22)   ENCODE LZO       NOT NULL,
    "ended_at"                 TIMESTAMP     ENCODE LZO,
    "last_state_change_reason" VARCHAR(255)  ENCODE LZO,
    FOREIGN KEY (root_id) REFERENCES atomic.events(event_id)
)
DISTSTYLE KEY
DISTKEY (root_id)
SORTKEY (root_tstamp);