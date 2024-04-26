-- Select Data that we are going to be starting with
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM public.dataexplore
WHERE continent IS NOT NULL 
ORDER BY location, date;

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
SELECT location, date, population, total_cases,  (total_cases/population)*100 AS percent_population_infected
FROM public.dataexplore
ORDER BY location, date;

-- Countries with Highest Infection Rate compared to Population
SELECT location, population, MAX(total_cases) AS highest_infection_count,  MAX((total_cases/population))*100 AS percent_population_infected
FROM public.dataexplore
GROUP BY location, population
ORDER BY percent_population_infected DESC;

-- Countries with Highest Death Count per Population
SELECT location, MAX(total_deaths) AS total_death_count
FROM public.dataexplore
WHERE continent IS NOT NULL 
GROUP BY location
ORDER BY total_death_count DESC;

-- BREAKING THINGS DOWN BY CONTINENT
-- Showing continents with the highest death count per population
SELECT continent, MAX(total_deaths) AS total_death_count
FROM public.dataexplore
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY total_death_count DESC;

-- GLOBAL NUMBERS
SELECT SUM(new_cases) AS total_cases, SUM(total_deaths) AS total_deaths, SUM(total_deaths)/SUM(new_cases)*100 AS death_percentage
FROM public.dataexplore
WHERE continent IS NOT NULL 
ORDER BY total_cases, total_deaths;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has received at least one Covid Vaccine
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM public.dataexplore dea
JOIN public.dataexplore vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
ORDER BY location, date;

-- Get the total number of ICU patients per location
SELECT location, SUM(icu_patients) AS icu_patients
FROM public.dataexplore
GROUP BY location;

-- Get the total number of hospital patients per location
SELECT location, SUM(hosp_patients) AS hosp_patients
FROM public.dataexplore
GROUP BY location;

-- Get the average GDP per capita per location
SELECT location, AVG(gdp_per_capita) AS avg_gdp_per_capita
FROM public.dataexplore
GROUP BY location;

-- Create a view for total cases and deaths per location
CREATE VIEW total_cases_deaths AS
SELECT location, SUM(total_cases) AS total_cases, SUM(total_deaths) AS total_deaths
FROM public.dataexplore
GROUP BY location;

-- Create a view for average new cases and deaths per location
CREATE VIEW avg_new_cases_deaths AS
SELECT location, AVG(new_cases) AS avg_new_cases, AVG(new_deaths) AS avg_new_deaths
FROM public.dataexplore
GROUP BY location;

-- Create a view for maximum new cases and deaths per location
CREATE VIEW max_new_cases_deaths AS
SELECT location, MAX(new_cases) AS max_new_cases, MAX(new_deaths) AS max_new_deaths
FROM public.dataexplore
GROUP BY location;

-- Create a view for total vaccinations per location
CREATE VIEW total_vaccinations AS
SELECT location, SUM(total_vaccinations) AS total_vaccinations
FROM public.dataexplore
GROUP BY location;

-- Create a view for total people vaccinated per location
CREATE VIEW total_people_vaccinated AS
SELECT location, SUM(people_vaccinated) AS people_vaccinated
FROM public.dataexplore
GROUP BY location;

-- Create a view for total ICU patients per location
CREATE VIEW total_icu_patients AS
SELECT location, SUM(icu_patients) AS icu_patients
FROM public.dataexplore
GROUP BY location;

-- Create a view for average GDP per capita per location
CREATE VIEW avg_gdp_per_capita AS
SELECT location, AVG(gdp_per_capita) AS avg_gdp_per_capita
FROM public.dataexplore
GROUP BY location;

-- Using CTE to perform Calculation on Partition By in previous query
WITH popvsvac AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM public.dataexplore dea
JOIN public.dataexplore vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
)
SELECT *, (rolling_people_vaccinated/population)*100 AS percent_population_vaccinated
FROM popvsvac;

-- Using Temp Table to perform Calculation on Partition By in previous query
DROP TABLE IF EXISTS percent_population_vaccinated;
CREATE TEMP TABLE percent_population_vaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM public.dataexplore dea
JOIN public.dataexplore vac
ON dea.location = vac.location
AND dea.date = vac.date;

SELECT *, (rolling_people_vaccinated/population)*100 AS percent_population_vaccinated
FROM percent_population_vaccinated;

-- Creating View to store data for later visualizations
CREATE OR REPLACE VIEW percent_population_vaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM public.dataexplore dea
JOIN public.dataexplore vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;



