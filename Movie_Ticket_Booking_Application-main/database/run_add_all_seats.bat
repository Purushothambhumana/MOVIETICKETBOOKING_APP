@echo off
echo ============================================
echo   Adding Seats to ALL Screens
echo ============================================
echo.
echo This will add 150 seats to EVERY screen:
echo - 45 Premium seats (Rows A-C) @ Rs.300
echo - 60 Regular seats (Rows D-G) @ Rs.200
echo - 45 Economy seats (Rows H-J) @ Rs.150
echo.
echo This ensures every movie, every theatre,
echo every timing has seats available!
echo.
echo ============================================
echo.

cd /d "%~dp0"
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p12345678 antipromovie < add_seats_all_screens.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================
    echo   SUCCESS!
    echo ============================================
    echo Seats have been added to all screens!
    echo.
    echo Now refresh your browser and select any
    echo movie/theatre/timing - you'll see the
    echo beautiful seat selection UI!
    echo ============================================
) else (
    echo.
    echo ============================================
    echo   ERROR!
    echo ============================================
    echo Failed to add seats. Check the error above.
    echo ============================================
)

echo.
echo Press any key to exit...
pause > nul
