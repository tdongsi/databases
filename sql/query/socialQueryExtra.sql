/* More SQL queries for the social datbase */
/* Creating the database with create/social.sql */

/* Q1: For every situation where student A likes student B, but we have no information about whom B likes 
(that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. */

select H1.name, H1.grade, H2.name, H2.grade
from (
select ID1, ID2
from Likes
where ID2 not in ( select ID1 from Likes )
) as OWL join Highschooler as H1 on (OWL.ID1 = H1.ID)
join Highschooler as H2 on (OWL.ID2 = H2.ID);

/* Shorter alternative */
select H1.name, H1.grade, H2.name, H2.grade
from (Likes join Highschooler as H1 on (Likes.ID1 = H1.ID)) join Highschooler as H2 on (Likes.ID2 = H2.ID)
where ID2 not in (select ID1 from Likes);



/* Q2: For every situation where student A likes student B, but student B likes a different student C,
return the names and grades of A, B, and C. */
select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from ( ( (
select L1.ID1 as ID1, L1.ID2 as ID2, L2.ID2 as ID3
from Likes as L1 join Likes as L2 on (L1.ID2 = L2.ID1)
where L2.ID2 <> L1.ID1
) as Triangle
join Highschooler as H1 on (Triangle.ID1 = H1.ID) )
join Highschooler as H2 on (Triangle.ID2 = H2.ID) )
join Highschooler as H3 on (Triangle.ID3 = H3.ID);



/* Q3: Find those students for whom all of their friends are in different grades from themselves. 
Return the students' names and grades. */
select name, grade
from Highschooler
where ID not in (
select distinct H1.ID
from Friend join Highschooler as H1 on (ID1 = H1.ID)
join Highschooler as H2 on (ID2 = H2.ID)
where H1.ID <> H2.ID and H1.grade = H2.grade
);

/* Subquery: find students with at least one friend in same grade */
select distinct H1.ID
from Friend join Highschooler as H1 on (ID1 = H1.ID)
join Highschooler as H2 on (ID2 = H2.ID)
where H1.ID <> H2.ID and H1.grade = H2.grade;
