@echo off
echo Getting list of all screen IDs...
echo.

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p12345678 antipromovie -e "SELECT id, screen_number, theatre_id FROM screens ORDER BY id;" > screens_list.txt

type screens_list.txt

echo.
echo Screen IDs saved to screens_list.txt
pause
