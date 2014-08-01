/* SQL queries for the movie rating datbase */
/* Creating the database with create/rating.sql */

/* Q1: Find the names of all reviewers who rated Gone with the Wind. */
select distinct name
from ((Rating join Reviewer using (rID)) join Movie using (mID))
where title = 'Gone with the Wind';

/* Better alternative */
select name
from Reviewer
where rID in (
select rID
from Rating join Movie using (mID)
where title = 'Gone with the Wind' );



/* Q2: For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. */
select name, title, stars
from ((Rating join Reviewer using (rID)) join Movie using (mID))
where director = name;



/* Q3: Return all reviewer names and movie names together in a single list, alphabetized. */
select name
from 
(
select name from Reviewer
union
select title as name from Movie
)
order by name;



/* Q4: Find the titles of all movies not reviewed by Chris Jackson. */
select title
from Movie
where mID not in (
select mID
from Rating join Reviewer using (rID)
where name = 'Chris Jackson'
);



/* Q5: For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. 
Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. 
For each pair, return the names in the pair in alphabetical order. */
select Reviewer1.name, Reviewer2.name
from ( (
select distinct R1.rID as ID1, R2.rID as ID2
from Rating as R1 join Rating as R2 using (mID)
where R1.rID > R2.rID
) join Reviewer as Reviewer1 on (ID1=Reviewer1.rID) )
join Reviewer as Reviewer2 on (ID2=Reviewer2.rID)
order by Reviewer1.name;


select Reviewer1.name, Reviewer2.name
from ( (
select distinct R1.rID as ID1, R2.rID as ID2
from Rating as R1 join Rating as R2 using (mID)
) join Reviewer as Reviewer1 on (ID1=Reviewer1.rID) )
join Reviewer as Reviewer2 on (ID2=Reviewer2.rID)
where Reviewer1.name < Reviewer2.name
order by Reviewer1.name;



/* Q6: For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. */
select name, title, stars
from ((Rating join Reviewer using (rID)) join Movie using (mID))
where stars = (
select min(stars)
from Rating);