@echo off
REM Windows 10/11 시스템 점검 배치 스크립트 (최적화 + 진행률 표시)
REM 작성자: Tae-system
REM 용도: 빠르고 효율적인 시스템 점검

setlocal enabledelayedexpansion
chcp 65001 >nul

REM 변수 설정
set "VERBOSE=0"
set "TIMESTAMP=%date:~0,4%-%date:~5,2%-%date:~8,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%"
set "TIMESTAMP=%TIMESTAMP: =0%"
set "SCRIPT_DIR=%~dp0"
set "OUTPUT_FILE=%SCRIPT_DIR%system_check_%TIMESTAMP%.txt"
set "TOTAL_STEPS=7"
set "CURRENT_STEP=0"

REM 도움말 표시
if "%1"=="--help" goto :help
if "%1"=="-h" goto :help

REM 파라미터 처리
:parse_args
if "%1"=="" goto :main
if "%1"=="--verbose" set "VERBOSE=1" & shift & goto :parse_args
if "%1"=="-v" set "VERBOSE=1" & shift & goto :parse_args
shift
goto :parse_args

:help
echo Windows 시스템 점검 스크립트 (최적화 버전) 사용법:
echo.
echo 사용법: windows_system_check.bat [옵션]
echo.
echo 옵션:
echo   --verbose, -v     상세한 정보 출력
echo   --help, -h        이 도움말 표시
echo.
echo 예시:
echo   windows_system_check.bat
echo   windows_system_check.bat --verbose
echo.
echo 특징:
echo   - 실시간 진행률 표시
echo   - 예상 소요 시간: 5-10초
echo   - 결과 파일 자동 생성
goto :eof

REM 진행률 표시 함수
:show_progress
set /a PERCENT=(CURRENT_STEP*100)/TOTAL_STEPS
set /a BAR_LENGTH=(PERCENT/5)
set "BAR="
for /l %%b in (1,1,!BAR_LENGTH!) do set "BAR=!BAR!█"
for /l %%b in (!BAR_LENGTH!,1,20) do set "BAR=!BAR!░"

if "%VERBOSE%"=="1" (
    echo [!PERCENT!%%] !BAR! [!CURRENT_STEP!/!TOTAL_STEPS!] %1
) else (
    <nul set /p "= [!PERCENT!%%] !BAR! [!CURRENT_STEP!/!TOTAL_STEPS!] %1             "
    if !CURRENT_STEP! equ !TOTAL_STEPS! echo.
)
goto :eof

REM 로그 함수
:log
set "MSG=%~1"
set "LEVEL=%~2"

for /f "tokens=1-6 delims=/: " %%a in ('echo %date% %time%') do (
    set "DT=%%a%%b%%c%%d%%e%%f"
)
set "TIMESTAMP=!DT:~0,4!-!DT:~4,2!-!DT:~6,2! !DT:~8,2!:!DT:~10,2!:!DT:~12,2!"
set "LOG_MSG=[!TIMESTAMP!] [!LEVEL!] !MSG!"

if "%VERBOSE%"=="1" echo !LOG_MSG!
echo !LOG_MSG! >> "%OUTPUT_FILE%"
goto :eof

REM 시스템 기본 정보 (최적화)
:system_info
set /a CURRENT_STEP+=1
call :show_progress "시스템 정보 수집 중..."
call :log "=== 시스템 기본 정보 ===" "HEADER"

REM OS 정보
for /f "tokens=*" %%i in ('systeminfo 2^>nul ^| findstr /C:"OS Name" /C:"OS Version" /C:"System Type" /C:"Computer Name" /C:"Domain"') do call :log "%%i" "INFO"

REM 시스템 제조사 및 모델
for /f "tokens=*" %%i in ('systeminfo 2^>nul ^| findstr /C:"System Manufacturer" /C:"System Model" /C:"BIOS Version"') do call :log "%%i" "INFO"

REM 프로세서 정보
for /f "tokens=*" %%i in ('systeminfo 2^>nul ^| findstr /C:"Processor" /C:"Total Physical Memory"') do call :log "%%i" "INFO"

REM 부팅 시간
for /f "tokens=*" %%i in ('systeminfo 2^>nul ^| findstr /C:"System Boot Time"') do call :log "%%i" "INFO"
goto :eof

