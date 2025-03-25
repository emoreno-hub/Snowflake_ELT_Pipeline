use warehouse compute_wh;
use database YELP;
use schema STAGING;

CREATE OR REPLACE file format YELP.STAGING.csv_fileformat
    type='CSV'
    compression='auto'
    field_delimiter=','
    record_delimiter = '\n'
    skip_header=1
    error_on_column_count_mismatch=true
    null_if = ('NULL', 'null')
    empty_field_as_null = true;


create or replace stage my_csv_stage file_format = csv_fileformat;


CREATE OR REPLACE TABLE YELP.STAGING.PRECIPITATION (
    DATE DATE,
    PRECIPITATION STRING,
    PRECIPITATION_NORMAL STRING
);

CREATE OR REPLACE TABLE YELP.STAGING.TEMPERATURE (
    DATE DATE,
    MIN_TEMP DOUBLE,
    MAX_TEMP DOUBLE,
    NORMAL_MIN_TEMP DOUBLE,
    NORMAL_MAX_TEMP DOUBLE
);

put file:///path/to/usw00023169-las-vegas-mccarran-intl-ap-precipitation-inch.csv @my_csv_stage auto_compress=true;

put file:///path/to/usw00023169-temperature-degreef.csv @my_csv_stage auto_compress=true;



copy into precipitation from @my_csv_stage/usw00023169-las-vegas-mccarran-intl-ap-precipitation-inch.csv.gz file_format=csv_fileformat ON_ERROR = 'CONTINUE' PURGE = TRUE;

copy into temperature from @my_csv_stage/usw00023169-temperature-degreef.csv.gz file_format=csv_fileformat ON_ERROR = 'CONTINUE' PURGE = TRUE;