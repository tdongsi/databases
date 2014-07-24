/* SQL queries for the movie rating datbase */
/* Creating the database with create/rating.sql */


/* Find the titles of all movies directed by Steven Spielberg.  */
select title
from Movie
where director = 'Steven Spielberg';


/* Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. */


/* Find the titles of all movies that have no ratings. */


/* Some reviewers didn't provide a date with their rating. 
Find the names of all reviewers who have ratings with a NULL value for the date. */


/* Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. 
Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. */


/* For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, 
return the reviewer's name and the title of the movie. */



/* For each movie that has at least one rating, find the highest number of stars that movie received. 
Return the movie title and number of stars. Sort by movie title. */


/* List movie titles and average ratings, from highest-rated to lowest-rated. 
If two or more movies have the same average rating, list them in alphabetical order. */


/* Find the names of all reviewers who have contributed three or more ratings. 
(As an extra challenge, try writing the query without HAVING or without COUNT.) */
