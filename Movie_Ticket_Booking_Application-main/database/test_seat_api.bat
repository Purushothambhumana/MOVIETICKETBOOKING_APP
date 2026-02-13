@echo off
echo Testing seat API directly...
echo.

curl -X GET "http://localhost:8080/api/bookings/shows/53603/available-seats" -H "Authorization: Bearer YOUR_TOKEN_HERE" -v

echo.
pause
