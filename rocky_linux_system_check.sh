#!/bin/bash
# Rocky Linux 8/9 시스템 점검 스크립트 (최적화 + 진행률 표시)
# 작성자: Tae-system
# 용도: 빠르고 효율적인 시스템 점검

# 색상 코드
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# 전역 변수
VERBOSE=0
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_FILE="$SCRIPT_DIR/system_check_$TIMESTAMP.txt"
TOTAL_STEPS=7
CURRENT_STEP=0

# 도움말 함수
show_help() {
    echo -e "${CYAN}Rocky Linux 시스템 점검 스크립트 (최적화 버전) 사용법:${NC}"
    echo ""
    echo "사용법: $0 [옵션]"
    echo ""
    echo "옵션:"
    echo "  -v, --verbose     상세한 정보 출력"
    echo "  -h, --help        이 도움말 표시"
    echo ""
    echo "예시:"
    echo "  $0"
    echo "  $0 --verbose"
    echo ""
    echo "특징:"
    echo "  - 실시간 진행률 표시"
    echo "  - 예상 소요 시간: 3-8초"
    echo "  - 결과 파일 자동 생성"
}

# 진행률 표시 함수
show_progress() {
    local message="$1"
    CURRENT_STEP=$((CURRENT_STEP + 1))
    local percent=$((CURRENT_STEP * 100 / TOTAL_STEPS))
    
    # 진행률 바 생성
    local bar_length=$((percent / 5))
    local progress_bar=""
    
    for ((i=0; i<bar_length; i++)); do
        progress_bar="${progress_bar}█"
    done
    
    for ((i=bar_length; i<20; i++)); do
        progress_bar="${progress_bar}░"
    done
    
    if [[ $VERBOSE -eq 1 ]]; then
        printf "[%3d%%] %s [%d/%d] %s\n" "$percent" "$progress_bar" "$CURRENT_STEP" "$TOTAL_STEPS" "$message"
    else
        printf "\r[%3d%%] %s [%d/%d] %s" "$percent" "$progress_bar" "$CURRENT_STEP" "$TOTAL_STEPS" "$message"
        if [[ $CURRENT_STEP -eq $TOTAL_STEPS ]]; then
            echo ""
        fi
    fi
}

# 로그 함수
log() {
    local message="$1"
    local level="${2:-INFO}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local log_message="[$timestamp] [$level] $message"
    
    if [[ $VERBOSE -eq 1 ]]; then
        case $level in
            "ERROR")
                echo -e "${RED}$log_message${NC}"
                ;;
            "WARNING")
                echo -e "${YELLOW}$log_message${NC}"
                ;;
            "INFO")
                echo -e "${GREEN}$log_message${NC}"
                ;;
            "HEADER")
                echo -e "${PURPLE}$log_message${NC}"
                ;;
            *)
                echo -e "${WHITE}$log_message${NC}"
                ;;
        esac
    fi
    
    echo "$log_message" >> "$OUTPUT_FILE"
}

# 시스템 기본 정보 (최적화)
system_info() {
    show_progress "시스템 정보 수집 중..."
    log "=== 시스템 기본 정보 ===" "HEADER"
    
    # 운영체제 정보
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        log "운영체제: $NAME" "INFO"
        log "버전: $VERSION" "INFO"
        log "ID: $ID" "INFO"
    fi
    
    # 기본 시스템 정보
    log "커널 버전: $(uname -r)" "INFO"
    log "호스트명: $(hostname)" "INFO"
    log "아키텍처: $(uname -m)" "INFO"
    
    # 시스템 부팅 시간
    if command -v uptime >/dev/null 2>&1; then
        log "시스템 부팅 시간: $(uptime -s 2>/dev/null || echo '정보 없음')" "INFO"
    fi
    
    sleep 0.3
}

