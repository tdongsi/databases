/* SQL modifications for the movie rating datbase */
/* Creating the database with createScript/rating.sql */

/* Add the reviewer Roger Ebert to your database, with an rID of 209. */
insert into Reviewer values( 209, 'Roger Ebert' );

/* Insert 5-star ratings by James Cameron for all movies in the database. 
Leave the review date as NULL. */
Insert Into Rating
select rID, mID, 5, null
from Reviewer, Movie
where name = 'James Cameron';

/* For all movies that have an average rating of 4 stars or higher, add 25 to the release year. 
(Update the existing tuples; don't insert new tuples.) */
Update Movie
Set year = year + 25
WHERE mID in (
select mID 
from Rating 
group by mID
having avg(stars) >= 4.0 );

/* Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars. */
Delete From Rating
where mID in (select mID from Movie where year < 1970 or year > 2000)
and stars < 4;

