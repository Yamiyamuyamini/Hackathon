
use college;
-- Analyze how movies directed by different directors perform in terms of gross earnings. Are there any noticeable trends or patterns?
select director,round(avg(IMDB_Rating),1) as rating, round(avg(gross),0) as average_gross
from hackathon
group by director
order by average_gross desc;
-- Investigate how different genres have evolved in popularity over time.
select genre,released_year as year,round(avg(IMDB_Rating),1) as rating,
dense_rank() over(order by avg(IMDB_Rating) desc ) as popularity
from hackathon
group by genre,year
order by popularity;

--  Explore if there's a relationship between a movie's IMDB rating and its box office earnings.
select Series_Title,round(avg(gross),1) avg_gross, avg(IMDB_Rating) avg_ratings ,
dense_rank() over(order by avg(gross) ) as gross,
dense_rank() over (order by avg(IMDB_Rating) )as ratings
from hackathon
where gross>=0
group by Series_Title
order by gross,ratings;

-- Examine whether the duration of a movie influences its ratings or financial success.
select  Series_Title, avg(runtime) as runtime ,avg(IMDB_Rating) as ratings , avg(gross) as gross,
dense_rank() over(order by avg(runtime) desc ) as rank_runtime
from hackathon
where gross>=0
group by Series_Title
limit 6;

-- Analyze how the presence of certain actors correlates with a movie's performance in terms of ratings and earnings.
select star1,star2,star3,star4,avg(IMDB_Rating) as ratings , avg(gross) as gross
from hackathon
where gross>=0
group by star1,star2,star3,star4
order by ratings,gross desc;

-- Study the impact of a movie's release date (e.g., month, season) on its success.
select Series_Title,Released_Year,avg(IMDB_Rating) as ratings,
dense_rank() over(order by avg(IMDB_Rating) desc) as rank_ratings
from hackathon
group by series_title,Released_Year;

-- How can we rank different meta_score values based on the average gross  associated with each score, and display the results in order of success
select distinct meta_score,round(avg(gross),0) as avg_gross,
    RANK() over (order by avg(gross) desc) as success
from hackathon 
group by meta_score
order by avg_gross desc;

select meta_score,round(avg(gross),0) as gross,
dense_rank() over(order by avg(gross) asc) as success
from hackathon
where meta_score >= 0 AND gross >= 0
group by meta_score
order by success;

-- count no.of.movies for each certificate 
select certificate,count(*) as movies
from hackathon
where certificate >=0
group by certificate
order by movies desc;

--  which director is popular and his gross earnings for his best film and what is his imdb_rating
-- Step 1: Find the highest-grossing film for each director
WITH t1 AS (
    select director,series_title,gross,imdb_rating,
	row_number() over (partition by director order by  gross desc) as movie
    FROM hackathon
),
-- Step 2: Identify the director with the highest gross earnings from their best film
 best_director AS (
    select director,series_title,gross,imdb_rating
    from t1
    where movie = 1
    order by  gross desc)
-- Step 3: Retrieve IMDb rating and gross earnings for the best film of the most popular director
select director,
       series_title AS best_film,
       gross AS best_film_gross,
       imdb_rating AS best_film_imdb_rating
       from best_director
       order by best_film_imdb_rating desc;
-- francis Ford Coppola is the best director of the best film THE Godfather 
-- where his gross earnings is low but he got the best imdb_rating

-- top5 highest grossing movies
select Series_Title,gross
from hackathon
order by gross desc
limit 5;


























