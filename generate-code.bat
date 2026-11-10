@echo off
setlocal

REM SaxonJ-HE 13.1 location
set "SAXON_JAR=C:\SaxonHE13-1J\saxon-he-13.1.jar"
set "SAXON_LIB=C:\SaxonHE13-1J\lib\*"

REM Always run relative to the folder containing this .bat file
cd /d "%~dp0"

where java >nul 2>&1
if errorlevel 1 (
    echo ERROR: Java was not found in PATH. Install Java.
    exit /b 1
)
if not exist "%SAXON_JAR%" (
    echo ERROR: Saxon JAR not found: %SAXON_JAR%
    exit /b 1
)
if not exist "project.xml" (
    echo ERROR: project.xml was not found in %CD%
    exit /b 1
)

RMDIR "testFiles" /S /Q

@REM  call :transform "test.xsl" || exit /b 1
call :transform "FeuilleClasses.xsl" || exit /b 1


echo.
echo SUCCESS: All XSLT transformations completed.
exit /b 0

:transform
if not exist "%~1" (
    echo ERROR: Stylesheet not found: %~1
    exit /b 1
)
echo.
echo ===== Running %~1 =====
java -cp "%SAXON_JAR%;%SAXON_LIB%" net.sf.saxon.Transform -t -s:project.xml -xsl:"%~1"
if errorlevel 1 (
    echo ERROR: Transformation failed: %~1
    exit /b 1
)
exit /b 0
