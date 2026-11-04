@echo off
chcp 65001 >nul
rem Retire le lancement automatique de la mise a jour de WH Helper (et celle de l'ancien nom AideClasse).
powershell -NoProfile -Command "foreach ($n in 'WH Helper - mise a jour', 'AideClasse - mise a jour') { Unregister-ScheduledTask -TaskName $n -Confirm:$false -ErrorAction SilentlyContinue }; Remove-Item -LiteralPath ([Environment]::GetFolderPath('Startup') + '\AideClasse - mise a jour.lnk') -ErrorAction SilentlyContinue"
echo Mise a jour automatique retiree.
pause
