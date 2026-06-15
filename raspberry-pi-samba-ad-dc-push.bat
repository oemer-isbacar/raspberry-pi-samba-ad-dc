@echo off

:: Gerät erkennen
if "%USERNAME%"=="IsbacarO" (
    set PROJEKTE=C:\Users\IsbacarO\Schule\FIS\Projekte
) else if "%USERNAME%"=="oemer" (
    set PROJEKTE=C:\Users\oemer\Documents\Schule\FIS\Projekte
) else if "%USERNAME%"=="oemer.isbacar" (
    set PROJEKTE=C:\Users\user\Documents\Schule\FIS\Projekte
) else (
    echo Unbekannter Computer ^(%USERNAME%^) - Abbruch!
    pause
    exit
)

echo.
echo === raspberry-pi-samba-ad-dc wird hochgeladen ===
cd /d "%PROJEKTE%\raspberry-pi-samba-ad-dc"
git pull origin main
git add .
git commit -m "Update %USERNAME% %date%"
git push origin main

echo.
echo Fertig!
pause
