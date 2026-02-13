@echo off
echo Checking if seats were added to database...
echo.

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p12345678 antipromovie -e "SELECT COUNT(*) as total_seats, COUNT(DISTINCT screen_id) as total_screens FROM seats; SELECT screen_id, COUNT(*) as seat_count FROM seats GROUP BY screen_id LIMIT 10;"

echo.
pause
