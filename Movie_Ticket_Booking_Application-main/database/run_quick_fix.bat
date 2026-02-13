@echo off
echo ============================================
echo   QUICK FIX: Adding seats to screen 214
echo ============================================
echo.

cd /d "%~dp0"
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p12345678 antipromovie < quick_fix_214.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================
    echo   SUCCESS! 150 seats added to screen 214
    echo ============================================
    echo.
    echo Now refresh your browser - you should see seats!
    echo ============================================
) else (
    echo.
    echo ERROR! Check above for details.
)

echo.
pause
