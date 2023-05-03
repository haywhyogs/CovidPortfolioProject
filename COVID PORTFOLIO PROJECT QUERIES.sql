Select * 
From CovidProject..CovidDeaths
where continent is not null
order by 3,4

--Total number of confirmed cases by country:

SELECT location, SUM(total_cases) AS TotalConfirmed
FROM CovidProject..CovidDeaths
where continent is not null
GROUP BY location
ORDER BY TotalConfirmed DESC;


--Average number of deaths per day in a specific date range in The UK

SELECT AVG(CAST(new_deaths as int)) AS AverageDeathsPerDay
FROM CovidProject..CovidDeaths
WHERE Date BETWEEN '2023-01-01' AND '2023-01-20'
AND location like '%kingdom%'
AND continent is not null;

--Countries with the highest mortality rates, This query gives the top 10 countries with the highest mortality rates,
--along with the maximum number of deaths and cases in each country and the corresponding mortality rate.
--The CAST function is used to convert the integer division result to a float, to avoid rounding errors.

SELECT TOP 10 location, MAX(total_deaths) as max_deaths, MAX(total_cases) as max_cases, 
       CAST(MAX(total_deaths) AS float) / MAX(total_cases) as mortality_rate
FROM CovidProject..CovidDeaths
where continent is not null
GROUP BY location
ORDER BY mortality_rate DESC;


---- Top 10 countries with highest infection to population rate
SELECT TOP 10 location, population, MAX(total_cases) AS total_cases, convert(DECIMAL(10,2),MAX(total_cases/population)) * 100 AS 'infection_rate(%)'
FROM CovidProject..CovidDeaths
WHERE location NOT IN ('World', 'High income', 'Europe', 'Asia', 'European Union','Upper middle income', 'North America',
						'Lower middle income','South America')
GROUP BY location,population
ORDER BY 'infection_rate(%)' DESC;

--Trend analysis of new cases over time:
--This query shows the total number of new cases per day over time, allowing us to see the trend in the spread of the virus.
SELECT date, SUM(new_cases) OVER (ORDER BY date) AS TotalNewCases
FROM CovidProject..CovidDeaths
where continent is not null;

--Analysis of vaccination rates by country:
--This query shows the total number of COVID vaccinations by country, as well as the percentage of the population that has been vaccinated.

SELECT location, SUM(cast(total_vaccinations as int)) AS total_vaccinations, MAX(cast(people_vaccinated as int)) AS VaccinationRate
FROM CovidProject..CovidVaccinations
where continent is not null
GROUP BY location
ORDER BY VaccinationRate DESC;

--Query to calculate the average number of cases and deaths per day:

SELECT AVG(new_cases) AS avg_cases_per_day, AVG(cast(new_deaths as int)) AS avg_deaths_per_day
FROM CovidProject..CovidDeaths
where continent is not null;

--This query will calculate the daily percentage increase in cases for the United Kingdom.
--It uses the lag() function to calculate the difference between the current day's
--number of cases and the previous day's number of cases,
--and then calculates the percentage increase using that difference.

SELECT date, total_cases, 100 * (total_cases - lag(total_cases) OVER (ORDER BY date))/lag(total_cases) 
OVER (ORDER BY date) AS percentage_increase
FROM CovidProject..CovidDeaths
where continent is not null
AND location = 'United Kingdom'
ORDER BY date;

--Total number of confirmed cases by country and month:
--This query will show the total number of confirmed COVID-19 cases by country and month
--It can help to identify which countries had the highest number of cases during certain months
--and track the progression of the pandemic over time.

SELECT location, MONTH(date) as Month, SUM(new_cases) as Total_Confirmed
FROM CovidProject..CovidDeaths
where continent is not null
GROUP BY location, MONTH(date)
ORDER BY Total_Confirmed DESC;


--Number of new cases per day in a specific country:
--This query will show the number of new cases per day in a specific country.
--It can help to identify trends in the transmission of the virus over time.

SELECT TOP 10 date, new_cases
FROM CovidProject..CovidDeaths
WHERE location = 'United kingdom'
AND continent is not null
ORDER BY date DESC;



SELECT date, total_cases
FROM CovidProject..CovidDeaths
ORDER BY date ASC;

