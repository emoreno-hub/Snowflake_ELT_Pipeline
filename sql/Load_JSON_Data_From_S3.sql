// Create json file format object
CREATE OR REPLACE file format YELP.STAGING.json_fileformat
    type='JSON'
    COMPRESSION = 'AUTO'
    strip_outer_array=true;
    
// Create a stage object with S3 integration object & json file format object
CREATE OR REPLACE stage external_json_stage
    URL = 's3://yelp-weather-project'
    STORAGE_INTEGRATION = s3_int
    FILE_FORMAT = json_fileformat;


// create tables
CREATE OR REPLACE TABLE yelp_academic_dataset_business(recordjson variant);
CREATE OR REPLACE TABLE yelp_academic_dataset_checkin(recordjson variant);
CREATE OR REPLACE TABLE yelp_academic_dataset_covid_features(recordjson variant);
CREATE OR REPLACE TABLE yelp_academic_dataset_review(recordjson variant);
CREATE OR REPLACE TABLE yelp_academic_dataset_tip(recordjson variant);
CREATE OR REPLACE TABLE yelp_academic_dataset_user(recordjson variant);
    

// Load data from S3 external stage into staging tables
COPY INTO YELP.STAGING.YELP_ACADEMIC_DATASET_COVID_FEATURES
    FROM @external_json_stage/yelp_academic_dataset_covid_features.json.gz
    ON_ERROR = 'skip_file';


COPY INTO YELP.STAGING.YELP_ACADEMIC_DATASET_BUSINESS
    FROM @external_json_stage/yelp_academic_dataset_business.json.gz
    ON_ERROR = 'skip_file';

COPY INTO YELP.STAGING.YELP_ACADEMIC_DATASET_CHECKIN
    FROM @external_json_stage/yelp_academic_dataset_checkin.json.gz
    ON_ERROR = 'skip_file';

COPY INTO YELP.STAGING.YELP_ACADEMIC_DATASET_REVIEW
    FROM @external_json_stage/yelp_academic_dataset_review.json.gz
    ON_ERROR = 'skip_file';


COPY INTO YELP.STAGING.YELP_ACADEMIC_DATASET_TIP
    FROM @external_json_stage/yelp_academic_dataset_tip.json.gz
    ON_ERROR = 'skip_file';

// Load data into covid user table
COPY INTO YELP.STAGING.YELP_ACADEMIC_DATASET_USER
    FROM @external_json_stage/yelp_academic_dataset_user.json.gz
    ON_ERROR = 'skip_file';