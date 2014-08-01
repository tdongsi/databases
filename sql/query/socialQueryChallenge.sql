/* More challenging SQL queries for the social datbase */
/* Creating the database with create/social.sql */


/* Q1: For every situation where student A likes student B, but we have no information about whom B likes 
(that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. */
select H1.name, H1.grade, H2.name, H2.grade
from (Likes join Highschooler as H1 on (Likes.ID1 = H1.ID)) join Highschooler as H2 on (Likes.ID2 = H2.ID)
where ID2 not in (select ID1 from Likes);

/* Q2: For every situation where student A likes student B, but student B likes a different student C, 
return the names and grades of A, B, and C. */
select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from ( (
(select L1.ID1 as ID1, L2.ID1 as ID2, L2.ID2 as ID3
from Likes as L1 join Likes as L2 on (L1.ID2 = L2.ID1)
where L1.ID1 <> L2.ID2) as Triangle
join Highschooler as H1 on (Triangle.ID1 = H1.ID) )
join Highschooler as H2 on (Triangle.ID2 = H2.ID) )
join Highschooler as H3 on (Triangle.ID3 = H3.ID);

/* Find the triangle love */
select L1.ID1 as ID1, L2.ID1 as ID2, L2.ID2 as ID3
from Likes as L1 join Likes as L2 on (L1.ID2 = L2.ID1)
where L1.ID1 <> L2.ID2;




/* Q1: Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. 
Sort by grade, then by name within each grade. */
select name, grade
from Highschooler
where ID not in (
select distinct ID1 as ID from Likes
union
select distinct ID2 as ID from Likes
)
order by grade, name;




/* Q2: For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). 
For all such trios, return the name and grade of A, B, and C. */
select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from ( (
(
select L.ID1 as ID1, L.ID2 as ID2, F1.ID2 as ID3
from (
select ID1, ID2 from Likes
except
select ID1, ID2 from Friend
) 
as L, Friend as F1, Friend as F2
where ( L.ID1 = F1.ID1
and L.ID2 = F2.ID1
and F1.ID2 = F2.ID2 )
) as Mutual
join Highschooler as H1 on (Mutual.ID1 = H1.ID) )
join Highschooler as H2 on (Mutual.ID2 = H2.ID) )
join Highschooler as H3 on (Mutual.ID3 = H3.ID);

/* Find the mutual friends
L: A likes B but A is not friend of B */
select L.ID1 as ID1, L.ID2 as ID2, F1.ID2 as ID3
from (
select ID1, ID2 from Likes
except
select ID1, ID2 from Friend
) 
as L, Friend as F1, Friend as F2
where ( L.ID1 = F1.ID1
and L.ID2 = F2.ID1
and F1.ID2 = F2.ID2 );





/* Q3: Find the difference between the number of students in the school and the number of different first names. */
select count(*) as studentNum
from Highschooler;

select count(*) as nameNum
from (select distinct name from Highschooler);

select studentNum - nameNum
from 
(select count(*) as studentNum
from Highschooler) as N1 join
(select count(*) as nameNum
from (select distinct name from Highschooler)) as N2;




/* Q4: What is the average number of friends per student? */
select avg(friendCount)
from (
select ID1, count(*) as friendCount
from Friend
group by ID1);



/* Q5: Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. 
Do not count Cassandra, even though technically she is a friend of a friend. */

/* number of friends */
select count(*)
from Friend join Highschooler on (Friend.ID1 = Highschooler.ID)
where name = 'Cassandra';

/* friends' ID */
select ID2
from Friend join Highschooler on (Friend.ID1 = Highschooler.ID)
where name = 'Cassandra';

union

/* friends of friends' ID */
select Friend.ID2 as ID2
from (
select ID1, ID2 
from Friend join Highschooler on (Friend.ID1 = Highschooler.ID)
where name = 'Cassandra' ) as FriendOfCass
join Friend on (FriendOfCass.ID2 = Friend.ID1)
where FriendOfCass.ID1 <> Friend.ID2;

/* Combine them with union */
select count(*)
from
(
select *
from
(
select ID2
from Friend join Highschooler on (Friend.ID1 = Highschooler.ID)
where name = 'Cassandra'
) as FriendTable

union

select *
from
(
select Friend.ID2 as ID2
from (
select ID1, ID2 
from Friend join Highschooler on (Friend.ID1 = Highschooler.ID)
where name = 'Cassandra' ) as FriendOfCass
join Friend on (FriendOfCass.ID2 = Friend.ID1)
where FriendOfCass.ID1 <> Friend.ID2
) as FoFTable
);




/* Q6: Find the name and grade of the student(s) with the greatest number of friends. */
/* See ratingQueryChallenge.sql Q4 for why */
select name, grade
from Highschooler join
(
select ID1 as ID, count(*) as friendCount
from Friend
group by ID1
) using (ID)
where friendCount = 
(
select max(friendCount)
from 
(
select ID1, count(*) as friendCount
from Friend
group by ID1
)
);