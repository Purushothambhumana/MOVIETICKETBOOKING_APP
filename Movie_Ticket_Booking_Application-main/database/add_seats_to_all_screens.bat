@echo off
echo ================================================
echo Adding Seats to All Screens
echo ================================================
echo.
echo This script will:
echo 1. Delete all existing seats
echo 2. Add 150 seats to EACH screen in the database
echo 3. Show verification results
echo.
echo Press Ctrl+C to cancel, or
pause

echo.
echo Executing SQL script...
echo.

mysql -u root -p movie_booking < add_seats_to_all_screens.sql

echo.
echo ================================================
echo Script execution completed!
echo ================================================
echo.
echo Please check the output above for:
echo - Total seats added to each screen
echo - Total seats in the database
echo.
pause
