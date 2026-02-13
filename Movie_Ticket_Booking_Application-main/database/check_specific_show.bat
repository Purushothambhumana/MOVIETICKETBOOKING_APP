@echo off
echo Checking which show you're viewing...
echo.

echo Please provide the show ID from your browser URL
echo Example: localhost:3000/seat-selection/53603
echo The number at the end is the show ID
echo.

set /p SHOW_ID="Enter show ID: "

echo.
echo Checking show %SHOW_ID% details...
echo.

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p12345678 antipromovie -e "SELECT sh.id as show_id, sh.screen_id, sc.screen_number, t.name as theatre, COUNT(st.id) as seat_count FROM shows sh JOIN screens sc ON sh.screen_id = sc.id JOIN theatres t ON sc.theatre_id = t.id LEFT JOIN seats st ON sc.id = st.screen_id WHERE sh.id = %SHOW_ID% GROUP BY sh.id;"

echo.
echo Checking if seats exist for this screen...
echo.

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p12345678 antipromovie -e "SELECT st.* FROM shows sh JOIN screens sc ON sh.screen_id = sc.id JOIN seats st ON sc.id = st.screen_id WHERE sh.id = %SHOW_ID% LIMIT 10;"

pause
