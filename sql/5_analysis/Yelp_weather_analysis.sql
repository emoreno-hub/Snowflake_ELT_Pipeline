use database yelp;
use schema dwh;

select
    b.name as business,
    avg(f.star_rating) as avg_star_rating,
    f.review_date,
    t.min_temp,
    t.max_temp,
    p.precipitation
from fact_reviews as f
join dim_business as b
    on f.business_id = b.business_id
join dim_temperature as t
    on f.review_date = t.date
join dim_precipitation as p
    on f.review_date = p.date
group by
    b.name,
    f.review_date,
    t.min_temp,
    t.max_temp,
    p.precipitation;
