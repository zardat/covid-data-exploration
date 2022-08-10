Select *
From [portfolio project]..[covid-deaths]
Where continent is not null 
order by 3,4

Select *
From [portfolio project]..[covid-vaccination]
Where continent is not null 
order by 3,4

--Total cases vs Total deaths
--Total cases vs population

Select Location, date, total_cases, new_cases, total_deaths, population,(total_cases/population)*100 as infection_per
From [portfolio project]..[covid-deaths]
--Where location = 'india'
order by 1,2

--comparision between MAX Infection and population

Select Location, MAX(total_cases) as Highest_count, population,MAX((total_cases/population))*100 as population_infected
From [portfolio project]..[covid-deaths]
Group by location,population
--Where location = 'india'
order by population_infected desc

--Death count vs population

Select Location, MAX(cast(total_deaths as int)) as totaldeathcount
From [portfolio project]..[covid-deaths]
Where continent is not null
Group by location
--Where location = 'india'
order by totaldeathcount desc

-- Analysis on the basis of continents

Select Location, MAX(cast(total_deaths as int)) as totaldeathcount
From [portfolio project]..[covid-deaths]
Where continent is null
Group by location
--Where location = 'india'
order by totaldeathcount desc

--Global analysis

Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as death_per
From [portfolio project]..[covid-deaths]
Where continent is not null
Group by date
--Where location = 'india'
order by 1,2;

--Total deaths globaly till date

Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as death_per
From [portfolio project]..[covid-deaths]
Where continent is not null
--Where location = 'india'
order by 1,2;

-- Joining infectons and vaccination data

Select *
From [portfolio project]..[covid-deaths] dea
join [portfolio project]..[covid-vaccination] vac
 on dea.location = vac.location
 and dea.date = vac.date;

-- Total population vs Vaccination

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) Over (partition by dea.location order by dea.date )
as vaccine_count
From [portfolio project]..[covid-deaths] dea
join [portfolio project]..[covid-vaccination] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not NULL
--and dea.location = 'india'
order by 2,3;

-- Population Vaccinated using CTE

with PopvsVac (continent,location,date,population,new_vaccination,vaccine_count)
as
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) Over (partition by dea.location order by dea.date )
as vaccine_count
From [portfolio project]..[covid-deaths] dea
join [portfolio project]..[covid-vaccination] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not NULL
--order by 2,3
)
select *,(vaccine_count/population)*100
from PopvsVac
order by 2,3


-- Making a view for Data visualization	

create view PercentVaccinated as
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) Over (partition by dea.location order by dea.date )
as vaccine_count
From [portfolio project]..[covid-deaths] dea
join [portfolio project]..[covid-vaccination] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not NULL
--and dea.location = 'india'


