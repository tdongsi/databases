(:***************************************************************
XQuery exercises for country data.
The XML data file is from: databases/xml/data/countries.xml
****************************************************************:)

(:***************************************************************
Return the area of Mongolia. 
****************************************************************:)
doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country[@name="Mongolia"]/data(@area)

(:***************************************************************
Return the names of all cities that have the same name as the country in which they are located. 
****************************************************************:)
for $c in doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country
let $name := $c/data(@name)
return $c/city[name = $name]/name

(:***************************************************************
Return the average population of Russian-speaking countries.
****************************************************************:)
avg(doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country[language="Russian"]/data(@population))

let $a := avg(doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country[language="Russian"]/data(@population))
return $a

(:***************************************************************
Return the names of all countries where over 50% of the population speaks German. 
****************************************************************:)
for $c in doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country/language[text() = "German"  and @percentage > 50]
return $c/../data(@name)

(:***************************************************************
Return the name of the country with the highest population. 
****************************************************************:)
let $max := max( doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country/data(@population) )
for $c in doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country
where $c/data(@population) = $max
return $c/data(@name)