# 하드웨어 점검 (최적화)
hardware_info() {
    show_progress "하드웨어 상태 확인 중..."
    log "=== 하드웨어 점검 ===" "HEADER"
    
    # CPU 정보
    if [[ -f /proc/cpuinfo ]]; then
        log "CPU 모델: $(grep 'model name' /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)" "INFO"
        log "CPU 코어 수: $(nproc)" "INFO"
        
        # CPU 사용률 (간단한 방법)
        if command -v top >/dev/null 2>&1; then
            local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//')
            log "현재 CPU 사용률: ${cpu_usage}%" "INFO"
            if (( $(echo "$cpu_usage > 80" | bc -l) )); then
                log "경고: CPU 사용률이 80%를 초과했습니다!" "WARNING"
            fi
        fi
    fi
    
    # 메모리 정보 (최적화)
    if [[ -f /proc/meminfo ]]; then
        local total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        local available_mem=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
        local used_mem=$((total_mem - available_mem))
        local mem_usage=$((used_mem * 100 / total_mem))
        
        log "총 메모리: $((total_mem / 1024 / 1024)) GB" "INFO"
        log "사용 메모리: $((used_mem / 1024 / 1024)) GB ($mem_usage%)" "INFO"
        log "여유 메모리: $((available_mem / 1024 / 1024)) GB" "INFO"
        
        if [[ $mem_usage -gt 85 ]]; then
            log "경고: 메모리 사용률이 85%를 초과했습니다!" "WARNING"
        fi
    fi
    
    # 디스크 정보 (최적화)
    log "디스크 사용량:" "INFO"
    df -h | grep -E '^/dev/' | head -5 | while read line; do
        log "  $line" "INFO"
    done
    
    # 온도 정보 (간단한 확인)
    log "온도 센서:" "INFO"
    if [[ -d /sys/class/thermal ]]; then
        local temp_count=$(find /sys/class/thermal -name "temp*" | wc -l)
        if [[ $temp_count -gt 0 ]]; then
            log "  온도 센서 $temp_count 개 발견" "INFO"
        else
            log "  온도 센서를 찾을 수 없습니다" "INFO"
        fi
    else
        log "  온도 센서 정보를 사용할 수 없습니다" "INFO"
    fi
    
    sleep 0.3
}

# 파일시스템 점검 (최적화)
filesystem_info() {
    show_progress "파일시스템 상태 확인 중..."
    log "=== 파일시스템 점검 ===" "HEADER"
    
    # 디스크 사용률 (상세)
    log "디스크 사용률 상세:" "INFO"
    df -h | grep -E '^/dev/' | while read line; do
        local usage=$(echo "$line" | awk '{print $5}' | sed 's/%//')
        log "  $line" "INFO"
        if [[ $usage -gt 85 ]]; then
            log "  경고: 디스크 사용률이 85%를 초과했습니다!" "WARNING"
        fi
    done
    
    # 파일시스템 타입 확인
    log "파일시스템 타입:" "INFO"
    mount | grep -E '^/dev/' | head -5 | while read line; do
        log "  $line" "INFO"
    done
    
    # inode 사용률 (중요한 파티션만)
    log "inode 사용률 (중요 파티션):" "INFO"
    df -i | grep -E '^/dev/' | head -3 | while read line; do
        local inode_usage=$(echo "$line" | awk '{print $5}' | sed 's/%//')
        if [[ $inode_usage -gt 90 ]]; then
            log "  경고: $line (inode 사용률 높음)" "WARNING"
        else
            log "  $line" "INFO"
        fi
    done
    
    # 임시 파일 크기 확인
    log "임시 파일 정보:" "INFO"
    if [[ -d /tmp ]]; then
        local tmp_count=$(find /tmp -maxdepth 1 -type f 2>/dev/null | wc -l)
        log "  /tmp 디렉토리 파일 수: $tmp_count 개" "INFO"
    fi
    
    if [[ -d /var/tmp ]]; then
        local vartmp_count=$(find /var/tmp -maxdepth 1 -type f 2>/dev/null | wc -l)
        log "  /var/tmp 디렉토리 파일 수: $vartmp_count 개" "INFO"
    fi
    
    sleep 0.3
}

# 네트워크 인터페이스 점검 (최적화)
network_info() {
    show_progress "네트워크 상태 확인 중..."
    log "=== 네트워크 인터페이스 점검 ===" "HEADER"
    
    # 네트워크 인터페이스 정보
    log "네트워크 인터페이스:" "INFO"
    ip addr show | grep -E '^[0-9]+:' | while read line; do
        log "  $line" "INFO"
    done
    
    # IP 주소 정보
    log "IP 주소 정보:" "INFO"
    ip addr show | grep 'inet ' | while read line; do
        log "  $line" "INFO"
    done
    
    # 라우팅 테이블
    log "라우팅 테이블:" "INFO"
    ip route show | head -10 | while read line; do
        log "  $line" "INFO"
    done
    
    # DNS 설정
    log "DNS 설정:" "INFO"
    if [[ -f /etc/resolv.conf ]]; then
        grep '^nameserver' /etc/resolv.conf | while read line; do
            log "  $line" "INFO"
        done
    fi
    
    # 네트워크 연결 상태 (상위 10개)
    log "네트워크 연결 상태 (상위 10개):" "INFO"
    if command -v ss >/dev/null 2>&1; then
        ss -tuln | head -10 | while read line; do
            log "  $line" "INFO"
        done
    elif command -v netstat >/dev/null 2>&1; then
        netstat -tuln | head -10 | while read line; do
            log "  $line" "INFO"
        done
    fi
    
    sleep 0.3
}

