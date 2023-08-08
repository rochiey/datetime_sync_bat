@echo off
TIMEOUT /T 10 /NOBREAK

setlocal enabledelayedexpansion

set retry_count=5

:SYNC_LOOP
reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" /v "Type" /d "NTP" /f
net stop w32time
net start w32time
w32tm /resync

if %ERRORLEVEL% equ 0 (
    echo Time synchronization was successful.
) else (
    set /A retry_count-=1
    if !retry_count! gtr 0 (
        echo Time synchronization failed. Retrying (%retry_count% attempts left)...
        ping -n 5 127.0.0.1 > nul 2>&1
        goto SYNC_LOOP
    ) else (
        echo Time synchronization failed after multiple attempts.
    )
)

endlocal
