@echo off
echo Running SQL script to populate movies...
echo.
echo Please enter your MySQL root password when prompted
echo.

cd /d "%~dp0"

REM Try to find MySQL executable
set MYSQL_PATH=

if exist "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" (
    set MYSQL_PATH=C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe
) else if exist "C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql.exe" (
    set MYSQL_PATH=C:\Program Files\MySQL\MySQL Server 5.7\bin\mysql.exe
) else if exist "C:\xampp\mysql\bin\mysql.exe" (
    set MYSQL_PATH=C:\xampp\mysql\bin\mysql.exe
) else if exist "C:\wamp64\bin\mysql\mysql8.0.27\bin\mysql.exe" (
    set MYSQL_PATH=C:\wamp64\bin\mysql\mysql8.0.27\bin\mysql.exe
) else (
    echo ERROR: MySQL not found!
    echo Please update this script with your MySQL path
    pause
    exit /b 1
)

echo Found MySQL at: %MYSQL_PATH%
echo.

"%MYSQL_PATH%" -u root -p antipromovie < populate_movies_all_cities.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo SUCCESS! Movies have been added to the database!
    echo.
    echo Go to http://localhost:3000 and select a city to see movies!
) else (
    echo.
    echo ERROR! Something went wrong.
    echo Please check your MySQL password and database name.
)

echo.
pause
