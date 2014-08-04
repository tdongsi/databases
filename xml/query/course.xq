(:***************************************************************
XQuery exercises for course data.
The XML data file is from: databases/xml/data/courses-noID.xml
****************************************************************:)

(:***************************************************************
Return all Title elements (of both departments and courses)
****************************************************************:)
doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")//Title

(:***************************************************************
Return last names of all department chairs.
****************************************************************:)
doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog/Department/Chair//Last_Name

(:***************************************************************
Return titles of courses with enrollment greater than 500. 
****************************************************************:)
doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog/Department/Course[@Enrollment > 500]/Title

(:***************************************************************
Return titles of departments that have some course that takes "CS106B" as a prerequisite. 
****************************************************************:)
for $d in doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog/Department
where $d/Course/Prerequisites[Prereq="CS106B"]
return $d/Title

(:***************************************************************
Return last names of all professors or lecturers who use a middle initial. 
Don't worry about eliminating duplicates. 
****************************************************************:)
for $d in doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog//(Professor|Lecturer)
where $d/Middle_Initial
return $d/Last_Name

(:***************************************************************
Return the count of courses that have a cross-listed course (i.e., that have "Cross-listed" in their description).
****************************************************************:)
count(doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog//Course[contains(Description, "Cross-listed")])

let $a := count(doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog//Course[contains(Description, "Cross-listed")])
return $a

(:***************************************************************
Return the average enrollment of all courses in the CS department. 
****************************************************************:)
let $a := avg(doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog/Department[@Code="CS"]/Course/data(@Enrollment))
return $a

(:***************************************************************
Return last names of instructors teaching at least one course that has "system" in its description and enrollment greater than 100. 
****************************************************************:)
for $c in doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog//Course[contains(Description,"system") and @Enrollment>100]
return $c/Instructors//Last_Name

(:***************************************************************
Return the course number of the course that is cross-listed as "LING180". 
****************************************************************:)
for $c in doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog//Course[contains(Description,"Cross-listed") and contains(Description,"LING180")]
return $c/data(@Number)

(:***************************************************************
Return course numbers of courses taught by an instructor with first name "Daphne" or "Julie".
****************************************************************:)
for $c in doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog//Course
where $c/Instructors/*[First_Name = 'Daphne' or First_Name = 'Julie']
return $c/data(@Number)

(:***************************************************************
Return titles of courses that have both a lecturer and a professor as instructors. 
Return each title only once.
****************************************************************:)
for $c in doc("E:/EpiGineer/Github/databases/xml/data/courses-noID.xml")/Course_Catalog//Course
where $c/Instructors/Professor and $c/Instructors/Lecturer
return $c/Title



