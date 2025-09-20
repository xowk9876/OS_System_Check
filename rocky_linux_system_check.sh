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
    
    printf "\r[%3d%%] %s [%d/%d] %s" "$percent" "$progress_bar" "$CURRENT_STEP" "$TOTAL_STEPS" "$message"
    
    if [[ $CURRENT_STEP -eq $TOTAL_STEPS ]]; then
        echo ""
    fi
}

# 로그 함수
log() {
    local message="$1"
    local level="${2:-INFO}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local log_message="[$timestamp] [$level] $message"
    
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
    fi
    
    # 기본 시스템 정보
    log "커널 버전: $(uname -r)" "INFO"
    log "호스트명: $(hostname)" "INFO"
    log "아키텍처: $(uname -m)" "INFO"
    
    sleep 0.5
}

# 하드웨어 점검 (최적화)
hardware_info() {
    show_progress "하드웨어 상태 확인 중..."
    log "=== 하드웨어 점검 ===" "HEADER"
    
    # CPU 정보
    if [[ -f /proc/cpuinfo ]]; then
        log "CPU 모델: $(grep 'model name' /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)" "INFO"
        log "CPU 코어 수: $(nproc)" "INFO"
    fi
    
    # 메모리 정보 (빠른 방법)
    if [[ -f /proc/meminfo ]]; then
        local total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        local available_mem=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
        local used_mem=$((total_mem - available_mem))
        local mem_usage=$((used_mem * 100 / total_mem))
        
        log "총 메모리: $((total_mem / 1024 / 1024)) GB" "INFO"
        log "사용 메모리: $((used_mem / 1024 / 1024)) GB ($mem_usage%)" "INFO"
        log "여유 메모리: $((available_mem / 1024 / 1024)) GB" "INFO"
        
        if [[ $mem_usage -gt 90 ]]; then
            log "경고: 메모리 사용률이 90%를 초과했습니다!" "WARNING"
        fi
    fi
    
    # 디스크 정보 (간단)
    log "디스크 사용량:" "INFO"
    df -h | grep -E '^/dev/' | head -5 | while read line; do
        log "  $line" "INFO"
    done
    
    sleep 0.5
}

# 파일시스템 점검 (최적화)
filesystem_info() {
    show_progress "파일시스템 상태 확인 중..."
    log "=== 파일시스템 점검 ===" "HEADER"
    
    # 마운트된 파일시스템 (주요 항목만)
    log "주요 마운트된 파일시스템:" "INFO"
    mount | grep -E '^/dev/' | head -5 | while read line; do
        log "  $line" "INFO"
    done
    
    # inode 사용률 (간단)
    log "inode 사용률:" "INFO"
    df -i | grep -E '^/dev/' | head -3 | awk '{print $5 " " $6}' | while read usage mount; do
        usage_num=$(echo $usage | sed 's/%//')
        log "  $mount: $usage" "INFO"
        if [[ $usage_num -gt 90 ]]; then
            log "경고: $mount inode 사용률이 90%를 초과했습니다!" "WARNING"
        fi
    done
    
    sleep 0.5
}

# 네트워크 점검 (최적화)
network_info() {
    show_progress "네트워크 상태 확인 중..."
    log "=== 네트워크 점검 ===" "HEADER"
    
    # 네트워크 인터페이스 정보
    log "네트워크 인터페이스:" "INFO"
    ip addr show | grep -E '^[0-9]+:|inet ' | head -10 | while read line; do
        log "  $line" "INFO"
    done
    
    # 네트워크 연결 상태 (간단)
    local established_connections=$(ss -tuln | grep -c ESTAB 2>/dev/null || echo "0")
    local listening_ports=$(ss -tuln | grep -c LISTEN 2>/dev/null || echo "0")
    log "ESTABLISHED 연결: $established_connections" "INFO"
    log "LISTENING 포트: $listening_ports" "INFO"
    
    # DNS 설정
    if [[ -f /etc/resolv.conf ]]; then
        log "DNS 설정:" "INFO"
        grep nameserver /etc/resolv.conf | head -3 | while read line; do
            log "  $line" "INFO"
        done
    fi
    
    sleep 0.5
}

