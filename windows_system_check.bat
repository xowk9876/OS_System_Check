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
set /a PERCENT=(%CURRENT_STEP% * 100) / %TOTAL_STEPS%
set "PROGRESS_BAR="
set /a BAR_LENGTH=%PERCENT% / 5
for /l %%i in (1,1,%BAR_LENGTH%) do set "PROGRESS_BAR=!PROGRESS_BAR!█"
for /l %%i in (%BAR_LENGTH%,1,20) do set "PROGRESS_BAR=!PROGRESS_BAR!░"

echo [%PERCENT%%%] !PROGRESS_BAR! [%CURRENT_STEP%/%TOTAL_STEPS%] %~1
goto :eof

REM 로그 함수
:log
set "MSG=%1"
set "LEVEL=%2"
if "%LEVEL"=="" set "LEVEL=INFO"
set "TIMESTAMP=%date% %time%"
set "LOG_MSG=[!TIMESTAMP!] [!LEVEL!] !MSG!"

if "%VERBOSE%"=="1" echo !LOG_MSG!
echo !LOG_MSG! >> "%OUTPUT_FILE%"
goto :eof

REM 시스템 기본 정보 (최적화)
:system_info
set /a CURRENT_STEP+=1
call :show_progress "시스템 정보 수집 중..."
call :log "=== 시스템 기본 정보 ===" "HEADER"

REM 빠른 정보 수집 (한 번의 systeminfo로)
for /f "tokens=*" %%i in ('systeminfo 2^>nul ^| findstr /C:"OS Name" /C:"OS Version" /C:"Total Physical Memory" /C:"Processor" /C:"Computer Name" /C:"Domain" /C:"System Manufacturer" /C:"System Model"') do call :log "%%i" "INFO"

timeout /t 1 /nobreak >nul 2>&1
goto :eof

REM 하드웨어 점검 (최적화)
:hardware_info
set /a CURRENT_STEP+=1
call :show_progress "하드웨어 상태 확인 중..."
call :log "=== 하드웨어 점검 ===" "HEADER"

REM 메모리 정보
for /f "tokens=*" %%i in ('systeminfo 2^>nul ^| findstr /C:"Total Physical Memory" /C:"Available Physical Memory"') do call :log "%%i" "INFO"

REM 디스크 정보 (간단)
call :log "디스크 정보:" "INFO"
for %%d in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (
        call :log "드라이브 %%d: 사용 가능" "INFO"
    )
)

REM CPU 사용률 (빠른 방법)
call :log "CPU 사용률 확인 중..." "INFO"
powershell -Command "try { (Get-WmiObject -Class Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average } catch { 'N/A' }" >nul 2>&1
if not errorlevel 1 (
    for /f %%a in ('powershell -Command "try { (Get-WmiObject -Class Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average } catch { 'N/A' }"') do (
        if not "%%a"=="N/A" (
            call :log "현재 CPU 사용률: %%a%%" "INFO"
            if %%a gtr 80 call :log "경고: CPU 사용률이 80%%를 초과했습니다!" "WARNING"
        ) else (
            call :log "CPU 사용률을 확인할 수 없습니다" "INFO"
        )
    )
)

timeout /t 1 /nobreak >nul 2>&1
goto :eof

REM 파일시스템 점검 (최적화)
:filesystem_info
set /a CURRENT_STEP+=1
call :show_progress "파일시스템 상태 확인 중..."
call :log "=== 파일시스템 점검 ===" "HEADER"

REM 드라이브 상태 (빠른 확인)
call :log "드라이브 상태 확인:" "INFO"
for %%d in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (
        fsutil volume diskfree %%d: >nul 2>&1
        if not errorlevel 1 (
            call :log "드라이브 %%d: 정상" "INFO"
        ) else (
            call :log "드라이브 %%d: 상태 확인 불가" "WARNING"
        )
    )
)

REM 임시 파일 확인 (간단)
call :log "임시 파일 상태:" "INFO"
if exist "%TEMP%" (
    call :log "임시 디렉토리: 존재" "INFO"
) else (
    call :log "임시 디렉토리: 없음" "WARNING"
)

timeout /t 1 /nobreak >nul 2>&1
goto :eof

REM 네트워크 점검 (최적화)
:network_info
set /a CURRENT_STEP+=1
call :show_progress "네트워크 상태 확인 중..."
call :log "=== 네트워크 점검 ===" "HEADER"

REM IP 주소 정보
call :log "네트워크 정보:" "INFO"
for /f "tokens=*" %%i in ('ipconfig ^| findstr /C:"IPv4" /C:"IP Address"') do call :log "%%i" "INFO"

