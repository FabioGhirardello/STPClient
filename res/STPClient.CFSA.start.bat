@echo off
cls
set pidlstold=
set pidlstnew=
setlocal enabledelayedexpansion
for /f "tokens=2" %%a in ('tasklist /nh /fi "imagename eq java.exe*"') do set pidlstold=%%a.!pidlstold!


if "!pidlstold!"=="No." (
    echo No running instance of STPClient.CFSA found. Launching STPClient.CFSA...
    start /B java -cp lib/*;libqfj/* -Dlog4j.configuration=file:config/log4j.xml STPClient config/app.properties
    echo.
    for /f "tokens=2" %%a in ('tasklist /nh /fi "imagename eq java.exe*"') do set pidlstold=%%a
    echo PID of just launched STPClient.CFSA instance is "!pidlstold!".
    echo !pidlstold! > STPClient.CFSA.pid.txt
) else (
    echo One or more running instances of STPClient.CFSA found with PID "!pidlstold!".

)