# 서비스 포트 점검 (최적화)
service_port_info() {
    show_progress "서비스 및 포트 확인 중..."
    log "=== 서비스 포트 점검 ===" "HEADER"
    
    # 열린 포트와 실제 프로세스 정보
    log "열린 포트 및 실행 중인 서비스:" "INFO"
    log "형식: 프로토콜 상태 로컬주소 프로세스정보" "INFO"
    
    # ss로 프로세스 정보 포함한 포트 목록 (상위 15개)
    if command -v ss >/dev/null 2>&1; then
        ss -tulnp | grep LISTEN | head -15 | while read line; do
            # 프로세스 정보가 있는 경우만 표시
            if echo "$line" | grep -q "users:"; then
                # 프로세스 정보 추출 및 정리
                local process_info=$(echo "$line" | sed -n 's/.*users:(("\([^"]*\)".*/\1/p' | head -1)
                if [[ -n "$process_info" ]]; then
                    # 라인에서 프로세스 정보 부분 제거하고 깔끔하게 표시
                    local clean_line=$(echo "$line" | sed 's/users:.*$//')
                    log "  $clean_line → $process_info" "INFO"
                else
                    log "  $line" "INFO"
                fi
            else
                log "  $line" "INFO"
            fi
        done
    fi
    
    # 주요 서비스 상태
    log "주요 서비스 상태:" "INFO"
    local services=("sshd" "NetworkManager" "firewalld" "chronyd" "httpd" "nginx" "mysql" "postgresql")
    for service in "${services[@]}"; do
        if systemctl is-active --quiet "$service" 2>/dev/null; then
            log "  $service: 활성 (running)" "INFO"
        elif systemctl is-enabled --quiet "$service" 2>/dev/null; then
            log "  $service: 비활성 (stopped)" "WARNING"
        fi
    done
    
    # 방화벽 상태
    log "방화벽 상태:" "INFO"
    if systemctl is-active --quiet firewalld 2>/dev/null; then
        log "  firewalld: 활성" "INFO"
        if command -v firewall-cmd >/dev/null 2>&1; then
            firewall-cmd --list-all --zone=public 2>/dev/null | head -5 | while read line; do
                log "    $line" "INFO"
            done
        fi
    else
        log "  firewalld: 비활성" "WARNING"
    fi
    
    sleep 0.3
}

# 서버 실행시간 및 성능 (최적화)
server_uptime_info() {
    show_progress "성능 상태 확인 중..."
    log "=== 서버 실행시간 및 성능 ===" "HEADER"
    
    # 시스템 업타임
    if command -v uptime >/dev/null 2>&1; then
        log "시스템 업타임: $(uptime)" "INFO"
    fi
    
    # 현재 시간
    log "현재 시간: $(date)" "INFO"
    
    # 프로세스 정보 (상위 10개)
    log "상위 프로세스 (상위 10개):" "INFO"
    if command -v ps >/dev/null 2>&1; then
        ps aux --sort=-%cpu | head -11 | while read line; do
            log "  $line" "INFO"
        done
    fi
    
    # 메모리 사용량 (상세)
    log "메모리 사용량 상세:" "INFO"
    if [[ -f /proc/meminfo ]]; then
        grep -E 'MemTotal|MemFree|MemAvailable|Buffers|Cached' /proc/meminfo | while read line; do
            log "  $line" "INFO"
        done
    fi
    
    # 로드 평균
    if [[ -f /proc/loadavg ]]; then
        local load_avg=$(cat /proc/loadavg)
        log "로드 평균: $load_avg" "INFO"
        
        # CPU 코어 수와 비교
        local cpu_cores=$(nproc)
        local load_1min=$(echo "$load_avg" | awk '{print $1}')
        if (( $(echo "$load_1min > $cpu_cores" | bc -l) )); then
            log "경고: 1분 로드 평균이 CPU 코어 수를 초과했습니다!" "WARNING"
        fi
    fi
    
    sleep 0.3
}

