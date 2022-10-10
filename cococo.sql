SELECT * FROM covid_deaths


SELECT covid_deaths.location,covid_deaths.continent,covid_deaths.population, 
covid_deaths.date, covid_vaccination.new_vaccinations
FROM covid_deaths
JOIN covid_vaccination
ON covid_deaths.location = covid_vaccination.location
AND covid_deaths.date = covid_vaccination.date
WHERE covid_deaths.continent IS NOT null


SELECT covid_deaths.location,covid_deaths.continent,covid_deaths.population, 
covid_deaths.date, covid_vaccination.new_vaccinations, SUM(covid_vaccination.new_vaccinations)OVER (partition by covid_deaths.location ORDER by covid_deaths.location,covid_deaths.date)AS rolling_counts_VaccinatedPPL
FROM covid_deaths
JOIN covid_vaccination
ON covid_deaths.location = covid_vaccination.location
AND covid_deaths.date = covid_vaccination.date
WHERE covid_deaths.continent IS NOT null



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