REM 하드웨어 점검 (최적화)
:hardware_info
set /a CURRENT_STEP+=1
call :show_progress "하드웨어 상태 확인 중..."
call :log "=== 하드웨어 점검 ===" "HEADER"

REM 메모리 정보
call :log "메모리 상태:" "INFO"
for /f "tokens=*" %%i in ('systeminfo 2^>nul ^| findstr /C:"Total Physical Memory" /C:"Available Physical Memory"') do call :log "  %%i" "INFO"

REM 디스크 정보 (안전한 방법)
call :log "디스크 정보:" "INFO"
for /f "tokens=*" %%i in ('wmic logicaldisk get Caption,Size,Freespace,VolumeName,FileSystem /format:table 2^>nul ^| findstr /v "Caption"') do call :log "  %%i" "INFO"

REM CPU 사용률
call :log "CPU 상태:" "INFO"
for /f %%a in ('powershell -Command "try { (Get-WmiObject -Class Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average } catch { 'N/A' }" 2^>nul') do (
    if not "%%a"=="N/A" (
        call :log "  현재 CPU 사용률: %%a%%" "INFO"
        if %%a gtr 80 call :log "  경고: CPU 사용률이 80%%를 초과했습니다!" "WARNING"
    ) else (
        call :log "  CPU 사용률을 확인할 수 없습니다" "INFO"
    )
)

REM 온도 정보
call :log "온도 센서:" "INFO"
powershell -Command "try { Get-WmiObject -Namespace root/wmi -Class MSAcpi_ThermalZoneTemperature | Select-Object -First 1 } catch { $null }" >nul 2>&1
if not errorlevel 1 (
    call :log "  온도 센서 정보를 사용할 수 있습니다" "INFO"
) else (
    call :log "  온도 센서 정보를 사용할 수 없습니다" "INFO"
)
goto :eof

REM 파일시스템 점검 (최적화)
:filesystem_info
set /a CURRENT_STEP+=1
call :show_progress "파일시스템 상태 확인 중..."
call :log "=== 파일시스템 점검 ===" "HEADER"

REM 디스크 사용률 (안전한 방법)
call :log "디스크 사용률:" "INFO"
for /f "tokens=*" %%i in ('wmic logicaldisk get Caption,Size,Freespace /value 2^>nul') do call :log "  %%i" "INFO"

REM 디스크 오류 점검
call :log "디스크 상태 점검:" "INFO"
net session >nul 2>&1
if not errorlevel 1 (
    call :log "  관리자 권한으로 디스크 상태를 확인합니다..." "INFO"
    for %%d in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
        if exist %%d:\ (
            fsutil dirty query %%d: >nul 2>&1
            if not errorlevel 1 (
                call :log "    드라이브 %%d: 상태 양호" "INFO"
            ) else (
                call :log "    드라이브 %%d: 검사 필요" "WARNING"
            )
        )
    )
) else (
    call :log "  디스크 상태 확인을 위해 관리자 권한이 필요합니다" "WARNING"
)

REM 임시 파일 정보
call :log "임시 파일 정보:" "INFO"
if exist "%TEMP%" (
    for /f %%a in ('dir "%TEMP%" /b 2^>nul ^| find /c /v ""') do (
        call :log "  임시 파일 개수: %%a개" "INFO"
    )
) else (
    call :log "  임시 파일이 없습니다" "INFO"
)
goto :eof

REM 네트워크 인터페이스 점검 (최적화)
:network_info
set /a CURRENT_STEP+=1
call :show_progress "네트워크 상태 확인 중..."
call :log "=== 네트워크 인터페이스 점검 ===" "HEADER"

REM 네트워크 어댑터 정보
call :log "네트워크 어댑터:" "INFO"
for /f "tokens=*" %%i in ('ipconfig /all 2^>nul ^| findstr /C:"Description" /C:"IPv4 Address" /C:"Default Gateway" /C:"DNS Servers"') do call :log "  %%i" "INFO"

