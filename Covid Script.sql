select Location, date, total_cases, new_cases, total_deaths, population
from covid.`covid-dealth`
order by 1,2;

-- Looking at total cases vs total death
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as "Death percentage"
from covid.`covid-dealth`
where Location like '%Ghana%'
order by 1,2;

-- Looking at the total case vs population
select Location, date, total_cases, population, (total_cases/population)*100 as "percentage cases"
from covid.`covid-dealth`
where Location like '%Ghana%'
order by 1,2;

-- countries with the highest infection rate
select Location,  max(total_cases) as "highest infection cunt", population, max(total_cases/population)*100 as "percentage of population infected"
from covid.`covid-dealth`
group by location, population
order by max(total_cases/population)*100 desc;

-- countries with highest death count population
select Location,  max(total_deaths) as "highest death cunt", population, max(total_deaths/population)*100 as "percentage of population dead"
from covid.`covid-dealth`
group by location, population
order by max(total_deaths/population)*100 desc;

-- Break data down by continent
select continent,  max(total_deaths) as "highest death cunt", population, max(total_deaths/population)*100 as "percentage of population dead"
from covid.`covid-dealth`
where continent is not null
group by continent
order by max(total_deaths/population)*100 desc;

-- Global Members
select date, sum(total_cases) as 'total cases', sum(total_deaths) as 'totaldeaths', sum(new_cases) as 'total new cases'
from covid.`covid-dealth`
group by date
order by year(date);

-- joining two tables

-- Total population vs vacination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from covid.`covid-dealth` dea
join covid.`covid-vaccination`vac

on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null;

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From covid.`covid-dealth` dea
Join covid.`covid-vaccination`vac
	On dea.location = vac.location
	and dea.date = vac.date;
    
    
-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From covid.`covid-dealth` dea
Join covid.`covid-vaccination` vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 