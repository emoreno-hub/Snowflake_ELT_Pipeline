USE WAREHOUSE COMPUTE_WH;
USE DATABASE YELP;
USE SCHEMA ODS;

-- load data from staging into ODS layer
insert into business
select distinct
    recordjson:business_id,
    recordjson:name,
    recordjson:is_open,
    recordjson:address,
    recordjson:city,
    recordjson:state,
    recordjson:postal_code,
    recordjson:longitude,
    recordjson:latitude,
    recordjson:review_count,
    recordjson:stars
from yelp.staging.yelp_academic_dataset_business;


-- date column contains an array of dates and flatten is used to flatten into multiple rows
insert into checkin
select
    recordjson:business_id,
    d.value::date
from yelp.staging.yelp_academic_dataset_checkin,
lateral flatten(INPUT=>SPLIT(recordjson:date, ', ')) d;


insert into covid_features
select 
    recordjson:"business_id",
    recordjson:"Call To Action enabled",
    recordjson:"Grubhub enabled",
    recordjson:"Request a Quote Enabled",
    recordjson:"Temporary Closed Until",
    recordjson:"Virtual Services Offered",
    recordjson:"delivery or takeout",
    recordjson:"highlights"
from yelp.staging.yelp_academic_dataset_covid_features;


insert into user
select
    recordjson:user_id,
    recordjson:name,
    recordjson:average_stars,
    recordjson:review_count,
    recordjson:useful,
    recordjson:yelping_since
from yelp.staging.yelp_academic_dataset_user;


insert into review
select
    recordjson:review_id,
    recordjson:business_id,
    recordjson:date,
    recordjson:cool,
    recordjson:funny,
    recordjson:stars,
    recordjson:useful,
    recordjson:user_id
from yelp.staging.yelp_academic_dataset_review;


insert into tip
select
    recordjson:business_id,
    recordjson:date,
    recordjson:stars,
    recordjson:useful,
    recordjson:user_id
from yelp.staging.yelp_academic_dataset_tip;


insert into precipitation
select
    date,
    try_cast(precipitation as double),
    precipitation_normal
from yelp.staging.precipitation
where precipitation is not null;


insert into temperature
select
    date,
    min_temp,
    max_temp,
    normal_min_temp,
    normal_max_temp
from yelp.staging.temperature;