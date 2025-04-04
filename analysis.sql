CREATE TABLE movies (
    movieId INT PRIMARY KEY,
    title VARCHAR(255),
    genres VARCHAR(255)
);

CREATE TABLE ratings (
    userId INT,
    movieId INT,
    rating FLOAT,
    timestamp BIGINT,
    FOREIGN KEY (movieId) REFERENCES movies(movieId)
);


--all movies
select * from movies limit 5


--all ratings
select * from ratings limit 5

--count of ratings per movie
select movieid , count(*) as rating_count
from ratings
group by movieid
order by rating_count desc

--avg rating per movie
select movieid , avg(rating) as avg_rating
from ratings
group by movieid
order by avg_rating desc

-- top 10 movies by avg rating (min 50 ratings)
select 
	m.title, 
	ROUND(avg(r.rating)::numeric, 2) as avg_rating , 
	count(*) as num_ratings
from ratings r
join movies m on m.movieid = r.movieid
group by m.title
having count(*) >= 50
order by avg_rating desc
limit 10

--most active users
select userid , count(*)as total_ratings
from ratings
group by userid
order by total_ratings desc
limit 10

--distribution of ratings
select rating ,  count(*) as count
from ratings
group by rating
order by rating

--avg rating per genre
WITH genre_split AS (
    SELECT
        m.movieId,
        r.rating,
        unnest(string_to_array(m.genres, '|')) AS genre
    FROM movies m
    JOIN ratings r ON m.movieId = r.movieId
)
SELECT genre, AVG(rating) AS avg_rating, COUNT(*) AS total
FROM genre_split
GROUP BY genre
ORDER BY avg_rating DESC;

--yearly trends in movie ratings
select 
	extract(year from to_timestamp(timestamp)) as year,
	avg(rating) as avg_rating
from ratings
group by year
order by year
