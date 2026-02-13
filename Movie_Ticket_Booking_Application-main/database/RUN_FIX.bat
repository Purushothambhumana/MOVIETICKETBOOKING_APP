@echo off
echo ========================================
echo DATABASE FIX SCRIPT
echo ========================================
echo.

REM Try to find MySQL installation
set MYSQL_PATH=
if exist "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" (
    set MYSQL_PATH=C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe
) else if exist "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe" (
    set MYSQL_PATH=C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe
) else if exist "C:\Program Files (x86)\MySQL\MySQL Server 8.0\bin\mysql.exe" (
    set MYSQL_PATH=C:\Program Files (x86)\MySQL\MySQL Server 8.0\bin\mysql.exe
) else if exist "C:\xampp\mysql\bin\mysql.exe" (
    set MYSQL_PATH=C:\xampp\mysql\bin\mysql.exe
) else (
    echo ERROR: MySQL not found!
    echo Please run COMPLETE_FIX.sql manually in MySQL Workbench
    pause
    exit /b 1
)

echo Found MySQL at: %MYSQL_PATH%
echo.
echo Executing database fixes...
echo.

"%MYSQL_PATH%" -u root -p12345678 antipromovie < COMPLETE_FIX.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo SUCCESS! Database fixes applied
    echo ========================================
    echo.
    echo - Seats added to all screens
    echo - Movies set to NOW_SHOWING status
    echo.
    echo Please refresh your browser!
) else (
    echo.
    echo ========================================
    echo ERROR: Failed to execute SQL
    echo ========================================
    echo.
    echo Please run COMPLETE_FIX.sql manually in MySQL Workbench
)

echo.
pause
