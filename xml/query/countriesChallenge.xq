(:***************************************************************
More challenging XQuery exercises for country data.
The XML data file is from: databases/xml/data/countries.xml
****************************************************************:)

(:***************************************************************
Return the names of all countries that have at least three cities with population greater than 3 million. 
****************************************************************:)
for $c in doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country
where count($c/city[population > 3000000]) > 3
return $c/data(@name)




(:***************************************************************
Create a list of French-speaking and German-speaking countries. The result should take the form:
<result>
  <French>
    <country>country-name</country>
    <country>country-name</country>
    ...
  </French>
  <German>
    <country>country-name</country>
    <country>country-name</country>
    ...
  </German>
</result>
****************************************************************:)
<result>
<French>
{
for $c in doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country[language="French"]
return <country> {$c/data(@name)} </country>
}
</French>
<German>
{
for $c in doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country[language="German"]
return <country> {$c/data(@name)} </country>
}
</German>
</result>




(:***************************************************************
Return the names of all countries containing a city such that some other country has a city of the same name.
****************************************************************:)
for $c in doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country
where $c/city[name = preceding::country/city/name or name = following::country/city/name]
return $c/data(@name)



(:***************************************************************
Return the average number of languages spoken in countries where Russian is spoken.
****************************************************************:)
let $countryCount := count(doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country[language="Russian"])
let $lanCount := count(doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country[language="Russian"]/language)
return $lanCount div $countryCount




(:***************************************************************
Return all country-language pairs where the language is spoken in the country and the name of the country textually contains the language name. 
Return each pair as a country element with language attribute, e.g.,
<country language="French">French Guiana</country>
****************************************************************:)
for $c in doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country
let $match := $c/language[contains($c/data(@name),.)]
where some $lang in $c/language satisfies contains($c/data(@name), $lang)
return <country language="{$match}"> {$c/data(@name)}</country>




(:***************************************************************
Return all countries that have at least one city with population greater than 7 million. For each one, return the country name along with the cities greater than 7 million, in the format:
<country name="country-name">
  <big>city-name</big>
  <big>city-name</big>
  ...
</country>
****************************************************************:)
for $c in doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country
where some $city in $c/city satisfies xs:int($city/population) > 7000000
return <country>{$c/@name}
{
for $b in $c/city[population > 7000000]/name
return <big>{$b/text()}</big>
}
</country>



(:***************************************************************
Return all countries where at least one language is listed, but the total percentage for all listed languages is less than 90%. 
Return the country element with its name attribute and its language subelements, but no other attributes or subelements. 
****************************************************************:)
for $c in doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country[language]
where sum($c/language/@percentage) lt 90
return <country>{$c/@name} {$c/language}</country>



(:***************************************************************
Return all countries where at least one language is listed, and every listed language is spoken by less than 20% of the population. 
Return the country element with its name attribute and its language subelements, but no other attributes or subelements.
****************************************************************:)
for $c in doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country[language]
where every $lang in $c/language satisfies xs:float($lang/data(@percentage)) lt 20
return <country>{$c/@name} {$c/language}</country>



(:***************************************************************
Find all situations where one country's most popular language is another country's least popular, and both countries list more than one language. 
(Hint: You may need to explicitly cast percentages as floating-point numbers with xs:float() to get the correct answer.) 
Return the name of the language and the two countries, each in the format:
<LangPair language="lang-name">
  <MostPopular>country-name</MostPopular>
  <LeastPopular>country-name</LeastPopular>
</LangPair>
****************************************************************:)
for $c in doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country[count(language) > 1]
let $mostLangPer := max($c/language/data(@percentage))
let $mostLang := $c/language[./@percentage = $mostLangPer]

for $b in doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")/countries/country[count(language) > 1 and language = $mostLang and @name != $c/data(@name) ]
let $minLangPer := min($b/language/data(@percentage))
let $minLang := $b/language[./@percentage = $minLangPer]
where $minLang = $mostLang
return <LangPair language="{$mostLang/text()}"><MostPopular>{$c/data(@name)}</MostPopular> <LeastPopular>{$b/data(@name)}</LeastPopular> </LangPair>



(:***************************************************************
For each language spoken in one or more countries, create a "language" element with a "name" attribute and one "country" subelement for each country in which the language is spoken. 
The "country" subelements should have two attributes: the country "name", and "speakers" containing the number of speakers of that language (based on language percentage and the country's population). 
Order the result by language name, and enclose the entire list in a single "languages" element. 
For example, your result might look like:
<languages>
  ...
  <language name="Arabic">
    <country name="Iran" speakers="660942"/>
    <country name="Saudi Arabia" speakers="19409058"/>
    <country name="Yemen" speakers="13483178"/>
  </language>
  ...
</languages>
****************************************************************:)
let $doc := doc("E:/EpiGineer/Github/databases/xml/data/countries.xml")
return <languages>
{
for $lang in distinct-values($doc/countries/country/language)
return <language name="{$lang}">
{
for $c in $doc/countries/country[language = $lang]
let $per := xs:float($c/language[. = $lang]/data(@percentage)) div 100
return
<country name="{$c/data(@name)}" speakers="{xs:int($c/data(@population))* $per}">
</country>
}
</language>
}
</languages>


