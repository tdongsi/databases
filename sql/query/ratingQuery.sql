/* SQL queries for the movie rating datbase */
/* Creating the database with create/rating.sql */


/* Find the titles of all movies directed by Steven Spielberg.  */
select title
from Movie
where director = 'Steven Spielberg';


/* Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. */
select distinct year
from Movie join Rating using (mID)
where stars >= 4
order by year;

select year
from Movie
where mID in (select distinct mID from Rating where stars >= 4)
order by year asc;

/* Find the titles of all movies that have no ratings. */
select title
from Movie
where mID not in (select distinct mID from Rating);


/* Some reviewers didn't provide a date with their rating. 
Find the names of all reviewers who have ratings with a NULL value for the date. */
select name
from Reviewer
where rID in (select distinct rID from Rating where ratingDate is null);


/* Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. 
Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. */
select name, title, stars, ratingDate
from ((Rating join Movie using (mID)) join Reviewer using (rID))
order by name, title, stars;

/* For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, 
return the reviewer's name and the title of the movie. */
select name, title
from ((
(
select Rating2.rID as rID, Rating2.mID as mID
from Rating as Rating1, Rating as Rating2
where Rating1.rID = Rating2.rID and Rating1.mID = Rating2.mID 
and Rating2.stars > Rating1.stars and Rating2.ratingDate > Rating1.ratingDate
)
join Movie using (mID))
join Reviewer using (rID))
;

select name, title
from Rating as R1, Rating as R2, Reviewer, Movie
where R2.rID = R1.rID and R2.mID = R1.mID and R2.ratingDate > R1.ratingDate and R2.stars > R1.stars 
and R2.mID = Movie.mID and R2.rID = Reviewer.rID;


/* For each movie that has at least one rating, find the highest number of stars that movie received. 
Return the movie title and number of stars. Sort by movie title. */


/* List movie titles and average ratings, from highest-rated to lowest-rated. 
If two or more movies have the same average rating, list them in alphabetical order. */


/* Find the names of all reviewers who have contributed three or more ratings. 
(As an extra challenge, try writing the query without HAVING or without COUNT.) */