REM DNS 설정
for /f "tokens=*" %%i in ('ipconfig /all ^| findstr /C:"DNS Servers"') do call :log "%%i" "INFO"

REM 네트워크 연결 상태 (간단)
for /f %%a in ('netstat -an ^| findstr "ESTABLISHED" ^| find /c /v ""') do (
    call :log "활성 연결 수: %%a" "INFO"
)

timeout /t 1 /nobreak >nul 2>&1
goto :eof

REM 서비스 포트 점검 (최적화)
:service_port_info
set /a CURRENT_STEP+=1
call :show_progress "서비스 및 포트 확인 중..."
call :log "=== 서비스 포트 점검 ===" "HEADER"

REM 열린 포트 정보 (간단한 방법)
call :log "주요 열린 포트:" "INFO"
set "COUNT=0"
for /f "tokens=*" %%i in ('netstat -an ^| findstr "LISTENING"') do (
    set /a COUNT+=1
    if !COUNT! leq 10 call :log "  %%i" "INFO"
)

REM 주요 서비스 상태
call :log "주요 서비스 상태:" "INFO"
set "SERVICES=WinRM RemoteRegistry Spooler BITS"
for %%s in (%SERVICES%) do (
    sc query "%%s" >nul 2>&1
    if not errorlevel 1 (
        for /f "tokens=*" %%i in ('sc query "%%s" ^| findstr "STATE"') do (
            call :log "%%s: %%i" "INFO"
        )
    ) else (
        call :log "%%s: 서비스 없음" "INFO"
    )
)

timeout /t 1 /nobreak >nul 2>&1
goto :eof

REM 성능 점검 (최적화)
:performance_info
set /a CURRENT_STEP+=1
call :show_progress "성능 상태 확인 중..."
call :log "=== 성능 점검 ===" "HEADER"

REM 시스템 업타임
for /f "tokens=*" %%i in ('systeminfo ^| findstr /C:"System Boot Time"') do call :log "%%i" "INFO"

REM 현재 시간
call :log "현재 시간: %date% %time%" "INFO"

REM 프로세스 정보 (상위 5개만)
call :log "실행 중인 프로세스 (상위 5개):" "INFO"
set "COUNT=0"
for /f "tokens=*" %%i in ('tasklist /fo table') do (
    set /a COUNT+=1
    if !COUNT! leq 6 call :log "  %%i" "INFO"
)

timeout /t 1 /nobreak >nul 2>&1
goto :eof

REM 보안 점검 (최적화)
:security_info
set /a CURRENT_STEP+=1
call :show_progress "보안 상태 확인 중..."
call :log "=== 보안 점검 ===" "HEADER"

REM 사용자 정보
call :log "사용자 정보:" "INFO"
call :log "현재 사용자: %USERNAME%" "INFO"
call :log "컴퓨터명: %COMPUTERNAME%" "INFO"

REM 바이러스 백신 상태 (간단)
call :log "보안 소프트웨어:" "INFO"
powershell -Command "try { (Get-WmiObject -Namespace root/SecurityCenter2 -Class AntiVirusProduct | Select-Object -First 1).displayName } catch { 'N/A' }" >nul 2>&1
if not errorlevel 1 (
    for /f "tokens=*" %%i in ('powershell -Command "try { (Get-WmiObject -Namespace root/SecurityCenter2 -Class AntiVirusProduct | Select-Object -First 1).displayName } catch { 'N/A' }"') do (
        if not "%%i"=="N/A" (
            call :log "바이러스 백신: %%i" "INFO"
        ) else (
            call :log "바이러스 백신: 확인 불가" "INFO"
        )
    )
)

timeout /t 1 /nobreak >nul 2>&1
goto :eof

REM 메인 실행 함수
:main
echo.
echo ========================================
echo    Windows 시스템 점검 (최적화 버전)
echo ========================================
echo 예상 소요 시간: 5-10초
echo 결과 파일: %OUTPUT_FILE%
echo ========================================
echo.

call :log "Windows 시스템 점검을 시작합니다..." "INFO"
call :log "점검 시간: %date% %time%" "INFO"

echo Windows 시스템 점검 결과 > "%OUTPUT_FILE%"
echo 점검 시간: %date% %time% >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"

REM 각 점검 함수 실행
call :system_info
call :hardware_info
call :filesystem_info
call :network_info
call :service_port_info
call :performance_info
call :security_info

set /a CURRENT_STEP=%TOTAL_STEPS%
call :show_progress "점검 완료!"

call :log "시스템 점검을 완료했습니다." "INFO"

echo.
echo ========================================
echo           점검 완료!
echo ========================================
echo 결과 파일: %OUTPUT_FILE%
echo 점검 완료 시간: %date% %time%
echo ========================================
echo.

pause
goto :eof