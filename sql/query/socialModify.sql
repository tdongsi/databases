/* SQL modifications for the social datbase */
/* Creating the database with createScript/social.sql */

/* It's time for the seniors to graduate. Remove all 12th graders from Highschooler. */
Delete From Highschooler
where grade = 12;



/* If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. */
Delete From Likes
where ID1 in (select OneSide.ID1 as ID1
from Friend,
(select * from Likes
except
select L1.ID1 as ID1, L1.ID2 as ID2
from Likes L1, Likes L2
where L1.ID1 = L2.ID2 and L1.ID2 = L2.ID1) as OneSide
where Friend.ID1 = OneSide.ID1 and Friend.ID2 = OneSide.ID2);

/* All student IDs with mutual likes */
select L1.ID1 as ID1, L1.ID2 as ID2
from Likes L1, Likes L2
where L1.ID1 = L2.ID2 and L1.ID2 = L2.ID1;

/* All one-sided likes */
select * from Likes
except
select L1.ID1 as ID1, L1.ID2 as ID2
from Likes L1, Likes L2
where L1.ID1 = L2.ID2 and L1.ID2 = L2.ID1;



/* For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. 
Do not add duplicate friendships, friendships that already exist, or friendships with oneself. 
(This one is a bit challenging; congratulations if you get it right.) */
insert into Friend
select ID1, ID2
from
(
select F1.ID1 as ID1, F2.ID2 as ID2
from Friend as F1, Friend as F2
where F1.ID2 = F2.ID1 and F1.ID1 < F2.ID2

union

select F2.ID2 as ID1, F1.ID1 as ID2
from Friend as F1, Friend as F2
where F1.ID2 = F2.ID1 and F1.ID1 < F2.ID2

except

select * from Friend
)
;

/* All unique links that need to be added (one direction) */
select F1.ID1 as ID1, F2.ID2 as ID2
from Friend as F1, Friend as F2
where F1.ID2 = F2.ID1 and F1.ID1 < F2.ID2
except
select * from Friend;

/* Display the names for checking the above additonal links */
select ID1, name, ID2
from Highschooler join (
select F1.ID1 as ID1, F2.ID2 as ID2
from Friend as F1, Friend as F2
where F1.ID2 = F2.ID1 and F1.ID1 < F2.ID2
except
select * from Friend) on (ID = ID1);
