USE WAREHOUSE COMPUTE_WH;
USE DATABASE YELP;
USE SCHEMA DWH;


insert into yelp.dwh.dim_temperature
select
    date,
    min_temp,
    max_temp,
    normal_min_temp,
    normal_max_temp
from yelp.ods.temperature;


insert into yelp.dwh.dim_precipitation
select
    date,
    precipitation,
    precipitation_normal
from yelp.ods.precipitation;


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


insert into yelp.dwh.dim_user
select
    user_id,
    name,
    average_stars,
    review_count,
    useful,
    yelping_since
from yelp.ods.user;


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
