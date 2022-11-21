select *
from PortfoioProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--from PortfoioProject..CovidVaccinations
--order by 3,4

-- ������� ������, ������� ����� ������������

select location, date, total_cases, new_cases, total_deaths, population
from PortfoioProject..CovidDeaths
order by 1,2

--���������� ��� ������(total_cases) vs ��� ������(total_deaths)
--���� ������������� ������, �� ����� ������� ����� ��� � 2022 ���� ���� ������ ��� �������� 1.8%
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentege
from PortfoioProject..CovidDeaths
where location like '%Russia%'
and continent is not null
order by 1,2

-- ���������� ������� ���������, ������� ����������
-- �����: ����� 14% ���������� 
select location, date, total_cases, population, (total_cases/population)*100 as GotCovid
from PortfoioProject..CovidDeaths
where location like '%Russia%'
and continent is not null
order by 1,2

-- ���������� ������ � ����� ������� ��������� ���������
select location, population, max(total_cases) as HighestInf, max((total_cases/population))*100 as PersPopulation
from PortfoioProject..CovidDeaths
--where location like '%Russia%'
group by location, population
order by PersPopulation desc

-- ������� ������ � ����� ������� ���-��� ������� �� ������� ���������

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfoioProject..CovidDeaths
--where location like '%Russia%'
where continent is not null
group by location
order by TotalDeathCount desc


-- ����������� ������� � ��������� �� �����������
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfoioProject..CovidDeaths
--where location like '%Russia%'
where continent is not  null
group by continent
order by TotalDeathCount desc

--���������� �����

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentege
from PortfoioProject..CovidDeaths
--where location like '%Russia%'
where continent is not null
--group by date
order by 1,2


--���������� ��� ��������� �� ���-�� ����������
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.date) as PV
from PortfoioProject..CovidDeaths dea
join PortfoioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--��������� CTE

with POPvsVAC (continent, location, date, population,new_vaccinations, PV)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.date)
from PortfoioProject..CovidDeaths dea
join PortfoioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

select *, (PV/population)*100 as Pers
from POPvsVAC


--���������� TempTable
drop table if exists #percentPopulationVac  
create table #percentPopulationVac
(
Continent nvarchar(255),
location nvarchar(255),
date nvarchar(255),
population numeric,
new_vaccinations numeric,
PV numeric
)

insert into #percentPopulationVac
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.date)
from PortfoioProject..CovidDeaths dea
join PortfoioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (PV/population)*100 as Pers
from #percentPopulationVac
order by Continent


--�������� View ����� ����� ������������ ��� ������������

create view percentPopulationVac as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.date) as SumVac
from PortfoioProject..CovidDeaths dea
join PortfoioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


select *

from percentPopulationVac


create view Total_NUMs
as
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentege
from PortfoioProject..CovidDeaths
--where location like '%Russia%'
where continent is not null
--group by date
--order by 1,2

select *

from Total_NUMs