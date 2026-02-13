@echo off
echo ========================================
echo   Movie Ticket Booking - Quick Start
echo   Developed by: Bhumana Purushotham
echo ========================================
echo.
echo This script will help you start the application quickly.
echo.
echo BEFORE RUNNING:
echo 1. Ensure MySQL is running
echo 2. Database 'antipromovie' exists
echo 3. All dependencies are installed
echo.
echo ========================================
echo.

:MENU
echo Choose an option:
echo.
echo 1. Setup Database (First time only)
echo 2. Start Backend Server
echo 3. Start Frontend Server
echo 4. Start Both (Backend + Frontend)
echo 5. View Application URLs
echo 6. Exit
echo.
set /p choice="Enter choice (1-6): "

if "%choice%"=="1" goto SETUP_DB
if "%choice%"=="2" goto START_BACKEND
if "%choice%"=="3" goto START_FRONTEND
if "%choice%"=="4" goto START_BOTH
if "%choice%"=="5" goto SHOW_URLS
if "%choice%"=="6" goto EXIT
goto MENU

:SETUP_DB
echo.
echo Setting up database...
echo.
mysql -u root -p12345678 -e "CREATE DATABASE IF NOT EXISTS antipromovie;"
echo Database created!
echo.
echo Adding seats...
call database\add_seats.bat
echo.
echo Adding shows...
call database\add_shows.bat
echo.
echo ✅ Database setup complete!
pause
goto MENU

:START_BACKEND
echo.
echo Starting Backend Server on port 8080...
echo.
cd backend
start "Backend Server" cmd /k "mvn spring-boot:run"
echo ✅ Backend server starting in new window...
echo.
timeout /t 2 >nul
cd..
goto MENU

:START_FRONTEND
echo.
echo Starting Frontend Server on port 3000...
echo.
cd frontend
start "Frontend Server" cmd /k "npm start"
echo ✅ Frontend server starting in new window...
echo.
timeout /t 2 >nul
cd..
goto MENU

:START_BOTH
echo.
echo Starting Backend Server...
cd backend
start "Backend Server" cmd /k "mvn spring-boot:run"
echo ✅ Backend starting...
timeout /t 5 >nul
cd..
echo.
echo Starting Frontend Server...
cd frontend
start "Frontend Server" cmd /k "npm start"
echo ✅ Frontend starting...
cd..
echo.
echo ========================================
echo Both servers are starting!
echo.
echo Backend:  http://localhost:8080
echo Frontend: http://localhost:3000
echo.
echo Wait ~30 seconds for backend to fully start.
echo Browser will auto-open for frontend.
echo ========================================
pause
goto MENU

:SHOW_URLS
echo.
echo ========================================
echo   Application URLs
echo ========================================
echo.
echo Backend:  http://localhost:8080
echo Frontend: http://localhost:3000
echo.
echo Admin Login:
echo   Username: admin
echo   Password: admin123
echo.
echo ========================================
pause
goto MENU

:EXIT
echo.
echo Goodbye!
exit
