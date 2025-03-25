USE WAREHOUSE COMPUTE_WH;
USE DATABASE YELP;
USE SCHEMA ODS;

-- yelp business table
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

- yelp checkin table
create or replace table checkin(
    business_id string primary key references business(business_id),
    date date
);

-- yelp covid features table
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


-- yelp user table
create or replace table user(
    user_id string primary key,
    name string,
    average_stars double,
    review_count integer,
    useful integer,
    yelping_since date
);


-- yelp review table
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

-- yelp tip table
create or replace table tip(
    business_id string primary key references business(business_id),
    tip_date date,
    stars double,
    useful double,
    user_id string references user(user_id)
);

-- weather precipitation table
create or replace table precipitation(
    date date primary key,
    precipitation double,
    precipitation_normal double   
);

-- weather temperature table
create or replace table temperature(
    date date primary key,
    min_temp double,
    max_temp double,
    normal_min_temp double,
    normal_max_temp double
);