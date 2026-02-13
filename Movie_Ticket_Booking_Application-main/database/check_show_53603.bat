@echo off
echo Checking show 53603 details...
echo.

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p12345678 antipromovie -e "SELECT sh.id as show_id, sh.show_date, sh.show_time, sc.id as screen_id, sc.screen_number, t.name as theatre_name, COUNT(st.id) as seat_count FROM shows sh JOIN screens sc ON sh.screen_id = sc.id JOIN theatres t ON sc.theatre_id = t.id LEFT JOIN seats st ON sc.id = st.screen_id WHERE sh.id = 53603 GROUP BY sh.id, sc.id;"

echo.
pause
