--Question 2
--count number of parking spots on a streat
DROP VIEW IF EXISTS spotsperstreet CASCADE;
CREATE VIEW spotsperstreet AS (
SELECT count(*) as numspots, stNAME
FROM ParkingSpots
GROUPBY stName);


-- spots and traffic light on each street 
DROP VIEW IF EXISTS spotsTL CASCADE;
CREATE VIEW  spotsTL AS(
SELECT trafficlightcount, numspots, streets.stName
FROM spotsperstreet, streets
WHERE spotsperstreet.stNAME = streets.stName);

-- also share spots
DROP VIEW IF EXISTS sharespotstl CASCADE;
CREATE VIEW sharespotstl AS(
SELECT spotsTL.trafficlightcount, numspots, streets.stName,
 bikeStationcount
FROM streets, spotsTL
WHERE spotsTL.stName = streets.stName);

\COPY (SELECT * FROM spotsTL) TO 'spotstl.csv' DELIMITER ',' CSV HEADER;

\COPY (SELECT * FROM sharespotsTL) TO 'sharespotstl.csv' DELIMITER ',' CSV HEADER;

-- regression analysis in R

-- do streets with a higher count of a certain type of parking spot have lower traffic
DROP VIEW IF EXISTS stnameSpottype CASCADE;
create VIEW stnameSpottype AS(
SELECT stName, type as spotType, county(type) as typecount
FROM ParkingSpots
GROUP BY stName, spotType)

DROP VIEW IF EXISTS spottypetraffic CASCADE;
create view spotypetraffic AS(
SELECT trafficCountAvg, spotType, typecount
FROM stnameSpottype, streets
WHERE streets.stName = stnameSpottype.stName);


\COPY (SELECT * FROM spottypetraffic) TO 'spottypetraffic.csv' DELIMITER ',' CSV HEADER;

-- Move over to R for analysis