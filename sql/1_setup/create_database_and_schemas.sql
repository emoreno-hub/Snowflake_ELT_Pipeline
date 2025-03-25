-- initiliaze the database and schema structure for the project

-- Create the Yelp project database
CREATE DATABASE IF NOT EXISTS YELP;

-- Switch to the Yelp database
USE DATABASE YELP;

-- Create schema for staging raw data
CREATE SCHEMA IF NOT EXISTS STAGING;

-- Create schema for the Operational Data Store (ODS) layer
CREATE SCHEMA IF NOT EXISTS ODS;

-- Create schema for the Data Warehouse (DWH) layer
CREATE SCHEMA IF NOT EXISTS DWH;