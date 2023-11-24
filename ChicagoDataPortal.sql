-- Problem 1: Find the total number of crimes recorded in the CRIME table.
SELECT 
	COUNT(*) AS TOTAL_NUMBER_OF_CRIMES
FROM 
	ChicagoCrimeData;

-- Problem 2: List community areas with per capita income less than 11000.
SELECT
	COMMUNITY_AREA_NUMBER,
	COMMUNITY_AREA_NAME,
	PER_CAPITA_INCOME
FROM
	ChicagoCensusData
WHERE
	PER_CAPITA_INCOME < 11000
ORDER BY 3 DESC;

-- Problem 3: List all case numbers for crimes involving minors?
SELECT
	CASE_NUMBER,
	YEAR(GETDATE()) - YEAR AS AGE
FROM 
	ChicagoCrimeData
WHERE 
	(YEAR(GETDATE()) - YEAR) < 18;

-- Problem 4: List all kidnapping crimes involving a child?(children are not considered minors for the purposes of crime analysis)
SELECT
	*
FROM
	ChicagoCrimeData
WHERE
	DESCRIPTION LIKE '%KIDNAPPING%' OR DESCRIPTION LIKE '%CHILD%';

-- Problem 5: What kind of crimes were recorded at schools?
SELECT
	DISTINCT(PRIMARY_TYPE)
FROM
	ChicagoCrimeData
WHERE 
	LOCATION_DESCRIPTION LIKE '%School%';

-- Problem 6: List the average safety score for all types of schools.
SELECT 
	Elementary_Middle_or_High_School,
	AVG(SAFETY_SCORE) as Average_safety_score
FROM
	ChicagoPublicSchools
WHERE 
	SAFETY_SCORE IS NOT NULL
GROUP BY Elementary_Middle_or_High_School
ORDER BY 2;

-- Problem 7: List 5 community areas with highest % of households below poverty line.
SELECT
	TOP(5) COMMUNITY_AREA_NAME,
	PERCENT_HOUSEHOLDS_BELOW_POVERTY
FROM 
	ChicagoCensusData
ORDER BY PERCENT_HOUSEHOLDS_BELOW_POVERTY DESC;

-- Problem 8: Which community area(number) is most crime prone?
SELECT
	TOP(1) ccs.COMMUNITY_AREA_NUMBER,
	COUNT(CASE_NUMBER) AS TOTAL_CASE
FROM
	ChicagoCrimeData ccr JOIN ChicagoCensusData ccs
	ON ccr.COMMUNITY_AREA_NUMBER = ccs.COMMUNITY_AREA_NUMBER
WHERE 
	ccs.COMMUNITY_AREA_NUMBER IS NOT NULL
GROUP BY ccs.COMMUNITY_AREA_NUMBER
ORDER BY 2 DESC

-- Problem 9: Use a sub-query to find the name of the community area with highest hardship index.
SELECT 
	COMMUNITY_AREA_NAME
FROM
	ChicagoCensusData
WHERE 
	HARDSHIP_INDEX =
	(SELECT
		MAX(HARDSHIP_INDEX)
	FROM
		ChicagoCensusData
	WHERE HARDSHIP_INDEX IS NOT NULL)
ORDER BY HARDSHIP_INDEX DESC

-- Problem 10: Use a sub-query to determine the Community Area Name with most number of crimes?
SELECT 
	TOP(1) COMMUNITY_AREA_NAME
FROM
	(SELECT
		ccs.COMMUNITY_AREA_NAME,
		COUNT(CASE_NUMBER) AS TOTAL_CASE
	FROM
		ChicagoCrimeData ccr JOIN ChicagoCensusData ccs
		ON ccr.COMMUNITY_AREA_NUMBER = ccs.COMMUNITY_AREA_NUMBER
	WHERE 
		ccs.COMMUNITY_AREA_NUMBER IS NOT NULL
	GROUP BY ccs.COMMUNITY_AREA_NAME) SUB
ORDER BY TOTAL_CASE DESC