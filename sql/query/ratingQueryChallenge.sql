/* More challenging SQL query exercises for the movie rating datbase */
/* Creating the database with create/rating.sql */

/* Q1: For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. 
Sort by rating spread from highest to lowest, then by movie title. */
select max(stars) - min(stars), max(stars), min(stars)
from Rating
group by mID;

select title, (max(stars) - min(stars)) as spread
from Rating join Movie using (mID)
group by mID
order by spread desc, title;





/* Q2: Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
Don't just calculate the overall average rating before and after 1980.) */
select avg(beforeAvg) - avg(afterAvg)
from (
select avg(stars) as beforeAvg
from Rating join Movie using (mID)
where year < 1980
group by mID)
join (
select avg(stars) as afterAvg
from Rating join Movie using (mID)
where year > 1980
group by mID
);

/* The average rating of movies released before 1980 and the average rating of movies released after 1980 */
select avg(beforeAvg), avg(afterAvg)
/* select * */
from (
select avg(stars) as beforeAvg
from Rating join Movie using (mID)
where year < 1980
group by mID)
join (
select avg(stars) as afterAvg
from Rating join Movie using (mID)
where year > 1980
group by mID
);

/* The average rating for EACH of movies released before 1980 */
select mID, avg(stars)
from Rating join Movie using (mID)
where year < 1980
group by mID;

/* The average rating for EACH of movies released after 1980 */
select mID, avg(stars)
from Rating join Movie using (mID)
where year > 1980
group by mID;






/* Q3: Some directors directed more than one movie. 
For all such directors, return the titles of all movies directed by them, along with the director name. 
Sort by director name, then movie title. 
(As an extra challenge, try writing the query both with and without COUNT.) */
select title, director
from Movie
where director in (
select director
from Movie
group by director
having count(director) > 1 )
order by director, title;






/* Q4: Find the movie(s) with the highest average rating. 
Return the movie title(s) and average rating. 
(Hint: This query is more difficult to write in SQLite than other systems; 
you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) */

select title, avgRating
from Movie join
(
select mID, avgRating
from (select mID, avg(stars) as avgRating
from Rating
group by mID)
where avgRating = (
select max(avgRating)
from
(select mID, avg(stars) as avgRating
from Rating
group by mID) )
) using (mID);

/* For current SQLite on Edx: this return random mID */
select mID, max(avgRating) as maxRating
from
(select mID, avg(stars) as avgRating
from Rating
group by mID);

/* Fixing the above */
select mID, avgRating
from (select mID, avg(stars) as avgRating
from Rating
group by mID)
where avgRating = (
select max(avgRating)
from
(select mID, avg(stars) as avgRating
from Rating
group by mID) );




/* Q5: Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. */
select title, avgRating
from Movie join
(
select mID, avgRating
from (select mID, avg(stars) as avgRating
from Rating
group by mID)
where avgRating = (
select min(avgRating)
from
(select mID, avg(stars) as avgRating
from Rating
group by mID) )
) using (mID);




/* Q6: For each director, return the director's name together with the title(s) of the movie(s) 
they directed that received the highest rating among all of their movies, and the value of that rating. 
Ignore movies whose director is NULL. */

select director, title, max(stars)
from Rating join Movie using (mID)
where director is not null
group by director;