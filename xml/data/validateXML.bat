:: Usage:
:: validateXML.bat doc.xml
:: Returns 0 if the XML doc is valid 
@echo off
C:\cygwin\bin\xmllint.exe --valid --noout %1%
echo Result: %errorlevel%