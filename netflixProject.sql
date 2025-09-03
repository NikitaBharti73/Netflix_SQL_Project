-- Netflix Project
CREATE TABLE netflix
(
    show_id	VARCHAR(10),
    type varchar(10),
    title varchar(150),	
    director varchar(210),	
    casts varchar(1000),
    country	varchar(150),
    date_added varchar(50),	
    release_year INT,	
    rating	VARCHAR(10),
	duration VARCHAR(15),
    listed_in VARCHAR(100),
    description VARCHAR(250)
	);
	select * from netflix;

1. Count the number of Movies vs TV Shows
 SELECT type ,COUNT(*) as total_content 
   FROM netflix group by type; --1
   
2. Find the most common rating for movies and TV shows
  select type, rating from
  (select type ,rating, count(*) as rating_count,
   RANK() over(PARTITION BY type ORDER BY COUNT(*) DESC)
   as ranking from netflix
   group by 1,2 ) where ranking=1
   
3. List all movies released in a specific year (e.g., 2020)
   SELECT * from netflix 
   where type='Movie' and release_year= 2020 
   
4. Find the top 5 countries with the most content on Netflix
    select unnest(string_to_array(country, ','))
	as new_country, count(show_id) as show_count
	from netflix group by new_country 
	order by count(show_id) desc limit 5

5. Identify the longest movie
   select type, duration from netflix
   where type='Movie' and 
   duration= (select max(duration) from netflix)
   
6. Find content added in the last 5 years
   select * from netflix where
   to_date(date_added, 'Month DD ,YYYY') >= current_date - interval '5 years'
  
7. Find all the movies/TV shows by director 'Rajiv Chilaka'!  
   select type ,director from netflix
   where director like '%Rajiv Chilaka%';
   
8. List all TV shows with more than 5 seasons
   select * from netflix
   where type= 'TV Show' and 
   split_part(duration, ' ', 1)::numeric >5

9. Count the number of content items in each genre
   select unnest(string_to_array(listed_in, ','))
   as genre, count(show_id) as total_counts
   from netflix 
   group by genre
   
10.Find each year and the average numbers of content release in India on netflix. 
  return top 5 year with highest avg content release!
  
  select extract(year from to_date(date_added,
  'Month DD , YYYY')) as year,
  count(*)as yearly_content,
  round( count(*) :: numeric/(Select count(*) from netflix
  where country ='India')::numeric * 100, 2)
  as avg_content_per_year
  from netflix where country='India'
  group by 1
   
11. List all movies that are documentaries
    select count(listed_in) from netflix 
   where listed_in like '%Documentaries%'
   
12. Find all content without a director
    select director,type from netflix where director is null
	
13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
    select * from netflix where casts like 
	'%Salman Khan%' and 
	release_year >Extract(year from current_date)-10
	
14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
    select unnest(string_to_array(casts, ',')) 
	as actors, count(*) as total_content
	from netflix  where country 
	like 'India' group by 1
	order by 2 desc limit 10
  
  15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
 with new_table
 as
 (select *,  case when
  description like '%kill%'
  or description like '%violence%' then 'Bad_content'
  else 'Good Content'
  end category
  from netflix
  )
  select category, count(*) as total_content
  from new_table group by 1
   

  
   