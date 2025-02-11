@echo off
@setlocal enableextensions
@cd /d "%~dp0"

echo Running Application
java -jar template_app/target/template_app-1.0.jar

echo Operation Completed!
pause