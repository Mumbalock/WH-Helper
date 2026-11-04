@echo off
chcp 65001 >nul
rem Retire le lancement automatique de la mise a jour d'AideClasse.
powershell -NoProfile -Command "Unregister-ScheduledTask -TaskName 'AideClasse - mise a jour' -Confirm:$false -ErrorAction SilentlyContinue; Remove-Item -LiteralPath ([Environment]::GetFolderPath('Startup') + '\AideClasse - mise a jour.lnk') -ErrorAction SilentlyContinue"
echo Mise a jour automatique retiree.
pause
