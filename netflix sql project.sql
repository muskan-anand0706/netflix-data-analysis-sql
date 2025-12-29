--Netflix Project
drop table if exists netflix;


create table netflix (
show_id varchar(6),
type varchar(10),
title varchar(150),
director varchar(1000),
casts varchar(1000),
country varchar(150),
date_added varchar(50),
release_year int,
rating varchar(10),
duration varchar(50),
listed_in varchar(100),
description varchar(250)
);

--Shows all data from netflix table
select * from netflix;


--Counts total rows in netflix table
select
	count(*) as total_content
from netflix;



--Shows unique content types
select 
 	distinct type
 from netflix;


select * from netflix;


--15 business problems--


--Ques 1 count the number of movies vs tv shows
select type, count(*) as total_count
from netflix 
group by type; 



--Ques 2 find the most common rating for movies and tv shows
select type,
	rating
from 
(
select type,
rating,count(*),
rank()
over(partition by type order by count(*) desc)
as ranking
from netflix
group by 1,2
)as t1
where 
ranking=1;


--Ques 3 list all movies released in a specific year (e.g2020)
--filetr 2020
--movies 

select * from netflix
where
	type='Movie'
	and 
	release_year=2020;


--Ques 4 find the top 7 countries with the most content on netflix
select country,
	count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 7;



--Ques 5 identify the longest movie
select * from netflix
where
	type='Movie'
	and
	duration=(select max(duration) from netflix)



--Ques 6 find content added in the last 4 years
select * from netflix
where
to_date(date_added,'Month DD,YYYY')>=current_date - interval '5 years'


--Ques 7 find all the movies/ tv shows by director 'Rajiv Chilaka'
select * from (
select *,
	unnest(string_to_array(director,','))
	as director_name
	from netflix
)
where director_name='Rajiv Chilaka'



--Ques 8 list all tv shows with more than 3 seasons
select * from netflix
where 
	type='TV Show'
	and
	split_part(duration,' ',1)::int>3


--Ques 9 count the number of content items in each genre
select 
	unnest(string_to_array(listed_in,',')) 
	as genre,
	count(*) as total_content
	from netflix
	group by 1



--Ques 10 find each year and the average numbers of content release
--by India on netflix. return top 4 years with highest
--avg content release

select country, release_year,
	count(show_id) as total_release,
	round(
		count(show_id)::numeric/
		(select count(show_id) from netflix where country='India')::numeric*100,2
	)
	as avg_release
	from netflix
	where country='India'
	group by country,2
	order by avg_release desc
	limit 4




--Ques 11 list all movies that are documentaries
select * from netflix
where listed_in like '%Documentaries'



--Ques 12 find all content without a director
select * from netflix
where director is null


--Ques 13 find how many movies actor 'Salman Khan' appeared in last 10 years
select * from netflix
where
casts like '%Salman Khan%'
and
release_year > extract(year from current_date)-10


--Ques 14 find the top 10 actors who have appeared in the highest number of movies produced in India
select 
	unnest(string_to_array(casts,',')) as actor,
	count(*)
	from netflix
	where country='India'
	group by 1 
	order by 2 desc
	limit 10


/*Ques 15 Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.*/
select category,
type,
count(*) as content_count
from(
select *,
case
when description ilike '%kill%' or
description ilike '%violence%' then 'Bad'
else 'Good'
end as category
from netflix
) as categorized_content
group by 1,2
order by 2

--end of reports










