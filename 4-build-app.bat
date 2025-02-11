@echo off

:: Enable necessary extensions
@setlocal enableextensions

echo Get the current directory
set "currentDir=%CD%"

echo Change the current working directory to the script directory
@cd /d "%~dp0"

echo Delete the "docs" folder and its contents
rd /S /Q "template_app\target\site\coverxygen"
rd /S /Q "template_app\target\site\coveragereport"
rd /S /Q "template_app\target\site\doxygen"

echo Delete the "release" folder and its contents
rd /S /Q "release"
mkdir release


echo Change directory to template_app
cd template_app

echo Perform Maven clean, test, and packaging
call mvnw clean test package
if errorlevel 1 (
    echo "Maven build failed."
	pause
    exit /b 1
	
)

echo Return to the previous directory
cd ..

echo Create required subfolders
mkdir "%currentDir%\template_app\target\site\coverxygen"
mkdir "%currentDir%\template_app\target\site\coveragereport"
mkdir "%currentDir%\template_app\target\site\doxygen"

echo Generate Doxygen HTML and XML Documentation
call doxygen Doxyfile
if errorlevel 1 (
    echo "Doxygen generation failed."
	pause
    exit /b 1
	
)

echo Generate ReportGenerator HTML Report
call reportgenerator "-reports:template_app\target\site\jacoco\jacoco.xml" "-sourcedirs:template_app\src\main\java" "-targetdir:template_app\target\site\coveragereport" -reporttypes:Html
if errorlevel 1 (
    echo "ReportGenerator HTML report failed."
	pause
    exit /b 1
	
)

echo Generate ReportGenerator Badges
call reportgenerator "-reports:template_app\target\site\jacoco\jacoco.xml" "-sourcedirs:template_app\src\main\java" "-targetdir:template_app\target\site\coveragereport" -reporttypes:Badges
if errorlevel 1 (
    echo "ReportGenerator badges failed."
	pause
    exit /b 1
	
)

echo Run Coverxygen
call python -m coverxygen --xml-dir ./template_app/target/site/doxygen/xml --src-dir ./ --format lcov --output ./template_app/target/site/coverxygen/lcov.info --prefix %currentDir%/template_app/
if errorlevel 1 (
    echo "Coverxygen failed."
	pause
    exit /b 1
	
)

echo Run lcov genhtml
call perl C:\ProgramData\chocolatey\lib\lcov\tools\bin\genhtml --legend --title "Documentation Coverage Report" ./template_app/target/site/coverxygen/lcov.info -o template_app/target/site/coverxygen
if errorlevel 1 (
    echo "lcov genhtml failed."
	pause
    exit /b 1
	
)

echo Copy badge files to the "assets" directory
call copy "template_app\target\site\coveragereport\badge_combined.svg" "assets\badge_combined.svg"
call copy "template_app\target\site\coveragereport\badge_branchcoverage.svg" "assets\badge_branchcoverage.svg"
call copy "template_app\target\site\coveragereport\badge_linecoverage.svg" "assets\badge_linecoverage.svg"
call copy "template_app\target\site\coveragereport\badge_methodcoverage.svg" "assets\badge_methodcoverage.svg"

echo Copy the "assets" folder and its contents to "maven site images" recursively
call robocopy assets "template_app\src\site\resources\assets" /E

echo Copy the "README.md" file to "template_app\src\site\markdown\readme.md"
call copy README.md "template_app\src\site\markdown\readme.md"

cd template_app

echo Perform Maven site generation
call mvnw site
if errorlevel 1 (
    echo "Maven site generation failed."
	pause
    exit /b 1
)
cd ..

echo Package Output Jar Files
tar -czvf release\application-binary.tar.gz -C template_app\target *.jar

echo Package Jacoco Test Coverage Report
call tar -czvf release\test-jacoco-report.tar.gz -C template_app\target\site\jacoco .

echo Package ReportGenerator Test Coverage Report
call tar -czvf release\test-coverage-report.tar.gz -C template_app\target\site\coveragereport .

echo Package Code Documentation
call tar -czvf release\application-documentation.tar.gz -C template_app\target\site\doxygen .

echo Package Documentation Coverage
call tar -czvf release\doc-coverage-report.tar.gz -C template_app\target\site\coverxygen .

echo Package Product Site
call tar -czvf release\application-site.tar.gz -C template_app\target\site .

echo ....................
echo Operation Completed!
echo ....................
pause
