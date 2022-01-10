-- SQL Data Definition Language (DDL)

--create audio_data database is postgres-----------

CREATE DATABASE IF NOT EXISTS audio_data;

--AUDIO TABLE----------------------------------

--import audio table from audio_df using .to_sql()

--cast datatypes to integer
ALTER TABLE audio 
ALTER COLUMN artist_id 
TYPE integer USING artist_id::integer;

ALTER TABLE audio 
ALTER COLUMN year_formed 
TYPE integer USING year_formed::integer;

--set columns that will be used as primary keys to NOT NULL
ALTER TABLE artist 
ALTER COLUMN artist_id SET NOT NULL;

--LOCATION_INFO TABLE -------------------------------

--set country_code column to NOT NULL
ALTER TABLE location_info 
ALTER COLUMN country_code SET NOT NULL;

--alter table to create country_code primary key
ALTER TABLE location_info 
DROP CONSTRAINT IF EXISTS location_info_pkey

ALTER TABLE location_info 
ADD PRIMARY KEY (country_code);

--ARTIST TABLE -------------------------------

--create table from main table
CREATE TABLE IF NOT EXISTS artist 
AS SELECT artist_id, artist_name, gender, member_count 
FROM audio;

--alter table to create artist_id primary key
ALTER TABLE artist 
DROP CONSTRAINT IF EXISTS artist_pkey

ALTER TABLE artist 
ADD PRIMARY KEY (artist_id);


--ARTIST INFO TABLE---------------------------

--create table from main table
CREATE TABLE IF NOT EXISTS artist_info 
AS SELECT artist_id, country_code, genre, year_formed, year_disbanded, label 
FROM audio;

--alter table to create artist_id primary key
ALTER TABLE artist_info 
DROP CONSTRAINT IF EXISTS artist_info_pkey

ALTER TABLE artist_info 
ADD PRIMARY KEY (artist_id);


--drop redundant audio table-------------------------------

DROP TABLE IF EXISTS audio;


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--SQL Data Manipulation Language (DML)

--Query1: 
SELECT country_name, genre, COUNT(genre) AS genre_count
FROM location
INNER JOIN artist_info
ON location.country_code = artist_info.country_code
GROUP BY genre, country_name
ORDER BY genre_count DESC

--Query2: 
SELECT COUNT(artist_name) AS artist_count, year_formed
FROM artist
INNER JOIN artist_info 
ON artist.artist_id = artist_info.artist_id
GROUP BY year_formed
ORDER BY artist_count DESC;

--Query3: 
SELECT DISTINCT artist_name, year_formed
FROM artist
INNER JOIN artist_info
ON artist.artist_id = artist_info.artist_id
WHERE year_formed
BETWEEN ‘1990’ AND ‘1999’
ORDER BY year_formed DESC;