REM 활성 네트워크 연결
call :log "활성 네트워크 연결 (상위 15개):" "INFO"
set "COUNT=0"
for /f "tokens=*" %%i in ('netstat -an 2^>nul ^| findstr /v "Active Connections" ^| findstr /v "Proto Local" ^| findstr /v "TCP" ^| findstr /v "UDP"') do (
    set /a COUNT+=1
    if !COUNT! leq 15 call :log "  %%i" "INFO"
)

REM 라우팅 테이블 (안전한 방법)
call :log "라우팅 테이블:" "INFO"
for /f "tokens=*" %%i in ('route print 2^>nul ^| findstr /v "Interface List" ^| findstr /v "Persistent Routes" ^| findstr /v "Active Routes" ^| findstr /v "Network Destination"') do call :log "  %%i" "INFO"

REM DNS 설정
call :log "DNS 설정:" "INFO"
for /f "tokens=*" %%i in ('ipconfig /all 2^>nul ^| findstr /C:"DNS Servers"') do call :log "  %%i" "INFO"
goto :eof

REM 서비스 포트 점검 (최적화)
:service_port_info
set /a CURRENT_STEP+=1
call :show_progress "서비스 및 포트 확인 중..."
call :log "=== 서비스 포트 점검 ===" "HEADER"

REM 열린 포트 (상위 15개)
call :log "주요 열린 포트 (상위 15개):" "INFO"
set "COUNT=0"
for /f "tokens=*" %%i in ('netstat -ano 2^>nul ^| findstr "LISTENING"') do (
    set /a COUNT+=1
    if !COUNT! leq 15 call :log "  %%i" "INFO"
)

REM 주요 서비스 상태
call :log "주요 서비스 상태:" "INFO"
set "SERVICES=WinRM RemoteRegistry Spooler BITS WindowsUpdate"
for %%s in (%SERVICES%) do (
    sc query "%%s" >nul 2>&1
    if not errorlevel 1 (
        for /f "tokens=*" %%i in ('sc query "%%s" 2^>nul ^| findstr "STATE"') do (
            call :log "  %%s: %%i" "INFO"
        )
    ) else (
        call :log "  %%s: 서비스 정보를 가져올 수 없습니다" "WARNING"
    )
)

REM Windows 방화벽 상태
call :log "Windows 방화벽 상태:" "INFO"
for /f "tokens=*" %%i in ('netsh advfirewall show allprofiles state 2^>nul ^| findstr "State"') do (
    echo "%%i" | findstr "ON" >nul
    if not errorlevel 1 (
        call :log "  방화벽이 활성화되어 있습니다" "INFO"
        goto :firewall_done
    )
)
call :log "  방화벽이 비활성화되어 있습니다" "WARNING"
:firewall_done
goto :eof

REM 서버 실행시간 및 성능 (최적화)
:server_uptime_info
set /a CURRENT_STEP+=1
call :show_progress "성능 상태 확인 중..."
call :log "=== 서버 실행시간 및 성능 ===" "HEADER"

REM 시스템 부팅 시간 및 업타임
for /f "tokens=*" %%i in ('systeminfo 2^>nul ^| findstr /C:"System Boot Time"') do call :log "%%i" "INFO"

REM 현재 시간
call :log "현재 시간: %date% %time%" "INFO"

REM 프로세스 정보 (상위 10개)
call :log "상위 프로세스 (상위 10개):" "INFO"
set "COUNT=0"
for /f "tokens=*" %%i in ('tasklist /fo table 2^>nul') do (
    set /a COUNT+=1
    if !COUNT! leq 11 call :log "  %%i" "INFO"
)

REM 메모리 사용량 (안전한 방법)
call :log "메모리 사용량:" "INFO"
for /f "tokens=*" %%i in ('systeminfo 2^>nul ^| findstr /C:"Available Physical Memory"') do call :log "  %%i" "INFO"

timeout /t 1 /nobreak >nul 2>&1
goto :eof

REM 보안 점검 (최적화)
:security_info
set /a CURRENT_STEP+=1
call :show_progress "보안 상태 확인 중..."
call :log "=== 보안 점검 ===" "HEADER"

