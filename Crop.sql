/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
SELECT TOP (1000) [LOCATION]
      ,[SUBJECT]
      ,[MEASURE]
      ,[TIME]
      ,[Value]
  FROM [WorldCropProduction].[dbo].[WWCP]
  --tonne_ha tonne per hectare

-- lets see the crop
  select distinct [subject]                
  from WorldCropProduction..WWCP
--SOYBEAN
--MAIZE
--RICE
--WHEAT


  --Select measure as Tonne/ha and Current time
  select [location],[SUBJECT], [measure],[TIME],[Value]
  from WorldCropProduction..WWCP
  where [TIME] = 2022
  group by [TIME],[location],[measure],[Value],[SUBJECT]
  having  [measure] = 'TONNE_HA'
  order by [LOCATION],[Value] desc

  -- Lets select top 10 of all subject for current YEAR
  with WR ([location],[SUBJECT], [Value],[TIME]) as (
  select [location],[SUBJECT], [Value],[TIME]
  from WorldCropProduction..WWCP
  where [measure] = 'TONNE_HA' and [TIME] = 2022 
  --order by 3 desc
  )

  select top 10 [location],[SUBJECT], [Value],[TIME]
  from WR
  where [SUBJECT] = 'WHEAT'
  order by 3 desc;


  with WR ([location],[SUBJECT], [Value],[TIME]) as (
  select [location],[SUBJECT], [Value],[TIME]
  from WorldCropProduction..WWCP
  where [measure] = 'TONNE_HA' and [TIME] = 2022 
  --order by 3 desc
  )


  select wrc1.[location],wrc1.[SUBJECT], wrc1.[Value],wrc1.[TIME]
  from WR  as wrc1
   left join ( select top 10 [location],[SUBJECT], [Value],[TIME]
  from WR
  where [SUBJECT] = 'Rice'
  order by 3 desc) as wrc2 on wrc1.[location] = wrc2.[location]
    left join ( select top 10 [location],[SUBJECT], [Value],[TIME]
  from WR
  where [SUBJECT] = 'Wheat'
  order by 3 desc) as wrc3 on wrc2.[location] = wrc3.[location]
    left join ( select top 10 [location],[SUBJECT], [Value],[TIME]
  from WR
  where [SUBJECT] = 'Maize'
  order by 3 desc) as wrc4 on wrc3.[location] = wrc4.[location]
    left join ( select top 10 [location],[SUBJECT], [Value],[TIME]
  from WR
  where [SUBJECT] = 'Soybean'
  order by 3 desc) as wrc5 on wrc4.[location] = wrc5.[location]


  order by [SUBJECT] desc, [Value] desc;



  -- Do the same but for the first time in the Dataset

    with WR ([location],[SUBJECT], [Value],[TIME]) as (
  select [location],[SUBJECT], [Value],[TIME]
  from WorldCropProduction..WWCP
  where [measure] = 'TONNE_HA' and [TIME] = 1990 
  --order by 3 desc
  )


  select wrc1.[location],wrc1.[SUBJECT], wrc1.[Value],wrc1.[TIME]
  from WR  as wrc1
   left join ( select top 10 [location],[SUBJECT], [Value],[TIME]
  from WR
  where [SUBJECT] = 'Rice'
  order by 3 desc) as wrc2 on wrc1.[location] = wrc2.[location]
    left join ( select top 10 [location],[SUBJECT], [Value],[TIME]
  from WR
  where [SUBJECT] = 'Wheat'
  order by 3 desc) as wrc3 on wrc2.[location] = wrc3.[location]
    left join ( select top 10 [location],[SUBJECT], [Value],[TIME]
  from WR
  where [SUBJECT] = 'Maize'
  order by 3 desc) as wrc4 on wrc3.[location] = wrc4.[location]
    left join ( select top 10 [location],[SUBJECT], [Value],[TIME]
  from WR
  where [SUBJECT] = 'Soybean'
  order by 3 desc) as wrc5 on wrc4.[location] = wrc5.[location]


  order by [SUBJECT] desc, [Value] desc;


  -- And do the same for whole time without forecast

      with WR ([location],[SUBJECT], [Value],[TIME]) as (
  select [location],[SUBJECT], [Value],[TIME]
  from WorldCropProduction..WWCP
  where [measure] = 'TONNE_HA' and [TIME] between 1990 and 2022
  --order by 3 desc
  )

 
  select wrc1.[location],wrc1.[SUBJECT], wrc1.[Value],wrc1.[TIME]
  from WR  as wrc1
   left join ( select top 10 [location],[SUBJECT], [Value],[TIME]
  from WR
  where [SUBJECT] = 'Rice'
  order by 3 desc) as wrc2 on wrc1.[location] = wrc2.[location]
    left join ( select top 10 [location],[SUBJECT], [Value],[TIME]
  from WR
  where [SUBJECT] = 'Wheat'
  order by 3 desc) as wrc3 on wrc2.[location] = wrc3.[location]
    left join ( select top 10 [location],[SUBJECT], [Value],[TIME]
  from WR
  where [SUBJECT] = 'Maize'
  order by 3 desc) as wrc4 on wrc3.[location] = wrc4.[location]
    left join ( select top 10 [location],[SUBJECT], [Value],[TIME]
  from WR
  where [SUBJECT] = 'Soybean'
  order by 3 desc) as wrc5 on wrc4.[location] = wrc5.[location]


  order by [SUBJECT] desc, [Value] desc;



  --forecast 2023-2026

        with WR ([location],[SUBJECT], [Value],[TIME]) as (
  select [location],[SUBJECT], [Value],[TIME]
  from WorldCropProduction..WWCP
  where [measure] = 'TONNE_HA' and [TIME] between 2023 and 2026
  --order by 3 desc
  )

 
  select distinct wrc1.[location],wrc1.[SUBJECT], wrc1.[Value],wrc1.[TIME]
  from WR  as wrc1
   left join ( select top 10 [location],[SUBJECT], [Value],[TIME]
  from WR
  where [SUBJECT] = 'Rice'
  order by 3 desc) as wrc2 on wrc1.[location] = wrc2.[location]
    left join ( select top 10 [location],[SUBJECT], [Value],[TIME]
  from WR
  where [SUBJECT] = 'Wheat'
  order by 3 desc) as wrc3 on wrc2.[location] = wrc3.[location]
    left join ( select top 10 [location],[SUBJECT], [Value],[TIME]
  from WR
  where [SUBJECT] = 'Maize'
  order by 3 desc) as wrc4 on wrc3.[location] = wrc4.[location]
    left join ( select top 10 [location],[SUBJECT], [Value],[TIME]
  from WR
  where [SUBJECT] = 'Soybean'
  order by 3 desc) as wrc5 on wrc4.[location] = wrc5.[location]


  order by [SUBJECT] desc, [Value] desc;