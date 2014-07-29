/**************************************************************
  SUBQUERIES IN THE FROM AND SELECT CLAUSES
  Works for MySQL and Postgres
  SQLite doesn't support All
  Works on data, created by college.sql.
**************************************************************/

/**************************************************************
  Students whose scaled GPA changes GPA by more than 1
**************************************************************/

select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
from Student
where GPA*(sizeHS/1000.0) - GPA > 1.0
   or GPA - GPA*(sizeHS/1000.0) > 1.0;

/*** Can simplify using absolute value function ***/

select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
from Student
where abs(GPA*(sizeHS/1000.0) - GPA) > 1.0;

/*** Can further simplify using subquery in From ***/

select *
from (select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
      from Student) G
where abs(scaledGPA - GPA) > 1.0;

/**************************************************************
  Colleges paired with the highest GPA of their applicants
**************************************************************/

/* My attempt */
select College.cName, College.state, maxGPA
from (
select cName, max(GPA) as maxGPA
from Apply join Student using (sID)
group by cName
) as G join College using (cName);

select cName, state, 
(
select max(GPA)
from Apply join Student using (sID)
group by cName
) as maxGPA
from College;

/* End of My attempt */

select College.cName, state, GPA
from College, Apply, Student
where College.cName = Apply.cName
  and Apply.sID = Student.sID
  and GPA >= all
          (select GPA from Student, Apply
           where Student.sID = Apply.sID
             and Apply.cName = College.cName);

/*** Add Distinct to remove duplicates ***/

select distinct College.cName, state, GPA
from College, Apply, Student
where College.cName = Apply.cName
  and Apply.sID = Student.sID
  and GPA >= all
          (select GPA from Student, Apply
           where Student.sID = Apply.sID
             and Apply.cName = College.cName);

/*** Use subquery in Select ***/

select distinct cName, state,
  (select distinct GPA
   from Apply, Student
   where College.cName = Apply.cName
     and Apply.sID = Student.sID
     and GPA >= all
           (select GPA from Student, Apply
            where Student.sID = Apply.sID
              and Apply.cName = College.cName)) as GPA
from College;

/*** Now pair colleges with names of their applicants
    (doesn't work due to multiple rows in subquery result) ***/

select distinct cName, state,
  (select distinct sName
   from Apply, Student
   where College.cName = Apply.cName
     and Apply.sID = Student.sID) as sName
from College;
