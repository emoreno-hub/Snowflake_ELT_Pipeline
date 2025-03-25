-- load yelp data from S3 external stage into staging tables
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

-- load weather data into staging tables
COPY INTO YELP.STAGING.PRECIPITATION
FROM @my_csv_stage/usw00023169-las-vegas-mccarran-intl-ap-precipitation-inch.csv.gz
FILE_FORMAT = csv_fileformat
ON_ERROR = 'CONTINUE'
PURGE = TRUE;

COPY INTO YELP.STAGING.TEMPERATURE
FROM @my_csv_stage/usw00023169-temperature-degreef.csv.gz
FILE_FORMAT = csv_fileformat
ON_ERROR = 'CONTINUE'
PURGE = TRUE;