SELECT date, total_cases, total_cases - LAG(total_cases) OVER (ORDER BY date) AS daily_cases
FROM CovidProject..CovidDeaths
where continent is not null
ORDER BY date ASC;

Select * 
From CovidProject..CovidVaccinations
order by 3,4

Select location, date, population, total_cases, new_cases, total_deaths
From CovidProject..CovidDeaths
where continent is not null
order by 1,2


--Working on total cases vs total deaths

Select location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidProject..CovidDeaths
order by 1,2

-- Deep diving to find out for death percentage in UK, showing the likelihood of dying when one contract Covid19 in the UK

Select location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidProject..CovidDeaths
Where location like '%kingdom%'
order by 1,2

--Total cases with respect to population to know what percent of the populations have covid

Select location, date, population, total_cases, (total_cases/population)*100 as CasesPerPopulation 
From CovidProject..CovidDeaths
Where location like '%kingdom%'
order by 1,2

--Looking at countries with highest infection rate with respect to their population

Select location, population, MAX(total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as CasesPerPopulation
From CovidProject..CovidDeaths
where continent is not null
Group by location, population
order by CasesPerPopulation desc

--Looking at death rate in different countries in descending order

Select location, population, MAX(cast(total_deaths as int)) as HighestDeathCount,Max((total_deaths/population))*100 as DeathsPerPopulation
From CovidProject..CovidDeaths
where continent is not null
Group by location, population
order by 3 desc

--Looking into this by continent

Select continent, MAX(cast(total_deaths as int)) as HighestDeathCount
From CovidProject..CovidDeaths
where continent is not null
Group by continent
order by 2 desc

Select location, MAX(cast(total_deaths as int)) as HighestDeathCount
From CovidProject..CovidDeaths
where continent is null
Group by location
order by 2 desc

--GLOBALLY

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int))as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as DeathPercentage
From CovidProject..CovidDeaths
where continent is not null
Group by date
order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int))as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as DeathPercentage
From CovidProject..CovidDeaths
where continent is not null
order by 1,2


--Now looking at total population vs vaccinations

Select * 
From CovidProject..CovidDeaths dea
Join
CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date;

--Looking at Total Population vs Vaccinations in the UK
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From CovidProject..CovidDeaths dea
Join
CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
AND dea.location = 'United Kingdom'
order by 2,3;


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(COALESCE(vac.new_vaccinations, 0) as bigint)) OVER (Partition by dea.location
order by dea.location,dea.date) as RollingPeopleVaccinated
From CovidProject..CovidDeaths dea
Join
CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;

--USING CTE



--Query to calculate the total number of cases and deaths per continent:

SELECT continent, SUM(total_cases) AS total_cases, SUM(cast(total_deaths as int)) AS total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as DeathPercentage
FROM CovidProject..CovidDeaths
where continent is not null
GROUP BY continent
order by 4 DESC;

-- Checking total stats for my country (United Kingdom)

SELECT TOP (1) *
FROM CovidProject..CovidDeaths
WHERE location = 'United Kingdom'
ORDER BY date DESC;

-- using a common table expression to obtain the rate of rolling totals to population


WITH PopvsVac (date, continent, location, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(COALESCE(vac.new_vaccinations, 0) as bigint)) OVER (Partition by dea.location
order by dea.location,dea.date) as RollingPeopleVaccinated
From CovidProject..CovidDeaths dea
Join
CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
SELECT *, (RollingPeopleVaccinated/population)* 100
FROM PopvsVac


--TEMP TABLE

Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(COALESCE(vac.new_vaccinations, 0) as bigint)) OVER (Partition by dea.location
order by dea.location,dea.date) as RollingPeopleVaccinated
From CovidProject..CovidDeaths dea
Join
CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
SELECT *, (RollingPeopleVaccinated/population)* 100
FROM #PercentPopulationVaccinated

--Creating View to store data for later visualisations

Create View 
PercentPopulationVaccinated AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(COALESCE(vac.new_vaccinations, 0) as bigint)) OVER (Partition by dea.location
order by dea.location,dea.date) as RollingPeopleVaccinated
From CovidProject..CovidDeaths dea
Join
CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

SELECT *
FROM PercentPopulationVaccinated