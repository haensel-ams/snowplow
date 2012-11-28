CREATE EXTERNAL TABLE IF NOT EXISTS `events` (
tm string,
txn_id string,
user_id string,
user_ipaddress string,
visit_id int,
page_url string,
page_title string,
page_referrer string,
mkt_source string,
mkt_medium string,
mkt_term string,
mkt_content string,
mkt_campaign string,
ev_category string,
ev_action string,
ev_label string,
ev_property string,
ev_value string,
tr_orderid string,
tr_affiliation string,
tr_total string,
tr_tax string,
tr_shipping string,
tr_city string,
tr_state string,
tr_country string,
ti_orderid string,
ti_sku string,
ti_name string,
ti_category string,
ti_price string,
ti_quantity string,
br_name string,
br_family string,
br_version string,
br_type string,
br_renderengine string,
br_lang string,
br_features array<string>,
br_cookies boolean,
os_name string,
os_family string,
os_manufacturer string,
dvce_type string,
dvce_ismobile boolean,
dvce_screenwidth int,
dvce_screenheight int,
app_id string,
platform string,
event string, -- Renamed in 0.5.1
v_tracker string,
v_collector string,
v_etl string,
-- Added in 0.5.1
event_id string
user_fingerprint string,
useragent string,
br_colordepth string,
os_timezone string
)
PARTITIONED BY (dt STRING)
LOCATION '${EVENTS_TABLE}' ;
