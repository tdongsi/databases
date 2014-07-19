:: Usage:
:: validateXSD.bat schema.xsd doc.xml
:: Returns 0 if the XML doc is valid
@echo off
C:\cygwin\bin\xmllint.exe --noout %2 -schema %1