REM Windows 업데이트 상태
call :log "Windows 업데이트 상태:" "INFO"
powershell -Command "Get-HotFix -ErrorAction SilentlyContinue | Select-Object -First 5 | Format-Table -AutoSize" >nul 2>&1
if not errorlevel 1 (
    for /f "tokens=*" %%i in ('powershell -Command "Get-HotFix -ErrorAction SilentlyContinue | Select-Object -First 5 | Format-Table -AutoSize" 2^>nul') do call :log "  %%i" "INFO"
) else (
    call :log "  Windows 업데이트 정보를 가져올 수 없습니다" "WARNING"
)

REM 바이러스 백신 상태
call :log "바이러스 백신 상태:" "INFO"
powershell -Command "try { $av = Get-WmiObject -Namespace root\\SecurityCenter2 -Class AntiVirusProduct -ErrorAction SilentlyContinue; if($av) { Write-Host '바이러스 백신이 설치되어 있습니다' } else { Write-Host '바이러스 백신 정보를 확인할 수 없습니다' } } catch { Write-Host '바이러스 백신 정보를 가져올 수 없습니다' }" 2>nul >nul
if not errorlevel 1 (
    for /f "tokens=*" %%i in ('powershell -Command "try { $av = Get-WmiObject -Namespace root\\SecurityCenter2 -Class AntiVirusProduct -ErrorAction SilentlyContinue; if($av) { Write-Host '바이러스 백신이 설치되어 있습니다' } else { Write-Host '바이러스 백신 정보를 확인할 수 없습니다' } } catch { Write-Host '바이러스 백신 정보를 가져올 수 없습니다' }" 2^>nul') do call :log "  %%i" "INFO"
) else (
    call :log "  바이러스 백신 정보를 가져올 수 없습니다" "WARNING"
)

REM 사용자 계정 정보 (관리자 그룹) - 간단한 방법
call :log "관리자 그룹 사용자:" "INFO"
call :log "  현재 사용자: %USERNAME%" "INFO"
call :log "  관리자 권한 확인 중..." "INFO"
net session >nul 2>&1
if not errorlevel 1 (
    call :log "  관리자 권한으로 실행 중" "INFO"
) else (
    call :log "  일반 사용자 권한으로 실행 중" "INFO"
)

REM 현재 사용자 정보
call :log "현재 사용자 정보:" "INFO"
call :log "  사용자명: %USERNAME%" "INFO"
call :log "  컴퓨터명: %COMPUTERNAME%" "INFO"

REM 최근 로그인 실패 기록 (이벤트 로그)
call :log "최근 로그인 실패 기록 (이벤트 로그):" "INFO"
powershell -Command "try { $events = Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4625} -MaxEvents 3 -ErrorAction SilentlyContinue; if($events) { Write-Host '최근 로그인 실패 기록이 있습니다' } else { Write-Host '로그인 실패 기록이 없습니다' } } catch { Write-Host '로그인 실패 기록을 가져올 수 없습니다' }" 2>nul >nul
if not errorlevel 1 (
    for /f "tokens=*" %%i in ('powershell -Command "try { $events = Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4625} -MaxEvents 3 -ErrorAction SilentlyContinue; if($events) { Write-Host '최근 로그인 실패 기록이 있습니다' } else { Write-Host '로그인 실패 기록이 없습니다' } } catch { Write-Host '로그인 실패 기록을 가져올 수 없습니다' }" 2^>nul') do call :log "  %%i" "INFO"
) else (
    call :log "  로그인 실패 기록을 가져올 수 없습니다" "WARNING"
)
goto :eof

REM 메인 실행 함수
:main
call :log "Windows 시스템 점검을 시작합니다..." "INFO"
call :log "점검 시간: %date% %time%" "INFO"
call :log "결과 파일: %OUTPUT_FILE%" "INFO"

echo Windows 시스템 점검 결과 > "%OUTPUT_FILE%"
echo 점검 시간: %date% %time% >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"

REM 각 점검 함수 실행
call :system_info
call :hardware_info
call :filesystem_info
call :network_info
call :service_port_info
call :server_uptime_info
call :security_info

call :log "시스템 점검을 완료했습니다." "INFO"
call :log "결과가 파일에 저장되었습니다: %OUTPUT_FILE%" "INFO"

echo.
echo ========================================
echo 시스템 점검이 완료되었습니다!
echo 결과 파일: %OUTPUT_FILE%
echo ========================================

pause
goto :eof