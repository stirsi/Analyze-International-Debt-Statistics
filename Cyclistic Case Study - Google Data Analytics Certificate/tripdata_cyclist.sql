-- general look at the data
select * 
from tripdata_202301
limit 50

-- adding columns of ride_length and day_of_week
alter table tripdata_202301
add column ride_length INTERVAL, day_of_week VARCHAR

-- calculate ride length values
update tripdata_202301
set ride_length = ended_at - started_at

-- convert day of week value to actual day name
update tripdata_202301
set day_of_week = to_char(started_at, 'Day')

-- average monthly ride lengths by rider type
select extract(month from started_at) as month,
	member_casual, 
	avg(ride_length)
from tripdata_202301
group by member_casual, month
order by month

-- median ride length and average ride length
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY ride_length) as median_ride_length,
	AVG(ride_length) as average_ride_length
FROM tripdata_202301

-- median ride length and average ride length by rider type
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY ride_length) as median_ride_length,
	AVG(ride_length) as average_ride_length,
	member_casual
FROM tripdata_202301
group by member_casual
order by member_casual

-- median ride length by month and rider type
SELECT extract(month from started_at) as month,
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY ride_length) as median_ride_length,
	member_casual
FROM tripdata_202301
group by member_casual, month
order by member_casual

-- median ride length by bike type and rider type
SELECT rideable_type as bike_type,
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY ride_length) as median_ride_length,
	member_casual
FROM tripdata_202301
group by member_casual, bike_type
order by member_casual

-- average and max ride length by month and rider type
select extract(month from started_at) as month,
	member_casual, 
	avg(ride_length), 
	max(ride_length), 
	day_of_week
from tripdata_202301
group by member_casual, month, day_of_week
order by month

-- average and max ride length by rider type
select member_casual, max(ride_length), avg(ride_length)
from tripdata_202301
group by member_casual

-- ride count by member type
select count(ride_id),
	member_casual
from tripdata_202301
group by member_casual

-- practice and check to convert day of week to actual day name
select started_at, 
	extract (dow from started_at),
	to_char(started_at, 'Day')
from tripdata_202301
order by started_at desc
limit 100

-- update day_of_week column to actual day name
update tripdata_202301
set day_of_week = to_char(started_at, 'Day')


--see if the update worked
select * 
from tripdata_202301
order by started_at desc
limit 50

-- count the total rows
select count(*)
from tripdata_202301

-- check distinct bike types
select distinct rideable_type
from tripdata_202301

-- count rows with end station names are null
-- I used versions of this code to check for null values for other column too
select count(*)
from tripdata_202301
where end_station_name IS NULL

-- ride counts by day and member type
select day_of_week,
	member_casual, 
	count(*)
from tripdata_202301
group by member_casual, day_of_week
order by member_casual

-- ride count by bike type and member type
select rideable_type,
	member_casual, 
	count(*)
from tripdata_202301
group by member_casual, rideable_type
order by member_casual

-- avergae ride length by bike type and rider type
select rideable_type,
	member_casual, 
	avg(ride_length)
from tripdata_202301
group by member_casual, rideable_type
order by member_casual

-- daily median ride length per rider type
select day_of_week,
	member_casual, 
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY ride_length) as median_ride_length
from tripdata_202301
group by member_casual, day_of_week
order by member_casual

-- daily average ride length per rider type
select day_of_week,
	member_casual, 
	AVG(ride_length) as average_ride_length
from tripdata_202301
group by member_casual, day_of_week
order by member_casual

-- hourly average ride length by rider type
select extract(hour from started_at) as hour_of_day,
	member_casual, 
	avg(ride_length)
from tripdata_202301
group by member_casual, hour_of_day
order by member_casual

-- hourly median ride length by rider type
select extract(hour from started_at) as hour_of_day,
	member_casual, 
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY ride_length) as median_ride_length
from tripdata_202301
group by member_casual, hour_of_day
order by hour_of_day


-- create season column and assign values
update tripdata_202301
set season = case when extract(month from started_at) in (3,4,5) then 'Spring'
				when extract(month from started_at) in (6,7,8) then 'Summer'
				when extract(month from started_at) in (9,10,11) then 'Fall'
				else 'Winter' END

-- ride count by season and rider type
select season,
	member_casual, 
	count(*)
from tripdata_202301
group by member_casual, season
order by member_casual

-- average ride length by season and rider type
select season,
	member_casual, 
	avg(ride_length)
from tripdata_202301
group by member_casual, season
order by member_casual

-- median ride length by season and rider type
select season,
	member_casual, 
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY ride_length) as median_ride_length
from tripdata_202301
group by member_casual, season
order by member_casual

-- ride count by quarter and rider type
select extract(quarter from started_at) as quarter,
	count(*),
	member_casual
from tripdata_202301
group by member_casual, quarter
order by member_casual

-- average ride length by quarter and rider type
select extract(quarter from started_at) as quarter,
	avg(ride_length),
	member_casual
from tripdata_202301
group by member_casual, quarter
order by member_casual

-- most popular start stations by rider type
select 
	start_station_name, 
	count(*),
	member_casual
from 
	tripdata_202301
group by start_station_name, member_casual
order by count(*) desc
limit 20

-- most popular 20 start stations
select 
	start_station_name, 
	count(*)
from 
	tripdata_202301
group by start_station_name
order by count(*) desc
limit 20

-- export the table to a csv file 
COPY (SELECT * FROM tripdata_202301) TO 'C:\Documents_Not_Syncing\Google Data Analysis Course\Case Study 1\output.csv' WITH CSV HEADER;
