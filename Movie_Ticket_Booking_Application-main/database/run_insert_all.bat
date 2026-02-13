@echo off
echo ============================================
echo   Adding Seats to ALL 468 Screens
echo ============================================
echo.
echo This will add 70,200 seats total:
echo - 468 screens
echo - 150 seats per screen
echo - 45 Premium + 60 Regular + 45 Economy
echo.
echo This may take 1-2 minutes...
echo ============================================
echo.

cd /d "%~dp0"
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p12345678 antipromovie < insert_all_seats.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================
    echo   SUCCESS!
    echo ============================================
    echo 70,200 seats added to all 468 screens!
    echo.
    echo Every movie, every theatre, every timing
    echo now has seats available!
    echo ============================================
) else (
    echo.
    echo ERROR! Check above for details.
)

echo.
pause
