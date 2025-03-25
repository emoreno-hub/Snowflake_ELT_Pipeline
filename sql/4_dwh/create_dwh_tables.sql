USE WAREHOUSE COMPUTE_WH;
USE DATABASE YELP;
USE SCHEMA DWH;


-- dimension temperature dimension
create or replace table dim_temperature(
    date date primary key,
    min_temp double,
    max_temp double,
    normal_min_temp double,
    normal_max_temp double
);


-- dimension precipitation table
create or replace table dim_precipitation(
    date date primary key,
    precipitation string,
    precipitation_normal double
);


-- dimension business table
create or replace table dim_business(
    business_id string primary key,
    name string,
    address string,
    city string,
    state string,
    review_count double,
    star_rating double
);


-- dimension user table
create or replace table dim_user(
    user_id string primary key,
    name string,
    average_stars double,
    review_count integer,
    useful_votes_count integer,
    yelping_since date
);

-- fact table for reviews
create or replace table fact_reviews(
    review_id string primary key,
    business_id string,
    user_id string,
    review_date date,
    star_rating double,
    useful_votes double,
    cool_votes number,
    funny_votes number,
constraint fk_business_id foreign key (business_id) references yelp.ods.business (business_id),
constraint fk_user_id foreign key (user_id) references yelp.ods.user (user_id)
);