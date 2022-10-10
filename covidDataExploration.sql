/*loading covid deaths and vaccination  data*/
SELECT * FROM covid_deaths
SELECT * FROM covid_vaccination

/*selecting needed columns from covid deaths*/

SELECT continent, location,date, total_cases,new_cases,total_deaths,population FROM covid_deaths
WHERE continent IS NOT null
ORDER BY location, date;

/*looking into total cases by total deaths(percentage possiblity of dying if infected*/

SELECT continent, location,total_cases,total_deaths,population, (total_deaths/total_cases)*100 
AS death_percentage FROM covid_deaths
ORDER BY 1,2;


/*looking at total cases by population( showing % of population that got infected*/

SELECT  location,date, total_cases,population, (total_cases/population)*100 
AS infected_population_percentage FROM covid_deaths
ORDER BY 1,2;

/*countries with highest infected rate to population*/

SELECT location, population,MAX(total_cases) AS highest_infected_rate, MAX(total_cases/population)*100 
AS infected_population_percentage FROM covid_deaths
GROUP BY location, population
ORDER BY 4 desc


/* looking at countries with highest death count by population*/

SELECT location, population,MAX(total_deaths) AS total_death_counts FROM covid_deaths
WHERE continent is null
GROUP BY location, population
ORDER BY 3 desc


/*looking at continent by highest death count*/

SELECT continent, population,MAX(total_deaths) AS total_death_counts FROM covid_deaths
WHERE continent IS NOT null
GROUP BY continent, population
ORDER BY 3 desc

/* looking at global values for all cases and deaths*/

SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths)
total_deaths FROM covid_deaths
WHERE continent IS NOT null
GROUP BY date
ORDER BY 1


/*global death percentage*/

SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths)
total_deaths, SUM(new_deaths)/SUM(new_cases)AS percentage_global_death FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1

/*overall total cases and deaths*/
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths)
total_deaths FROM covid_deaths
WHERE continent is NOT null
ORDER BY 1




/*joining the covid death and vaccination table  and extracting columns*/

SELECT covid_deaths.location,covid_deaths.continent,covid_deaths.population, 
covid_deaths.date, covid_vaccination.new_vaccinations
FROM covid_deaths
JOIN covid_vaccination
ON covid_deaths.location = covid_vaccination.location
AND covid_deaths.date = covid_vaccination.date
WHERE covid_deaths.continent IS NOT null
ORDER BY 1,2

/*creating rolling count of vaccinated ppl using partitioning*/


SELECT covid_deaths.location,covid_deaths.continent,covid_deaths.population, 
covid_deaths.date, covid_vaccination.new_vaccinations, SUM(covid_vaccination.new_vaccinations)OVER (partition by covid_deaths.location ORDER by covid_deaths.location,covid_deaths.date)AS rolling_counts_VaccinatedPPL
FROM covid_deaths
JOIN covid_vaccination
ON covid_deaths.location = covid_vaccination.location
AND covid_deaths.date = covid_vaccination.date
WHERE covid_deaths.continent IS NOT null
ORDER BY 1,2


/* creating percentage of people vaccinated using temporary table*/


CREATE TABLE Percentage_Population_vaccinated
(
 location text,
 continent text,
 population numeric,
 date date,
 new_vaccination numeric,
 rolling_counts_VaccinatedPPL numeric
)
INSERT INTO Percentage_Population_vaccinated
SELECT covid_deaths.location,covid_deaths.continent,covid_deaths.population, 
covid_deaths.date, covid_vaccination.new_vaccinations, SUM(covid_vaccination.new_vaccinations)OVER (partition by covid_deaths.location ORDER by covid_deaths.location,covid_deaths.date)AS rolling_counts_VaccinatedPPL
FROM covid_deaths
JOIN covid_vaccination
ON covid_deaths.location = covid_vaccination.location
AND covid_deaths.date = covid_vaccination.date
WHERE covid_deaths.continent IS NOT null

SELECT *,(rolling_counts_VaccinatedPPL/population)*100 AS percentage_ppl_vaccinated FROM Percentage_Population_vaccinated





CREATE VIEW Percentage_Population_vaccinated AS SELECT covid_deaths.location,covid_deaths.continent,covid_deaths.population, 
covid_deaths.date, covid_vaccination.new_vaccinations, SUM(covid_vaccination.new_vaccinations)OVER (partition by covid_deaths.location ORDER by covid_deaths.location,covid_deaths.date)AS rolling_counts_VaccinatedPPL
FROM covid_deaths
JOIN covid_vaccination
ON covid_deaths.location = covid_vaccination.location
AND covid_deaths.date = covid_vaccination.date
WHERE covid_deaths.continent IS NOT null