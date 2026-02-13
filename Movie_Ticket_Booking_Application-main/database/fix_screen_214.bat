@echo off
echo Adding 150 seats to screen 214...
echo.

cd /d "%~dp0"
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p12345678 antipromovie < fix_screen_214.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo SUCCESS! 150 seats added to screen 214
    echo - 45 Premium seats (Rows A-C)
    echo - 60 Regular seats (Rows D-G)
    echo - 45 Economy seats (Rows H-J)
) else (
    echo.
    echo ERROR! Failed to add seats
)

echo.
echo Press any key to exit...
pause > nul
