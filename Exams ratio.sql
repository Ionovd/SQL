/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
SELECT TOP (1000) [ID]
      ,[gender]
      ,[group]
      ,[parental level of education]
      ,[lunch]
      ,[test preparation course]
      ,[math score]
      ,[reading score]
      ,[writing score]
  FROM [Exams].[dbo].[Results]



  -- Lets sum all scores
  select ID, gender, [group], [test preparation course], ( [math score] + [reading score] + [writing score] ) as Total_score
  from Exams..Results
  order by Total_score desc

  -- Max Total_score 
  with totalgroup (ID, gender, [group],[test preparation course], total_score) as (
  select top 1 with ties ID, gender, [group],[test preparation course], ( [math score] + [reading score] + [writing score] ) as total_score
  from Exams..Results
  order by total_score desc
  )

  select *
  from totalgroup;

  -- Last 10 Total_score

  with totalgroup (ID, gender, [group],[test preparation course], total_score) as (
  select top 10 with ties ID, gender, [group],[test preparation course], ( [math score] + [reading score] + [writing score] ) as total_score
  from Exams..Results
  order by total_score 
  )

  select *
  from totalgroup;

  -- Sum Total_score in groups

  with totalgroup (ID, gender, [group], total_score) as (
  select ID, gender, [group], ( [math score] + [reading score] + [writing score] ) as total_score
  from Exams..Results
  )

  select  [group], sum(total_score) as Total_between_groups
  from totalgroup
  group by [group]
  order by Total_between_groups desc

  -- Count students in groups
    with totalgroup (ID, gender, [group], total_score) as (
  select ID, gender, [group], ( [math score] + [reading score] + [writing score] ) as total_score
  from Exams..Results
  )

  select [group], count(id) as Students
  from totalgroup
  group by [group]
  order by [group]

  --Ratio Total_score_between_groups / Students / Place
      with totalgroup (ID, gender, [group], total_score) as (
  select ID, gender, [group], ( [math score] + [reading score] + [writing score] ) as total_score
  from Exams..Results
  )

  select [group], round(sum(total_score)/count(id),1) as Ratio, row_number() over (order by [group] desc) as Place
  from totalgroup
  group by [group]
  order by Ratio desc;
  
  --Result:
--group()	Ratio
--group E	218,3
--group D	207,5
--group C	201,4
--group B	196,4
--group A	189

-- Did test preparation affected high score rate?
-- high score >=250
with Ranks (id,gender, [test preparation course], total_score, [rank]) as (
select id, gender, [test preparation course], ( [math score] + [reading score] + [writing score] ) as total_score
, convert(int,rank() over ( order by [test preparation course])) as Rank
from Exams..Results
where ( [math score] + [reading score] + [writing score] ) >= 250 )

select count([rank]) as  Students_Prep_course, round(avg(total_score),1) as Average_Score
from Ranks
where [rank] = 1;

--Non prep 

with Ranks (id,gender, [test preparation course], total_score, [rank]) as (
select id, gender, [test preparation course], ( [math score] + [reading score] + [writing score] ) as total_score
, convert(int,rank() over ( order by [test preparation course])) as Rank
from Exams..Results
where ( [math score] + [reading score] + [writing score] ) >= 250 )

select count([rank]) as  Students_Non_Prep_course, round(avg(total_score),1) as Average_Score
from Ranks
where [rank] = 78;


--(High score)Male vs Female by Ration (gender_count / sum(total_score) with test prep

select gender, ( [math score] + [reading score] + [writing score] ) as total_score
,round((count(gender) / sum( [math score] + [reading score] + [writing score] ))*100,4) as ratio
from Exams..Results
where [test preparation course] = 'completed' and ( [math score] + [reading score] + [writing score] ) >= 250
group by gender, ( [math score] + [reading score] + [writing score] )
order by gender, ratio desc

select gender
,round((count(gender) / sum( [math score] + [reading score] + [writing score] ))*100,4) as ratio
from Exams..Results
where [test preparation course] = 'completed' and ( [math score] + [reading score] + [writing score] ) >= 250
group by gender
order by ratio desc

--gender	ratio
--male	0,3731
--female	0,3697
  

--(High score)Male vs Female by Ration (gender_count / sum(total_score) with none test prep

select gender, ( [math score] + [reading score] + [writing score] ) as total_score
,round((count(gender) / sum( [math score] + [reading score] + [writing score] ))*100,4) as ratio
from Exams..Results
where [test preparation course] = 'none' and ( [math score] + [reading score] + [writing score] ) >= 250
group by gender, ( [math score] + [reading score] + [writing score] )
order by gender, ratio desc

select gender
,round((count(gender) / sum( [math score] + [reading score] + [writing score] ))*100,4) as ratio
from Exams..Results
where [test preparation course] = 'none' and ( [math score] + [reading score] + [writing score] ) >= 250
group by gender
order by ratio desc

--gender	ratio
--male	0,3832
--female	0,3724