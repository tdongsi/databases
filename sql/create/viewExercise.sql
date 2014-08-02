create view LateRating as 
  select distinct R.mID, title, stars, ratingDate 
  from Rating R, Movie M 
  where R.mID = M.mID 
  and ratingDate > '2011-01-20';
  

create view NoRating as 
  select mID, title 
  from Movie 
  where mID not in (select mID from Rating) 

  
/* Q1: Write an instead-of trigger that enables updates to the title attribute of view LateRating. */
create trigger LateRatingUpdateTitle
instead of update of title on LateRating
for each row
begin
update Movie
set title = New.title
where mID = New.mID and title = Old.title;
end;


/* Q2: Write an instead-of trigger that enables updates to the stars attribute of view LateRating. */
create trigger LateRatingUpdateStars
instead of update of stars on LateRating
for each row
begin
update Rating
set stars = New.stars
where mID = New.mID and New.ratingDate > '2011-01-20' and ratingDate > '2011-01-20';
end;

/* Q3: Write an instead-of trigger that enables updates to the mID attribute of view LateRating. */
/* Updates to attribute mID in LateRating should update Movie.mID and Rating.mID for the corresponding movie.*/
create trigger LateRatingUpdateMid
instead of update of mID on LateRating
for each row
begin
update Rating
set mID = New.mID
where mID = Old.mID and New.ratingDate > '2011-01-20';
update Movie
set mID = New.mID
where mID = Old.mID and New.ratingDate > '2011-01-20';
end;

create trigger LateRatingUpdateMid
instead of update of mID on LateRating
for each row
when (New.ratingDate > '2011-01-20')
begin
update Rating
set mID = New.mID
where mID = Old.mID;
update Movie
set mID = New.mID
where mID = Old.mID;
end;

create view HighlyRated as 
  select mID, title 
  from Movie 
  where mID in (select mID from Rating where stars > 3) 
  
/* Q4: Write an instead-of trigger that enables deletions from view HighlyRated. */
create trigger HighlyRatedDelete
instead of delete on HighlyRated
for each row
begin
delete from Rating
where mID = Old.mID and stars > 3;
end;

/* Q5: Write an instead-of trigger that enables deletions from view HighlyRated. */
create trigger HighlyRatedDelUpdate
instead of delete on HighlyRated
for each row
begin
update Rating
set stars = 3
where mID = Old.mID and stars > 3;
end;

