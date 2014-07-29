/* SQL queries for the social datbase */
/* Creating the database with create/social.sql */

/* Find the names of all students who are friends with someone named Gabriel. */
select H1.name
from (Friend join Highschooler as H1 on ID1 = H1.ID) join Highschooler as H2 on ID2 = H2.ID
where H2.name = 'Gabriel';


/* For every student who likes someone 2 or more grades younger than themselves, 
return that student's name and grade, and the name and grade of the student they like. */
select H1.name, H1.grade, H2.name, H2.grade
from (Likes join Highschooler as H1 on ID1 = H1.ID) join Highschooler as H2 on ID2 = H2.ID
where H1.grade - H2.grade >= 2;

/* For every pair of students who both like each other, return the name and grade of both students. 
Include each pair only once, with the two names in alphabetical order. */
select H1.name, H1.grade, H2.name, H2.grade
from (
(select L1.ID1, L1.ID2
from Likes as L1, Likes as L2
where L1.ID1 = L2.ID2 and L1.ID2 = L2.ID1) as MutualLike join Highschooler as H1 on ID1 = H1.ID) 
join Highschooler as H2 on ID2 = H2.ID
where H2.name > H1.name;

/* Find names and grades of students who only have friends in the same grade. 
Return the result sorted by grade, then by name within each grade. */
select name, grade
from Highschooler
where ID not in (
select distinct H1.ID as ID
from (Friend join Highschooler as H1 on ID1 = H1.ID) join Highschooler as H2 on ID2 = H2.ID
where H2.grade <> H1.grade
)
order by grade, name;

/* Find the name and grade of all students who are liked by more than one other student. */
select name, grade
from (
select ID2
from Likes
group by ID2
having count(distinct ID1) > 1) join Highschooler on ID2 = ID;

