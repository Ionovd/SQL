/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
SELECT TOP (1000) [price]
      ,[Ranks]
      ,[title]
      ,[no_of_reviews]
      ,[ratings]
      ,[author]
      ,[cover_type]
      ,[year]
  FROM [project].[dbo].['best_selling_books_2009-2021_fu$']


  -- count by the year how many times each author get bestseller
  -- and select top 10

  select top 10 with ties author, count(author) as total_best
  FROM [project].[dbo].['best_selling_books_2009-2021_fu$'] 
  group by author
  having author is not NULL
  order by total_best desc

  --GOAT by no_of_reviews/ratings
  select distinct title, no_of_reviews, ratings, round((no_of_reviews/ratings),4) as ratio, count(year) as total_top_100
  FROM [project].[dbo].['best_selling_books_2009-2021_fu$'] 
  where ratings >= 4.7
  group by title, no_of_reviews, ratings
  order by 4 desc

  --High Price = High Ratings?
   select title, avg(price) as AvgPrice, round((no_of_reviews/ratings),4) as ratio
   FROM [project].[dbo].['best_selling_books_2009-2021_fu$'] 
   group by title, round((no_of_reviews/ratings),4)
   order by 2 desc


   -- Count Cover_type
   select cover_type,  count(cover_type) as Total, round(avg(price),4) as AVGprice_per_Cover
   FROM [project].[dbo].['best_selling_books_2009-2021_fu$'] 
   group by cover_type
   having cover_type is not NULL
   order by 2 desc

   --Select top 1 by each year

   select title, no_of_reviews, ratings, year
   FROM [project].[dbo].['best_selling_books_2009-2021_fu$'] 
   where Ranks = 1
   order by year desc

   -- best ratio PRICE / (Reviews / ratings)

   select title, max(round((price/(no_of_reviews/ratings)),6)*100) as Ratio
   FROM [project].[dbo].['best_selling_books_2009-2021_fu$'] 
   where year = 2021
   group by title
   having title is not NULL 
   order by 2 desc

   --select count titles which were more than 1 time in bestsellers by year
	select distinct  title, author, count(title) as total
	FROM [project].[dbo].['best_selling_books_2009-2021_fu$'] 
	group by title,author
	having title is not NULL and count(title) > 1
	order by 3desc,2 desc


	-- Select book that was in top bestsellers since 2009 
	select  distinct top 1   cc.title, cc.total, iif (cc.total = 12,'Bestseller since 2009',' ') as tit
	from (select distinct  title, count(title) as total
	FROM [project].[dbo].['best_selling_books_2009-2021_fu$'] 
	group by title
	having title is not NULL
	) as cc
	order by cc.total desc