@echo off
echo Adding seats to screen 214...
echo.

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p12345678 antipromovie < "%~dp0add_seats_screen_214.sql"

echo.
echo Seats added successfully!
echo Press any key to exit...
pause > nul