# 보안 점검 (최적화)
security_info() {
    show_progress "보안 상태 확인 중..."
    log "=== 보안 점검 ===" "HEADER"
    
    # 시스템 업데이트 상태
    log "시스템 업데이트 상태:" "INFO"
    if command -v dnf >/dev/null 2>&1; then
        local updates=$(dnf check-update --quiet 2>/dev/null | grep -c "updates")
        if [[ $updates -gt 0 ]]; then
            log "  사용 가능한 업데이트: $updates 개" "WARNING"
        else
            log "  시스템이 최신 상태입니다" "INFO"
        fi
    elif command -v yum >/dev/null 2>&1; then
        local updates=$(yum check-update --quiet 2>/dev/null | grep -c "updates")
        if [[ $updates -gt 0 ]]; then
            log "  사용 가능한 업데이트: $updates 개" "WARNING"
        else
            log "  시스템이 최신 상태입니다" "INFO"
        fi
    fi
    
    # SELinux 상태
    log "SELinux 상태:" "INFO"
    if command -v getenforce >/dev/null 2>&1; then
        local selinux_status=$(getenforce 2>/dev/null || echo "정보 없음")
        log "  SELinux: $selinux_status" "INFO"
    fi
    
    # 사용자 계정 정보
    log "사용자 계정 정보:" "INFO"
    log "  현재 사용자: $(whoami)" "INFO"
    log "  사용자 ID: $(id)" "INFO"
    
    # sudo 사용자 확인
    if [[ -f /etc/sudoers ]]; then
        local sudo_users=$(grep -E '^[^#]*sudo' /etc/group | cut -d: -f4)
        if [[ -n "$sudo_users" ]]; then
            log "  sudo 권한 사용자: $sudo_users" "INFO"
        fi
    fi
    
    # 최근 로그인 실패 기록
    log "최근 로그인 실패 기록:" "INFO"
    if [[ -f /var/log/secure ]]; then
        local failed_logins=$(grep "Failed password" /var/log/secure 2>/dev/null | tail -3 | wc -l)
        if [[ $failed_logins -gt 0 ]]; then
            log "  최근 로그인 실패: $failed_logins 회" "WARNING"
        else
            log "  최근 로그인 실패 기록 없음" "INFO"
        fi
    elif [[ -f /var/log/auth.log ]]; then
        local failed_logins=$(grep "Failed password" /var/log/auth.log 2>/dev/null | tail -3 | wc -l)
        if [[ $failed_logins -gt 0 ]]; then
            log "  최근 로그인 실패: $failed_logins 회" "WARNING"
        else
            log "  최근 로그인 실패 기록 없음" "INFO"
        fi
    else
        log "  로그 파일을 찾을 수 없습니다" "INFO"
    fi
    
    # 열린 포트 보안 검사
    log "보안 관련 포트 검사:" "INFO"
    if command -v ss >/dev/null 2>&1; then
        local ssh_port=$(ss -tlnp | grep ":22 " | wc -l)
        if [[ $ssh_port -gt 0 ]]; then
            log "  SSH 포트 (22) 열림" "INFO"
        fi
        
        local http_port=$(ss -tlnp | grep ":80 " | wc -l)
        if [[ $http_port -gt 0 ]]; then
            log "  HTTP 포트 (80) 열림" "INFO"
        fi
        
        local https_port=$(ss -tlnp | grep ":443 " | wc -l)
        if [[ $https_port -gt 0 ]]; then
            log "  HTTPS 포트 (443) 열림" "INFO"
        fi
    fi
    
    sleep 0.3
}

# 메인 함수
main() {
    # 파라미터 처리
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--verbose)
                VERBOSE=1
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                echo "알 수 없는 옵션: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # 초기화
    echo "Rocky Linux 시스템 점검 결과" > "$OUTPUT_FILE"
    echo "점검 시간: $(date)" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    log "Rocky Linux 시스템 점검을 시작합니다..." "INFO"
    log "점검 시간: $(date)" "INFO"
    log "결과 파일: $OUTPUT_FILE" "INFO"
    
    # 각 점검 함수 실행
    system_info
    hardware_info
    filesystem_info
    network_info
    service_port_info
    server_uptime_info
    security_info
    
    log "시스템 점검을 완료했습니다." "INFO"
    log "결과가 파일에 저장되었습니다: $OUTPUT_FILE" "INFO"
    
    echo ""
    echo "========================================"
    echo "시스템 점검이 완료되었습니다!"
    echo "결과 파일: $OUTPUT_FILE"
    echo "========================================"
}

# 스크립트 실행
main "$@"