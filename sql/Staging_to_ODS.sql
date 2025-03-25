USE WAREHOUSE COMPUTE_WH;
USE DATABASE YELP;
USE SCHEMA ODS;

// create business table and insert data
create or replace table business(
    business_id string primary key,
    name string,
    is_open string,
    address string,
    city string,
    state string,
    postal_code string,
    longitude double,
    latitude double,
    review_count double,
    stars double
    );

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
    
    

// create checkin table and insert data
create or replace table checkin(
    business_id string primary key references business(business_id),
    date date
);

-- date column contains an array of dates and flatten is used to flatten into multiple rows
insert into checkin
select
    recordjson:business_id,
    d.value::date
from yelp.staging.yelp_academic_dataset_checkin,
lateral flatten(INPUT=>SPLIT(recordjson:date, ', ')) d;


// create covid features table and insert data
create or replace table covid_features(
    business_id string primary key references business(business_id),
    call_to_action string,
    grubhub_enabled string,
    request_quote string,
    temporary_closed_until string,
    virtual_services_offered string,
    delivery_takeout_offered string,
    highlights string
);

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
    

// create user table and insert data
create or replace table user(
    user_id string primary key,
    name string,
    average_stars double,
    review_count integer,
    useful integer,
    yelping_since date
);

insert into user
select
    recordjson:user_id,
    recordjson:name,
    recordjson:average_stars,
    recordjson:review_count,
    recordjson:useful,
    recordjson:yelping_since
from yelp.staging.yelp_academic_dataset_user;


// create review table
create or replace table review(
    review_id string primary key,
    business_id string references business(business_id),
    review_date date,
    cool_votes integer,
    funny_votes integer,
    stars integer,
    useful integer,
    user_id string,
constraint fk1_review_date foreign key (review_date) references yelp.ods.temperature (date),
constraint fk2_review_date foreign key (review_date) references yelp.ods.precipitation (date)
);

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


// create tip table
create or replace table tip(
    business_id string primary key references business(business_id),
    tip_date date,
    stars double,
    useful double,
    user_id string references user(user_id)
);

insert into tip
select
    recordjson:business_id,
    recordjson:date,
    recordjson:stars,
    recordjson:useful,
    recordjson:user_id
from yelp.staging.yelp_academic_dataset_tip;


// create precipitation table and insert data
create or replace table precipitation(
    date date primary key,
    precipitation double,
    precipitation_normal double   
);

insert into precipitation
select
    date,
    try_cast(precipitation as double),
    precipitation_normal
from yelp.staging.precipitation
where precipitation is not null;


// create temperature table and insert data
create or replace table temperature(
    date date primary key,
    min_temp double,
    max_temp double,
    normal_min_temp double,
    normal_max_temp double
);

insert into temperature
select
    date,
    min_temp,
    max_temp,
    normal_min_temp,
    normal_max_temp
from yelp.staging.temperature;

