(:***************************************************************
More challenging XQuery exercises for course data.
The XML data file is from: databases/xml/data/courses-noID.xml
****************************************************************:)

(:***************************************************************
Return the title of the course with the largest enrollment.
****************************************************************:)
let $max := max(doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog//Course/data(@Enrollment))
for $c in doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog//Course
where $c/@Enrollment = $max
return $c/Title

(:***************************************************************
Return course numbers of courses that have the same title as some other course.
****************************************************************:)
for $c in doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog//Course
where $c[Title = following::*/Title or Title = preceding::*/Title]
return $c/data(@Number)

(:***************************************************************
Return the number (count) of courses that have no lecturers as instructors. 
****************************************************************:)
let $a := count(doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog//Course/Instructors[count(Lecturer) = 0])
return $a

(:***************************************************************
Return titles of courses taught by the chair of a department. 
For this question, you may assume that all professors have distinct last names. 
****************************************************************:)
for $d in doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog/Department
let $chair := $d/Chair//Last_Name
for $c in $d/Course
where $c//Last_Name = $chair
return $c/Title

(:***************************************************************
Return titles of courses taught by a professor with the last name "Ng" but not by a professor with the last name "Thrun". 
****************************************************************:)
for $c in doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog/Department/Course
where $c//Professor[Last_Name = "Ng"] and count($c//Professor[Last_Name = "Thrun"]) = 0
return $c/Title

(:***************************************************************
Return course numbers of courses that have a course taught by Eric Roberts as a prerequisite. 
****************************************************************:)
let $ericCourse := doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")//Course[Instructors/Professor/Last_Name = 'Roberts' and Instructors/Professor/First_Name = 'Eric']/data(@Number)
for $c in doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")//Course
where some $pre in $ericCourse satisfies $c/Prerequisites/Prereq = $pre
return $c/data(@Number)


(:***************************************************************
Create a summary of CS classes: List all CS department courses in order of enrollment. 
For each course include only its Enrollment (as an attribute) and its Title (as a subelement). 
****************************************************************:)
<Summary>
{ for $c in doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog/Department[@Code="CS"]/Course
order by xs:int($c/@Enrollment)
return <Course>
{$c/@Enrollment}
{$c/Title}
</Course> }
</Summary>



(:***************************************************************
Return a "Professors" element that contains as subelements a listing of all professors in all departments, sorted by last name with each professor appearing once. 
The "Professor" subelements should have the same structure as in the original data. 
For this question, you may assume that all professors have distinct last names. 
See http://stackoverflow.com/questions/5283548/select-distinct-values-according-to-child-node-in-xquery
****************************************************************:)
<Professors>
{
let $p :=doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")//Professor
for $name in distinct-values(doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")//Professor/Last_Name)
order by $name
return $p[index-of($p/Last_Name,$name)[1]]
}
</Professors>


