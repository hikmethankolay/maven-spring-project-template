rem use github gitignore templates via API
rem https://github.com/sloria/gig

rem INSTALL
rem pip install -U gig 

rem API URLS 
rem API_URL = "https://api.github.com/gitignore/templates"
rem GLOBAL_URL = "https://api.github.com/repos/github/gitignore/contents/Global/"
rem TEMPLATE_URL = "https://raw.github.com/github/gitignore/master"
rem HEADER = "########## Generated by gig ###########\n"

rem USAGE
rem gig list
rem gig list --global
rem gig Python Ruby > .gitignore
rem gig C C++ CMake Java VisualStudio

@echo off

set API_URL=https://www.toptal.com/developers/gitignore/api/c,intellij,csharp,vs,visualstudio,visualstudiocode,java,maven,c++,cmake,eclipse,netbeans
set OUTPUT_FILE=.gitignore

REM Set the running folder to the current working folder
cd /d "%~dp0"

REM Download the API results using curl
curl -s -o %OUTPUT_FILE% %API_URL%

echo Downloaded .gitignore file from %API_URL% and saved as %OUTPUT_FILE%

REM Append '**/desktop.ini' to .gitignore
echo **/desktop.ini >> %OUTPUT_FILE%

echo Appended '**/desktop.ini' to %OUTPUT_FILE%

pause

