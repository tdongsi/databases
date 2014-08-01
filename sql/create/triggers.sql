/* Automatic application */
create trigger R1
after insert on Student
for each row /* optional */
when New.GPA > 3.3 and New.GPA <= 3.6
begin
	insert into Apply values ( New.sID, 'Stanford', 'geology', null );
	insert into Apply values ( New.sID, 'MIT', 'biology', null );
end;

/* Referential integrity on delete */
create trigger R2
after delete on Student
for each row
begin
	delete from Apply where sID = Old.sID;
end;

/* Referential integrity on update */
create trigger R3
after update of cName on College
for each row
begin
	update Apply
	set cName = New.cName
	where cName = Old.cName;
end;

/* Input checking: unique attributes */
create trigger R4
before insert on College
for each row
when exists (select * from College where cName = New.cName)
begin
	/* SQLite specific: raise: raise the error, ignore: no action, simply ignore, no error reported */
	select raise(ignore);
end;

create trigger R5
before update of cName on College
for each row
when exists (select * from College where cName = New.cName)
begin
	/* SQLite specific: raise: raise the error, ignore: no action, simply ignore, no error reported */
	select raise(ignore);
end;


create trigger R6
after insert on Apply
for each row
when (select count(*) from Apply where cName = New.cName ) > 10
begin
	update College set cName = cName || '-Done' /* concating text */
	where cName = New.cName;
end;

/* Check interaction with trigger R1 */
create trigger R7
before insert on Student
for each row
when New.sizeHS < 100 or New.sizeHS > 5000
begin
	select raise(ignore);
end;

/* Monitoring */
create trigger TooMany
after update of enrollment on College
for each row
when (Old.enrollment <= 16000 and New.enrollment > 16000)
begin
	delete from Apply
		where cName = New.cName and major = 'EE';
	update Apply
	set decision = 'U'
	where cName = New.cName and decision = 'Y';
end;


/* Self trigger */
/* SQLite: by default, does not allow more than one self-trigger -> 2 tuples added */
/* Use this command to turn it off: pragma recursive_triggers = on */
create trigger R1
after insert on T1
for each row
/* when (select count(*) from T1) < 10 */
begin
	insert into T1 values (New.A+1);
end;

/* Check for immediate activation */
create trigger R1
after insert on T1
for each row
begin
	insert into T2 select avg(A) from T1;
end;

/* T1 already have 4 tuples of value 1 */
select into T1 select A+1 from T1;