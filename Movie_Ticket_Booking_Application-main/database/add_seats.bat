@echo off
echo Adding seats to all screens...
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p12345678 antipromovie < "c:\Users\Admin\Documents\antimovie\database\add_seats.sql"
echo.
echo ✅ Seats added successfully!
pause
