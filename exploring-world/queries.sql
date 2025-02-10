USE world;
SHOW TABLES;

SELECT country.Name, countrylanguage.language
FROM country
join countrylanguage ON country.code = countrylanguage.CountryCode
WHERE countrylanguage.IsOfficial="T";

SELECT Name AS CityName, Population
FROM City
WHERE CountryCode = 'DEU';

SELECT Name AS CountryName, SurfaceArea
FROM Country
ORDER BY SurfaceArea ASC
LIMIT 5;

SELECT Name AS CountryName, Population
FROM Country
WHERE Population > 50000000
ORDER BY Population DESC;

SELECT Continent, AVG(LifeExpectancy) AS AvgLifeExpectancy
FROM Country
GROUP BY Continent;

SELECT Region, SUM(Population) AS TotalPopulation
FROM Country
GROUP BY Region;

SELECT c.Name AS CountryName, COUNT(ci.ID) AS CityCount
FROM Country c
JOIN City ci ON c.Code = ci.CountryCode
GROUP BY c.Name
ORDER BY CityCount DESC;

SELECT ci.Name AS CityName, c.Name AS CountryName, ci.Population
FROM City ci
JOIN Country c ON ci.CountryCode = c.Code
ORDER BY ci.Population DESC
LIMIT 10;
SELECT c.Name AS CountryName
FROM Country c
JOIN CountryLanguage cl ON c.Code = cl.CountryCode
WHERE cl.Language = 'French' AND cl.IsOfficial = 'T';

SELECT c.Name AS CountryName
FROM Country c
JOIN CountryLanguage cl ON c.Code = cl.CountryCode
WHERE cl.Language = 'English' AND cl.IsOfficial = 'F';

SELECT c.Name AS CountryName
FROM Country c
JOIN CountryPopulationHistory cph1 ON c.Code = cph1.CountryCode
JOIN CountryPopulationHistory cph2 ON c.Code = cph2.CountryCode
WHERE cph1.Year = YEAR(CURDATE()) - 50
  AND cph2.Year = YEAR(CURDATE())
  AND cph2.Population >= 3 * cph1.Population;
  WITH RankedCountries AS (
    SELECT 
        Continent, 
        Name AS CountryName, 
        GNP,
        RANK() OVER (PARTITION BY Continent ORDER BY GNP DESC) AS RichRank,
        RANK() OVER (PARTITION BY Continent ORDER BY GNP ASC) AS PoorRank
    FROM Country
)
SELECT Continent, CountryName, GNP, 'Richest' AS Status
FROM RankedCountries
WHERE RichRank = 1
UNION ALL

SELECT Continent, CountryName, GNP, 'Poorest' AS Status
FROM RankedCountries
WHERE PoorRank = 1;

SELECT Name AS CountryName, LifeExpectancy
FROM Country
WHERE LifeExpectancy < (SELECT AVG(LifeExpectancy) FROM Country);

SELECT ci.Name AS CapitalCity, c.Name AS CountryName, c.Population
FROM Country c
JOIN City ci ON c.Capital = ci.ID
WHERE c.Population > 100000000;

SELECT Continent, COUNT(*) AS CountryCount
FROM Country
GROUP BY Continent
ORDER BY CountryCount DESC
LIMIT 1;
