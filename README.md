# Yelp & Weather ELT Pipeline Using Snowflake
End-to-end ELT data pipeline that ingests Yelp and weather data, stages it in Snowflake, and prepares it for analytics

## Overview
This portfolio project demonstrates an end-to-end ELT data pipeline designed to integrate and analyze Yelp and weather datasets. It simulates a real-world cloud-based architecture using AWS S3, Snowflake, and Power BI, following industry-standard data modeling practices across staging, operational, and analytics layers.

## Architecture


## Tools & Technologies
- **Snowflake** – Cloud data warehouse for data modeling and analytics
- **AWS S3** – External stage for raw JSON data ingestion
- **SnowSQL CLI** – For uploading local files to internal Snowflake stages
- **SQL** – Used for all data loading and transformation logic

## ELT Workflow
1. Extract:
Yelp data (.json.gz) and weather data (.csv) sourced from local machine.

2. Load:
- Yelp data uploaded to AWS S3 and ingested into Snowflake via an external stage.
- Weather data loaded directly via internal Snowflake stage using SQL.

3. Transform:
- Data loaded into staging tables, then modeled into an operational data store (ODS).
- Final business logic applied in the data warehouse (DWH) layer through SQL joins and preparation for reporting.

4. Visualize:
- Power BI connects to the DWH layer to visualize business insights (e.g., impact of weather/COVID on Yelp businesses).

### Prerequisites
- Snowflake account - requires role, database, warehouse, and schema permissions
- SnowSQL CLI - used to upload local files to internal Snowflake stage
- AWS S3 bucket- used to load files to external Snowflake stage

### SnowSQL CLI Configuration
Create a [SnowSQL](https://docs.snowflake.com/en/user-guide/snowsql) connection profile:
```bash
# ~/.snowsql/config

[connections.my_project]
accountname = <your_account>.snowflakecomputing.com
username = <your_username>
password = <your_password>
dbname = <your_database>
schemaname = <your_schema>
warehousename = <your_warehouse>
rolename = <your_role>
```
Connect using:
```bash
snowsql -c my_project
```


## How to Run
### Step 1: Upload Yelp Data to AWS S3

```bash
aws s3 cp ./data/yelp/ s3://your-bucket-name/yelp/ --recursive
```

### Step 2: Create External Stage in Snowflake (for Yelp JSON files)
In Snowflake, run the following SQL to set up a JSON file format and the external stage:
```bash
-- Step 1: Create a JSON file format
CREATE OR REPLACE FILE FORMAT YELP.STAGING.json_fileformat
    TYPE = 'JSON'
    COMPRESSION = 'AUTO'
    STRIP_OUTER_ARRAY = TRUE;

-- Step 2: Create external stage linked to S3 bucket
CREATE OR REPLACE STAGE external_json_stage
    URL = 's3://bucket-name'
    STORAGE_INTEGRATION = s3_int
    FILE_FORMAT = json_fileformat;
```
Note: s3_int refers to a Snowflake storage integration that must be preconfigured to securely access your S3 bucket.

### Step 3: Create Internal Stage for Weather CSV Files
```bash
put file:///path/to/usw00023169-las-vegas-mccarran-intl-ap-precipitation-inch.csv @my_csv_stage auto_compress=true;

put file:///path/to/usw00023169-temperature-degreef.csv @my_csv_stage auto_compress=true;
```
This command uploads the local CSV file directly to Snowflake’s internal stage.  Veriy upload:
```bash
snowsql -c my_project -q "LIST @my_csv_stage;"
```

4. Run SQL Scripts in Order
You can execute the following in Snowflake Web UI or via SnowSQL:
