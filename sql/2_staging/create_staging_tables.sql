use warehouse compute_wh;
use database YELP;
use schema STAGING;

-- staging create tables
CREATE OR REPLACE TABLE yelp_academic_dataset_business(recordjson variant);
CREATE OR REPLACE TABLE yelp_academic_dataset_checkin(recordjson variant);
CREATE OR REPLACE TABLE yelp_academic_dataset_covid_features(recordjson variant);
CREATE OR REPLACE TABLE yelp_academic_dataset_review(recordjson variant);
CREATE OR REPLACE TABLE yelp_academic_dataset_tip(recordjson variant);
CREATE OR REPLACE TABLE yelp_academic_dataset_user(recordjson variant);

CREATE OR REPLACE precipitation (
    DATE DATE,
    PRECIPITATION STRING,
    PRECIPITATION_NORMAL STRING
);

CREATE OR REPLACE TABLE temperature (
    DATE DATE,
    MIN_TEMP DOUBLE,
    MAX_TEMP DOUBLE,
    NORMAL_MIN_TEMP DOUBLE,
    NORMAL_MAX_TEMP DOUBLE