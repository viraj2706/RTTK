@echo off
:: Full Port Scanner using Telnet in CMD
:: Scans all ports (0-65535) for each IP in ip_list.txt

set "input_file=ip_list.txt"
set "output_file=full_scan_results.txt"

:: Clear output file if it exists
if exist "%output_file%" del "%output_file%"

:: Check if Telnet is installed
telnet /? >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Telnet is not installed or disabled. >> "%output_file%"
    echo Please enable Telnet Client using: dism /online /Enable-Feature /FeatureName:TelnetClient >> "%output_file%"
    exit /b
)

:: Read IPs from input file
for /f %%A in (%input_file%) do (
    set "ip=%%A"
    echo ========================================= >> "%output_file%"
    echo Scanning IP: %%A - %date% %time% >> "%output_file%"
    echo ========================================= >> "%output_file%"
    
    for /L %%P in (0,1,65535) do (
        (echo open %%A %%P & echo quit) | telnet >nul 2>&1
        if %errorlevel% equ 0 (
            echo [OPEN] %%A:%%P >> "%output_file%"
        )
    )
)

echo Scan complete! Results saved in "%output_file%"
