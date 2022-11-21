 /****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
SELECT TOP (1000) [Account]
      ,[Businees Unit]
      ,[Currency]
      ,[Year]
      ,[Scenario]
      ,[Jan]
      ,[Feb]
      ,[Mar]
      ,[Apr]
      ,[May]
      ,[Jun]
      ,[Jul]
      ,[Aug]
      ,[Sep]
      ,[Oct]
      ,[Nov]
      ,[Dec]
  FROM [Money].[dbo].[Financials$]

  --Select all amount of profit per year (actuals)

  select [Businees Unit], Scenario, YEAR, sum(jan) + sum(feb) + sum(mar) + sum(apr) + sum(may) + sum(jun) + sum(jul) + sum(aug) + sum(sep) + sum(oct) + sum(nov) + sum(dec)
  as Total_per_year
  from money..financials
  group by [Businees Unit], Year, Scenario
  having Scenario = 'Actuals'
  order by [Businees Unit]
  

  -- Total profit (actuals) per Buiseness Unit
  select [Businees Unit], sum(jan) + sum(feb) + sum(mar) + sum(apr) + sum(may) + sum(jun) + sum(jul) + sum(aug) + sum(sep) + sum(oct) + sum(nov) + sum(dec)
  as Total_per_year
  from money..financials
  group by [Businees Unit]
  order by [Businees Unit]

--Businees Unit	Total_per_year
--Advertising  524929923,82
--Hardware	748090221,14
--Software	2106039180,00


--Compare Budget for Payroll Expense 2023 and Forecast Payroll Expense for 2023

  select [Businees Unit], Scenario, Account, abs(sum(jan) + sum(feb) + sum(mar) + sum(apr) + sum(may) + sum(jun) + sum(jul) + sum(aug) + sum(sep) + sum(oct) + sum(nov) + sum(dec))
  as Total_per_year
  from money..financials
  where Account = 'Payroll Expense'
  group by [Businees Unit], Scenario, Account
  having Scenario = 'Budget' or Scenario = 'Forecast'
  order by [Businees Unit]

  -- Lets see how Payroll expenses changed for years 2012-2022
  -- Payroll expenses decreased for some reasons
  --use cte for fun

  with wholeyear ( BusinessUnit, year, total)
  as (
  select [Businees Unit], Year, abs(sum(jan) + sum(feb) + sum(mar) + sum(apr) + sum(may) + sum(jun) + sum(jul) + sum(aug) + sum(sep) + sum(oct) + sum(nov) + sum(dec))
  from money..financials
  where Account = 'Payroll Expense' and year in (2012,2022)
  group by [Businees Unit], Scenario, Account, year
  )
  select *
  from wholeyear
  order by BusinessUnit, year

  





