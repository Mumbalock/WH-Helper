@echo off
chcp 65001 >nul
rem La lecture des guides Wowhead est faite chaque jour par GitHub (.github/workflows/maj.yml).
rem Ce fichier programme seulement, avec le Planificateur de taches Windows, la recuperation
rem de l'addon a jour depuis GitHub et sa copie dans le jeu :
rem   - tous les jours a %HEURE%, apres la mise a jour faite par GitHub
rem     (si le PC etait eteint a cette heure-la, elle se lance des qu'il est rallume) ;
rem   - a chaque ouverture de session Windows.
rem Rien n'est telecharge si GitHub n'a pas de nouvelle version.
rem Puis fait une premiere recuperation tout de suite.

rem Heure de la recuperation quotidienne (format HH:MM, heure du PC).
set "HEURE=08:00"

set "ICI=%~dp0"
for /f "delims=" %%P in ('where pythonw 2^>nul') do if not defined PYW set "PYW=%%P"
if not defined PYW (
    echo Python est introuvable. Installe-le depuis https://www.python.org puis relance ce fichier.
    pause
    exit /b 1
)

rem Ancienne methode (raccourci dans le dossier Demarrage) : remplacee par la tache planifiee.
powershell -NoProfile -Command "Remove-Item -LiteralPath ([Environment]::GetFolderPath('Startup') + '\AideClasse - mise a jour.lnk') -ErrorAction SilentlyContinue"

powershell -NoProfile -ExecutionPolicy Bypass -Command "$a = New-ScheduledTaskAction -Execute $env:PYW -Argument ('\"' + $env:ICI + 'aideclasse_maj.py\" --depuis-github') -WorkingDirectory $env:ICI; $t = @((New-ScheduledTaskTrigger -Daily -At $env:HEURE), (New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME)); $s = New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -RunOnlyIfNetworkAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 15); $p = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited; Register-ScheduledTask -TaskName 'AideClasse - mise a jour' -Description 'Recupere AideClasse a jour depuis GitHub et le copie dans le jeu (seulement s''il y a du nouveau)' -Action $a -Trigger $t -Settings $s -Principal $p -Force | Out-Null"
if errorlevel 1 (
    echo Impossible de creer la tache planifiee.
    pause
    exit /b 1
)
echo Mise a jour automatique installee : tous les jours a %HEURE% et a l'ouverture de session.

echo Premiere recuperation en cours...
python "%ICI%aideclasse_maj.py" --depuis-github --force
echo.
echo Termine. Le detail est dans "%ICI%journal.txt".
pause
