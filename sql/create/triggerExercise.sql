/* Q1: Write a trigger that makes new students named 'Friendly' automatically like everyone else in their grade. 
That is, after the trigger runs, we should have ('Friendly', A) in the Likes table for every other Highschooler A in the same grade as 'Friendly'. */
create trigger Friendly
after insert on Highschooler
for each row
when ( New.name = 'Friendly' )
begin
insert into Likes 
select New.ID, Target.ID from Highschooler as Target where New.grade = grade and name <> 'Friendly';
end;

/*  Q2: Write one or more triggers to manage the grade attribute of new Highschoolers. 
If the inserted tuple has a value less than 9 or greater than 12, change the value to NULL. 
On the other hand, if the inserted tuple has a null value for grade, change it to 9. 
To create more than one trigger, separate the triggers with a vertical bar (|). */
create trigger GradeCheck
after insert on Highschooler
for each row
when ( New.grade < 9 or New.grade > 12 )
begin
update Highschooler set grade = null where ID = New.ID;
end;
|
create trigger NullCheck
after insert on Highschooler
for each row
when ( New.grade is null )
begin
update Highschooler set grade = 9 where ID = New.ID;
end;

/* Q2: Test triggers */
insert into Highschooler values (2121, 'Caitlin', null);
insert into Highschooler values (2122, 'Don', null);
insert into Highschooler values (2123, 'Elaine', 7);
insert into Highschooler values (2124, 'Frank', 20);
insert into Highschooler values (2125, 'Gale', 10);

/* Q3: Write a trigger that automatically deletes students when they graduate, i.e., when their grade is updated to exceed 12. */
create trigger GraduateCheck
after update of grade on Highschooler
for each row
begin
delete from Highschooler
where grade > 12;
end;


/* Q1: Write one or more triggers to maintain symmetry in friend relationships. 
Specifically, if (A,B) is deleted from Friend, then (B,A) should be deleted too. 
If (A,B) is inserted into Friend then (B,A) should be inserted too. 
Don't worry about updates to the Friend table.  */
create trigger FriendAdd
after insert on Friend
for each row
begin
insert into Friend values( New.ID2, New.ID1 );
end;
|
create trigger FriendDelete
after delete on Friend
for each row
begin
delete from Friend
where (ID1 = Old.ID2 and ID2 = Old.ID1);
end;

/* Q1: Test triggers */
delete from Friend where ID1 = 1641 and ID2 = 1468;
delete from Friend where ID1 = 1247 and ID2 = 1911;
insert into Friend values (1510, 1934);
insert into Friend values (1101, 1709);

/* Q2: Write a trigger that automatically deletes students when they graduate, i.e., when their grade is updated to exceed 12. 
In addition, write a trigger so when a student is moved ahead one grade, then so are all of his or her friends. */
create trigger GraduateCheck
after update of grade on Highschooler
for each row
begin
delete from Highschooler
where grade > 12;
end;
|
create trigger LenLop
after update of grade on Highschooler
for each row
when ( New.grade - Old.grade = 1 )
begin
update Highschooler
set grade = grade + 1
where ID in ( select ID2 from Friend where ID1 = New.ID );
end;

/* Q2: Test triggers */
update Highschooler set grade = grade + 1 where name = 'Austin' or name = 'Kyle' or name = 'Logan';

/* Q3: Write a trigger to enforce the following behavior: If A liked B but is updated to A liking C instead, and B and C were friends, make B and C no longer friends. 
Don't forget to delete the friendship in both directions, and make sure the trigger only runs when the "liked" (ID2) person is changed but the "liking" (ID1) person is not changed. */
create trigger LoveHate
after update on Likes
for each row
when ( New.ID1 = Old.ID1 and New.ID2 <> Old.ID2 )
begin
	delete from Friend where ( ID1 = Old.ID2 and ID2 = New.ID2 );
	delete from Friend where ( ID1 = New.ID2 and ID2 = Old.ID2 );
end;

/* Q3: Test triggers */
update Likes set ID2 = 1501 where ID1 = 1911; 
update Likes set ID2 = 1316 where ID1 = 1501; 
update Likes set ID2 = 1304 where ID1 = 1934; 
update Likes set ID1 = 1661, ID2 = 1641 where ID1 = 1025; 
update Likes set ID2 = 1468 where ID1 = 1247;
