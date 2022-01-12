-- SQL Data Definition Language (DDL)

--create audio_data database is postgres-----------

CREATE DATABASE IF NOT EXISTS audio_data;


-- AUDIO TABLE DDL ----------------------------------

--alter the datatypes for columns that will be primary keys or are used for queries later
-- select table and column and cast desired type
ALTER TABLE audio 
ALTER COLUMN artist_id 
TYPE integer USING artist_id::integer;

ALTER TABLE audio 
ALTER COLUMN year_formed 
TYPE integer USING year_formed::integer;

ALTER TABLE audio 
ALTER COLUMN member_count 
TYPE integer USING member_count::integer;

--ensure that artist_id is not null before setting as primary key
ALTER TABLE audio 
ALTER COLUMN artist_id SET NOT NULL;



-- LOCATION_INFO TABLE DDL -------------------------------

--set country_code column to NOT NULL
ALTER TABLE location_info ALTER COLUMN country_code SET NOT NULL;

--alter table to create country_code primary key
ALTER TABLE location_info DROP CONSTRAINT IF EXISTS location_info_pkey;
ALTER TABLE location_info ADD PRIMARY KEY (country_code);

-- ARTIST TABLE DDL -------------------------------

--create artist table from audio table
CREATE TABLE IF NOT EXISTS artist 
AS SELECT artist_id, artist_name, gender, member_count 
FROM audio;

--alter table to create artist_id primary key
ALTER TABLE artist DROP CONSTRAINT IF EXISTS artist_pkey;
ALTER TABLE artist ADD PRIMARY KEY (artist_id);


--ARTIST INFO TABLE DDL---------------------------

--create artist_info table from audio table
CREATE TABLE IF NOT EXISTS artist_info 
AS SELECT artist_id, country_code, genre, year_formed, year_disbanded, label 
FROM audio;

--alter table to create artist_id primary key
ALTER TABLE artist_info 
DROP CONSTRAINT IF EXISTS artist_info_pkey;

ALTER TABLE artist_info 
ADD PRIMARY KEY (artist_id);


--drop redundant audio table-------------------------------

DROP TABLE IF EXISTS audio;


---------------------------------------------------------------------
---------------------------------------------------------------------

--SQL Data Manipulation Language (DML)

--Query1
--create a count of genres and select columns from location table
--join to artist_info table on country_code
--group and sort results in descending order
SELECT country_name, genre, COUNT(genre) AS genre_count 
FROM location_info 
INNER JOIN artist_info 
ON location_info.country_code = artist_info.country_code 
GROUP BY genre, country_name 
ORDER BY genre_count DESC;


--Query2
--create count of years formed from artist_info
--join artist to artist_info on artist_id column
--filter for member_count values > 1 and year_formed in range
--group results
--store results in in new table
SELECT COUNT(artist_info.year_formed) AS year_count 
INTO newtable 
FROM artist_info 
LEFT JOIN artist 
ON artist_info.artist_id = artist.artist_id 
WHERE artist.member_count > 1  
AND artist_info.year_formed BETWEEN 2009 AND 2019 
GROUP BY artist_info.year_formed;

--from new table, take average of year_count
SELECT ROUND(AVG(year_count), 2) 
FROM newtable;

--second part of question
--select count of year_formed
--from artist info
--joined to artist on artist_id
--filter for member_count > 1 and formed in 2020
SELECT COUNT(artist_info.year_formed) AS count_2020 
FROM artist_info 
LEFT JOIN artist 
ON artist_info.artist_id = artist.artist_id 
WHERE artist.member_count > 1 
AND artist_info.year_formed = 2020;

--drop intermediary table
DROP TABLE IF EXISTS newtable;

--Query 3
--seelct artist name and year formed from artist table
--joined to artist_info on artist_id column
--filter for year_formed in range
--order descending
SELECT DISTINCT artist_name, year_formed 
FROM artist 
INNER JOIN artist_info 
ON artist.artist_id = artist_info.artist_id 
WHERE year_formed BETWEEN 1990 AND 1999 
ORDER BY year_formed DESC;

--Query 4 
--select artist_name and year_formed from artist
--joined to artist_info on artist_id column
--filter for artist name starts with B, formed in 2000
SELECT artist_name, year_formed 
FROM artist 
INNER JOIN artist_info 
ON artist.artist_id = artist_info.artist_id 
WHERE artist_name LIKE 'B%' 
AND year_formed = '2000';

--Query 5
--select genre and a count of all genres
--from artist_info
--group by genre
--order by count, descending
SELECT genre, COUNT(*) AS amount 
FROM artist_info 
GROUP BY genre 
ORDER BY amount DESC LIMIT 4;

--Query 6
--select artist_name, country_code, year_formed
--from artist joined to artist_info on artist_id column
--and joined to location_info on country_code column
--filter for year_formed is 2000 and country is US
SELECT artist_name, li.country_code, year_formed 
FROM artist AS ar 
INNER JOIN artist_info AS ai 
ON ar.artist_id = ai.artist_id 
INNER JOIN location_info AS li 
ON ai.country_code = li.country_code 
WHERE year_formed = 2000 
AND li.country_code = 'US';