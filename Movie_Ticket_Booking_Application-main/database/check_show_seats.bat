@echo off
echo Checking show 258480 and its seats...
echo.

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p12345678 antipromovie -e "SELECT sh.id as show_id, sh.show_date, sh.show_time, sc.id as screen_id, sc.screen_number, COUNT(st.id) as seat_count FROM shows sh JOIN screens sc ON sh.screen_id = sc.id LEFT JOIN seats st ON sc.id = st.screen_id WHERE sh.id = 258480 GROUP BY sh.id, sc.id;"

echo.
echo Press any key to exit...
pause > nul
