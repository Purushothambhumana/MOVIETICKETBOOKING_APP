@echo off
echo Verifying seats in database...
echo.

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p12345678 antipromovie -e "SELECT COUNT(*) as total_seats FROM seats; SELECT screen_id, COUNT(*) as seat_count FROM seats GROUP BY screen_id LIMIT 5; SELECT * FROM seats WHERE screen_id = 86 LIMIT 10;"

echo.
pause
