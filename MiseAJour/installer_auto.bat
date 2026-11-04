@echo off
chcp 65001 >nul
rem Programme la mise a jour d'AideClasse avec le Planificateur de taches Windows :
rem   - tous les jours a %HEURE%, apres la reconstruction quotidienne des donnees Wowhead (le soir)
rem     (si le PC etait eteint a cette heure-la, elle se lance des qu'il est rallume) ;
rem   - a chaque ouverture de session Windows.
rem Le programme ne telecharge les guides que si Wowhead a publie du nouveau.
rem Puis fait une premiere mise a jour tout de suite.

rem Heure de la mise a jour quotidienne (format HH:MM, heure du PC).
set "HEURE=06:00"

set "ICI=%~dp0"
for /f "delims=" %%P in ('where pythonw 2^>nul') do if not defined PYW set "PYW=%%P"
if not defined PYW (
    echo Python est introuvable. Installe-le depuis https://www.python.org puis relance ce fichier.
    pause
    exit /b 1
)

rem Ancienne methode (raccourci dans le dossier Demarrage) : remplacee par la tache planifiee.
powershell -NoProfile -Command "Remove-Item -LiteralPath ([Environment]::GetFolderPath('Startup') + '\AideClasse - mise a jour.lnk') -ErrorAction SilentlyContinue"

powershell -NoProfile -ExecutionPolicy Bypass -Command "$a = New-ScheduledTaskAction -Execute $env:PYW -Argument ('\"' + $env:ICI + 'aideclasse_maj.py\"') -WorkingDirectory $env:ICI; $t = @((New-ScheduledTaskTrigger -Daily -At $env:HEURE), (New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME)); $s = New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -RunOnlyIfNetworkAvailable -ExecutionTimeLimit (New-TimeSpan -Hours 1); $p = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited; Register-ScheduledTask -TaskName 'AideClasse - mise a jour' -Description 'Mise a jour AideClasse depuis Wowhead (seulement s''il y a du nouveau)' -Action $a -Trigger $t -Settings $s -Principal $p -Force | Out-Null"
if errorlevel 1 (
    echo Impossible de creer la tache planifiee.
    pause
    exit /b 1
)
echo Mise a jour automatique installee : tous les jours a %HEURE% et a l'ouverture de session.

echo Premiere mise a jour en cours...
python "%ICI%aideclasse_maj.py" --force
echo.
echo Termine. Le detail est dans "%ICI%journal.txt".
pause
