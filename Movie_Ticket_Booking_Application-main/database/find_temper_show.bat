@echo off
echo Finding the show for Temper movie at sandhya theatre...
echo.

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p12345678 antipromovie -e "SELECT sh.id as show_id, m.title, t.name as theatre, sh.screen_id, sh.show_date, sh.show_time, COUNT(st.id) as seat_count FROM shows sh JOIN movies m ON sh.movie_id = m.id JOIN screens sc ON sh.screen_id = sc.id JOIN theatres t ON sc.theatre_id = t.id LEFT JOIN seats st ON sc.id = st.screen_id WHERE m.title LIKE '%%Temper%%' AND t.name LIKE '%%sandhya%%' GROUP BY sh.id LIMIT 5;"

echo.
pause
