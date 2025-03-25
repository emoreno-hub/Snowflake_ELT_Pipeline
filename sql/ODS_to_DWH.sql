USE WAREHOUSE COMPUTE_WH;
USE DATABASE YELP;
USE SCHEMA DWH;

// create temperature dimension table and insert data
create or replace table dim_temperature(
    date date primary key,
    min_temp double,
    max_temp double,
    normal_min_temp double,
    normal_max_temp double
);

insert into yelp.dwh.dim_temperature
select
    date,
    min_temp,
    max_temp,
    normal_min_temp,
    normal_max_temp
from yelp.ods.temperature;

// create precipitation dimension table and insert data
create or replace table dim_precipitation(
    date date primary key,
    precipitation string,
    precipitation_normal double
);

insert into yelp.dwh.dim_precipitation
select
    date,
    precipitation,
    precipitation_normal
from yelp.ods.precipitation;

// create business dimension table and insert data
create or replace table dim_business(
    business_id string primary key,
    name string,
    address string,
    city string,
    state string,
    review_count double,
    star_rating double
);

insert into dim_business
select
    business_id,
    name,
    address,
    city,
    state,
    review_count,
    stars
from yelp.ods.business;


// create fact_reviews and insert data
create or replace table dim_user(
    user_id string primary key,
    name string,
    average_stars double,
    review_count integer,
    useful_votes_count integer,
    yelping_since date
);

insert into yelp.dwh.dim_user
select
    user_id,
    name,
    average_stars,
    review_count,
    useful,
    yelping_since
from yelp.ods.user;


// create fact table and insert data
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
    
insert into fact_reviews
select
    r.review_id,
    r.business_id,
    u.user_id,
    r.review_date,
    r.stars,
    r.useful,
    r.cool_votes,
    r.funny_votes
from yelp.ods.review as r
join yelp.ods.user as u
    on r.user_id = u.user_id;