# 서비스 포트 점검 (최적화)
service_port_info() {
    show_progress "서비스 및 포트 확인 중..."
    log "=== 서비스 포트 점검 ===" "HEADER"
    
    # 열린 포트와 실제 프로세스 정보
    log "열린 포트 및 실행 중인 서비스:" "INFO"
    log "형식: 프로토콜 상태 로컬주소 프로세스정보" "INFO"
    
    # ss로 프로세스 정보 포함한 포트 목록 (상위 15개)
    ss -tulnp | grep LISTEN | head -15 | while read line; do
        # 프로세스 정보가 있는 경우만 표시
        if echo "$line" | grep -q "users:"; then
            # 프로세스 정보 추출 및 정리
            process_info=$(echo "$line" | sed -n 's/.*users:(("\([^"]*\)".*/\1/p' | head -1)
            if [[ -n "$process_info" ]]; then
                # 라인에서 프로세스 정보 부분 제거하고 깔끔하게 표시
                clean_line=$(echo "$line" | sed 's/users:.*$//')
                log "  $clean_line → $process_info" "INFO"
            else
                log "  $line" "INFO"
            fi
        else
            log "  $line" "INFO"
        fi
    done
    
    # 주요 서비스 상태
    log "주요 서비스 상태:" "INFO"
    local services=("sshd" "NetworkManager" "firewalld" "chronyd")
    for service in "${services[@]}"; do
        if systemctl is-enabled "$service" >/dev/null 2>&1; then
            status=$(systemctl is-active "$service")
            log "  $service: $status" "INFO"
        else
            log "  $service: 서비스 없음 또는 비활성" "INFO"
        fi
    done
    
    sleep 0.5
}

# 성능 점검 (최적화)
performance_info() {
    show_progress "성능 상태 확인 중..."
    log "=== 성능 점검 ===" "HEADER"
    
    # 시스템 업타임
    uptime_info=$(uptime)
    log "시스템 업타임: $uptime_info" "INFO"
    
    # 로드 평균
    load_avg=$(cat /proc/loadavg)
    log "로드 평균: $load_avg" "INFO"
    
    # 프로세스 정보 (상위 5개)
    log "CPU 사용량 상위 프로세스:" "INFO"
    if command -v ps >/dev/null 2>&1; then
        ps aux --sort=-%cpu | head -6 | while read line; do
            log "  $line" "INFO"
        done
    fi
    
    sleep 0.5
}

# 보안 점검 (최적화)
security_info() {
    show_progress "보안 상태 확인 중..."
    log "=== 보안 점검 ===" "HEADER"
    
    # 사용자 계정 정보
    local user_count=$(cat /etc/passwd | wc -l)
    local login_users=$(who | wc -l)
    log "총 사용자 계정: $user_count" "INFO"
    log "현재 로그인 사용자: $login_users" "INFO"
    
    # 현재 로그인 사용자
    if command -v who >/dev/null 2>&1; then
        log "현재 로그인 사용자:" "INFO"
        who | head -3 | while read line; do
            log "  $line" "INFO"
        done
    fi
    
    # SSH 설정 (간단한 점검)
    log "SSH 설정:" "INFO"
    if [[ -f /etc/ssh/sshd_config ]]; then
        local ssh_port=$(grep "^Port" /etc/ssh/sshd_config | awk '{print $2}' || echo "22")
        local root_login=$(grep "^PermitRootLogin" /etc/ssh/sshd_config | awk '{print $2}' || echo "yes")
        
        log "  SSH 포트: $ssh_port" "INFO"
        log "  Root 로그인: $root_login" "INFO"
        
        if [[ "$root_login" == "yes" ]]; then
            log "  경고: Root 로그인이 허용되어 있습니다!" "WARNING"
        fi
    fi
    
    # SELinux 상태
    if command -v getenforce >/dev/null 2>&1; then
        selinux_status=$(getenforce 2>/dev/null)
        log "SELinux: $selinux_status" "INFO"
    fi
    
    sleep 0.5
}

# 메인 실행 함수
main() {
    echo ""
    echo "========================================"
    echo "   Rocky Linux 시스템 점검 (최적화 버전)"
    echo "========================================"
    echo "예상 소요 시간: 3-8초"
    echo "결과 파일: $OUTPUT_FILE"
    echo "========================================"
    echo ""
    
    log "Rocky Linux 시스템 점검을 시작합니다..." "INFO"
    log "점검 시간: $(date '+%Y-%m-%d %H:%M:%S')" "INFO"
    
    echo "Rocky Linux 시스템 점검 결과" > "$OUTPUT_FILE"
    echo "점검 시간: $(date '+%Y-%m-%d %H:%M:%S')" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    # 각 점검 함수 실행
    system_info
    hardware_info
    filesystem_info
    network_info
    service_port_info
    performance_info
    security_info
    
    show_progress "점검 완료!"
    
    log "시스템 점검을 완료했습니다." "INFO"
    
    echo ""
    echo "========================================"
    echo "           점검 완료!"
    echo "========================================"
    echo "결과 파일: $OUTPUT_FILE"
    echo "점검 완료 시간: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "========================================"
    echo ""
}

# 명령행 인수 처리
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
            echo -e "${RED}알 수 없는 옵션: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# 스크립트 실행
main
