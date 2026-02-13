@echo off
echo Updating seat types from PREMIUM/REGULAR/ECONOMY to PLATINUM/GOLD/SILVER...
mysql -u root -proot bookmyshow -e "UPDATE seats SET seat_type = 'PLATINUM' WHERE seat_type = 'PREMIUM';"
mysql -u root -proot bookmyshow -e "UPDATE seats SET seat_type = 'GOLD' WHERE seat_type = 'REGULAR';"
mysql -u root -proot bookmyshow -e "UPDATE seats SET seat_type = 'SILVER' WHERE seat_type = 'ECONOMY';"
echo.
echo Verifying changes...
mysql -u root -proot bookmyshow -e "SELECT seat_type, COUNT(*) as count FROM seats GROUP BY seat_type;"
echo.
echo Done!
pause
