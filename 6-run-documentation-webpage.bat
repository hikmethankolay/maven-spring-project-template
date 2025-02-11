@echo off
@setlocal enableextensions
@cd /d "%~dp0"

cd template_app

echo Run Web Site
echo to Exit Use CTRL+Z CTRL+C
start http://localhost:9000/
mvnw site:run

echo Operation Completed!
pause