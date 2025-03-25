use warehouse compute_wh;

-- create json file format object
CREATE OR REPLACE file format YELP.STAGING.json_fileformat
    type='JSON'
    COMPRESSION = 'AUTO'
    strip_outer_array=true;

-- create csv file format object
CREATE OR REPLACE file format YELP.STAGING.csv_fileformat
    type='CSV'
    compression='auto'
    field_delimiter=','
    record_delimiter = '\n'
    skip_header=1
    error_on_column_count_mismatch=true
    null_if = ('NULL', 'null')
    empty_field_as_null = true;
    
-- create a stages
CREATE OR REPLACE stage external_json_stage
    URL = 's3://yelp-weather-project'
    STORAGE_INTEGRATION = s3_int
    FILE_FORMAT = json_fileformat;

CREATE OR REPLACE stage my_csv_stage
    FILE_FORMAT = csv_fileformat;