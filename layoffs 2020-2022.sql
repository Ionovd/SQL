/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
SELECT TOP (1000) [company]
      ,[location]
      ,[industry]
      ,[total_laid_off]
      ,[percentage_laid_off]
      ,[date]
      ,[stage]
      ,[country]
      ,[funds_raised (in millions)]
  FROM [PortfoioProject].[dbo].[layoffs]

  -- Select all layoffs by each country + rank
  select country, sum(total_laid_off) as Layoffs, ROW_NUMBER() over (order by sum(total_laid_off )desc) as Rank_Numer_of_Layoffs
  from PortfoioProject..layoffs
  group by country 
  having sum(total_laid_off) is not Null
  order by 2 desc

  -- Select top 10 companies by layoffs
  select top 10 company, industry, total_laid_off, percentage_laid_off
  from PortfoioProject..layoffs
  order by total_laid_off desc

  -- same but top 10 by percentage laid off

  select top 10 company, industry, total_laid_off, percentage_laid_off
  from PortfoioProject..layoffs
  where total_laid_off is not Null and total_laid_off >= 3000
  order by percentage_laid_off desc
 
 -- industries losses

 select industry , sum(total_laid_off) as Layoffs
 from PortfoioProject..layoffs
 group by industry
 order by 2 desc

 --Total layoffs by year

 select sum(total_laid_off) as Layoffs , year(date) as Year
 from PortfoioProject..layoffs
 group by year(date)
 having sum(total_laid_off) is not Null
 order by sum(total_laid_off) desc

 --Layoffs by month since 2020 + ranks
 select sum(total_laid_off) as Layoffs ,  year(date) as Year, datename(month, date) as Month
 , rank() over (order by sum(total_laid_off) desc) as Top_
 from PortfoioProject..layoffs
 group by  year(date), datename(month, date)
 having sum(total_laid_off) is not Null
 order by Layoffs desc


 select stage, sum(total_laid_off) as Layoffs, sum(cast([funds_raised (in millions)] as bigint)) as SummaryFunds
 from PortfoioProject..layoffs
 group by layoffs.stage
 having stage is not Null and sum(total_laid_off) is not Null
 order by 2 desc

 