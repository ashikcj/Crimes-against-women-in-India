CREATE DATABASE against_women;

USE against_women;
CREATE TABLE crimes_against_women
(id INT PRIMARY KEY, State VARCHAR(70), Year_of_crime INT, sexual_crimes INT, dowry_deaths INT, violence_against_women INT,
crime_involving_force INT);

LOAD DATA INFILE 'Crimesagainst_womenproject.csv' INTO TABLE crimes_against_women
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM crimes_against_women;

SELECT * FROM crimes_against_women;

-- top 10state with highest crime against women from 2001 to 2011

SELECT State, SUM(sexual_crimes + dowry_deaths + violence_against_women + crime_involving_force) AS crimes
FROM crimes_against_women
GROUP BY State
ORDER BY crimes DESC
LIMIT 10;

-- Which year has the most number of crimes.

SELECT year_of_crime, SUM(sexual_crimes + dowry_deaths + violence_against_women + crime_involving_force) AS crimes
FROM crimes_against_women
GROUP BY year_of_crime
ORDER BY crimes DESC
LIMIT 5;

-- Compare between the dowry deaths in 2001 and 2021

WITH CTE AS
(SELECT year_of_crime, SUM(sexual_crimes + dowry_deaths + violence_against_women + crime_involving_force) AS crimes
FROM crimes_against_women
GROUP BY year_of_crime),
CTE2 AS
(SELECT year_of_crime,
SUM(case when year_of_crime=2001 then crimes else 0 end) AS crime_2001,
SUM(case when year_of_crime=2021 then crimes else 0 end) AS crime_2021
FROM CTE
GROUP BY year_of_crime)
SELECT * FROM CTE2
WHERE year_of_crime= 2001 OR year_of_crime= 2021;

-- 10 th state with higest crimes 

SELECT State, 
SUM(sexual_crimes + dowry_deaths + violence_against_women + crime_involving_force) AS crimes
FROM crimes_against_women
GROUP BY State
ORDER BY crimes DESC
LIMIT 1 OFFSET 9;

-- which state/union territory has lowest dowry death and sexual crimes

SELECT State, SUM(dowry_deaths + sexual_crimes) AS ds
FROM crimes_against_women
GROUP BY State
ORDER BY ds 
LIMIT 1;

-- compare between sexual_crimes in lakshdweep and uttarpradesh
WITH CTE AS
(SELECT State, SUM(dowry_deaths + sexual_crimes ) AS sc
FROM crimes_against_women
GROUP BY State)
, CTE2 AS
(SELECT State,
SUM(case when State='LAKSHADWEEP' then sc else 0 end) AS lakshdweep_sc,
SUM(case when State='UTTAR PRADESH' then sc else 0 end) AS uttar_sc
FROM CTE
GROUP BY State)
SELECT * FROM CTE2
WHERE State='LAKSHADWEEP' OR State='UTTAR PRADESH';
