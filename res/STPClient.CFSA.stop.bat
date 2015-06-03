@echo off
cls

set /p dPID=<STPClient.CFSA.pid.txt
echo killing now PID %dPID%
taskkill /F /PID %dPID%

del STPClient.CFSA.pid.txt




