
/*Having created a database and tables, importation was done using COPY FROM function*/

COPY internationbrewery FROM 'C:\Users\user\Downloads\International_Breweries.csv' WITH CSV HEADER;

/* profits of anglophone and francophones region*/

SELECT * FROM InternationBrewery

SELECT brands, SUM(profit)from internationbrewery
GROUP BY brands
ORDER BY SUM(profit)desc;

/*comparing the profit generated btw anglophone and francophone territories*/

/*anglophone countries*/

SELECT countries, SUM(profit)from internationbrewery
WHERE countries IN ('Nigeria', 'Ghana')
GROUP BY countries;

/*franco countries*/

SELECT countries, SUM(profit)from internationbrewery
WHERE countries  NOT IN ('Nigeria', 'Ghana')
GROUP BY countries;

/* countries with highest profits in 2019*/

SELECT countries, SUM(profit) from internationbrewery
WHERE years = '2019'
GROUP BY countries
ORDER BY 2 DESC;


/* year with highest profit generated*/

SELECT SUM(profit), years from internationbrewery
GROUP BY years
order by 1 DESC
LIMIT 1;

/*month and year with least profits*/

SELECT months,years, SUM(profit)from internationbrewery
GROUP BY months, years
ORDER BY 2 ASC
LIMIT 1;


/*month with the least profit in 3 yrs*/

SELECT months, SUM(profit)from internationbrewery
GROUP BY months
ORDER BY 2 ASC
LIMIT 1;


/*minimum profit in the month of december and year 2018*/

SELECT months, MIN(profit)from internationbrewery
WHERE months ='December' and years = '2018'
GROUP BY months;

/*comparing profits in each month of 2019 in percentage*/

SELECT years, SUM(profit)from internationbrewery
WHERE years = '2019'
GROUP BY 1;

SELECT months, ROUND((SUM(profit)/30020250)*100,3) AS percentage_Profit from internationbrewery
WHERE years = '2019'
GROUP BY months;

/*top 5 brands with highest profits in senegal*/

SELECT brands, SUM(profit)FROM internationbrewery
WHERE countries = 'Senegal'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

/*getting top 3 brands within 2 previous yrs in in francophone countries*/

SELECT brands, SUM(quantity) FROM internationbrewery
WHERE years IN ('2019','2018') AND countries IN ('Togo','Senegal','Benin')
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

/*top 3 choices of brands consumed in ghana*/

SELECT brands, SUM(quantity) FROM internationbrewery
WHERE  countries = 'Ghana'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

/*top 3 best selling brands in nigeria, year 2019*/

SELECT brands, SUM(quantity) FROM internationbrewery
WHERE years = '2019' AND countries = 'Nigeria'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;


/*top 3 countries with higest beer consumption rate btw 2017 to 2019*/

SELECT countries, SUM(quantity) FROM internationbrewery
GROUP BY countries
ORDER BY 2 DESC
LIMIT 3;

/*Highest sales personell of budweiser in senegal*/

SELECT sales_rep, SUM(quantity) FROM internationbrewery
WHERE brands = 'budweiser' AND countries = 'Senegal'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


/*Top 3 countries with higest profit in 4th quater of 2019*/

SELECT countries, SUM(profit) FROM internationbrewery
WHERE months IN ('September','October','November', 'December') AND years = '2019'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

