-- SQL Data Definition Language (DDL)
CREATE DATABASE IF NOT EXISTS audio_data;

--import audio table from audio_df using .to_sql()


--artist table DDL ------------------------

--create table from main table
CREATE TABLE artist AS
SELECT artist_id, artist_name, gender, member_count
FROM audio;

--alter artist_id column, is not null, must contain integers
ALTER TABLE artist
MODIFY artist_id int NOT NULL;

--alter table to create artist_id primary key
ALTER TABLE artist 
ADD PRIMARY KEY (artist_id);


--artist_info table DDL ------------------------

--create table from main table
CREATE TABLE IF NOT EXISTS artist_info AS
SELECT artist_id, country_code, genre, year_formed, year_disbanded, label
FROM audio;

--alter artist_id column, is not null, must contain integers
ALTER TABLE artist_info
MODIFY artist_id int NOT NULL;

--alter table to create artist_id primary key
ALTER TABLE artist_info 
ADD PRIMARY KEY (artist_id);


--location table DDL ------------------------

--create table from main table
CREATE TABLE IF NOT EXISTS location_info AS
SELECT country_code, country_name
FROM audio;

--alter country_code column is not null, must contain 2 letter code
ALTER TABLE location_info
MODIFY country_code CHAR(2) NOT NULL;

--alter table to create country_code primary key
ALTER TABLE location_info
ADD PRIMARY KEY (country_code);



-------------------------------------------------------------------------------

--SQL Data Manipulation Language (DML)

SELECT country_name, genre, COUNT(genre) AS genre_count
FROM location_info
INNER JOIN artist_info
ON location_info.country_code = artist_info.country_code
WHERE genre IS NOT NULL
GROUP BY genre, country_name
ORDER BY genre_count DESC;