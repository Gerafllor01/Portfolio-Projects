
Select *
From [PORTFOLIO PROJECTS]..CovidVVaccinations
where continent is not null
order by 3,4


--Select *
--From [PORTFOLIO PROJECTS]..CovidDeaths
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From [PORTFOLIO PROJECTS]..CovidVVaccinations
where continent is not null
order by 1,2

Select Location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 as DeathPercentage
From [PORTFOLIO PROJECTS]..CovidVVaccinations
Where location like '%states%'
and continent is not null
order by 1,2

Select Location, date, Population, total_cases, (total_cases / population)*100 as PercentPopulationInfected
From [PORTFOLIO PROJECTS]..CovidVVaccinations
Where location like '%states%'
and continent is not null
order by 1,2

Select Location, Population,MAX(total_cases) as HighestInfectionCount, MAX((total_cases / population))*100 as PercentPopulationInfected
From [PORTFOLIO PROJECTS]..CovidVVaccinations
--Where location like '%states%'
where continent is not null
Group by Location, Population
order by PercentPopulationInfected desc


Select Location,MAX(cast(total_deaths as int)) as TotalDeathCount
From [PORTFOLIO PROJECTS]..CovidVVaccinations
--Where location like '%states%'
where continent is not null
Group by Location
order by TotalDeathCount desc


Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
From [PORTFOLIO PROJECTS]..CovidVVaccinations
--Where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc


Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
From [PORTFOLIO PROJECTS]..CovidVVaccinations
--Where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc


Select date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From [PORTFOLIO PROJECTS]..CovidVVaccinations
--Where location like '%states%'
Where continent is not null
Group by date
order by 1,2


Select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From [PORTFOLIO PROJECTS]..CovidVVaccinations
--Where location like '%states%'
Where continent is not null
--Group by date
order by 1,2

Select vac.continent, vac.location, vac.date, vac.population, dea.new_vaccinations
, SUM(cast(dea.new_vaccinations as int)) OVER (partition by vac.location Order by vac.location, vac.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated / population)*100
From [PORTFOLIO PROJECTS]..CovidVVaccinations vac
join [PORTFOLIO PROJECTS]..CovidDeaths dea
	on vac.location = dea.location
	and vac.date = dea.date
Where vac.continent is not null
Order by 2,3

With PopvsVac(continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated) 
as
(
Select vac.continent, vac.location, vac.date, vac.population, dea.new_vaccinations
, SUM(cast(dea.new_vaccinations as int)) OVER (partition by vac.location Order by vac.location, vac.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated / population)*100
From [PORTFOLIO PROJECTS]..CovidVVaccinations vac
join [PORTFOLIO PROJECTS]..CovidDeaths dea
	on vac.location = dea.location
	and vac.date = dea.date
Where vac.continent is not null
)

Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select vac.continent, vac.location, vac.date, vac.population, dea.new_vaccinations
, SUM(cast(dea.new_vaccinations as int)) OVER (partition by vac.location Order by vac.location, vac.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated / population)*100
From [PORTFOLIO PROJECTS]..CovidVVaccinations vac
join [PORTFOLIO PROJECTS]..CovidDeaths dea
	on vac.location = dea.location
	and vac.date = dea.date
--Where vac.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


Create view PercentPopulationVaccinated as
Select vac.continent, vac.location, vac.date, vac.population, dea.new_vaccinations
, SUM(cast(dea.new_vaccinations as int)) OVER (partition by vac.location Order by vac.location, vac.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated / population)*100
From [PORTFOLIO PROJECTS]..CovidVVaccinations vac
join [PORTFOLIO PROJECTS]..CovidDeaths dea
	on vac.location = dea.location
	and vac.date = dea.date
Where vac.continent is not null


Select *
From PercentPopulationVaccinated

Create view DeathPercentage as
Select date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From [PORTFOLIO PROJECTS]..CovidVVaccinations
--Where location like '%states%'
Where continent is not null
Group by date