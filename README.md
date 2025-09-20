# 🖥️ 시스템 점검 스크립트 모음

**Windows 10/11과 Rocky Linux 8/9 환경을 위한 종합 시스템 점검 도구**

---

## 📖 개요

이 프로젝트는 시스템 관리자가 Windows와 Linux 환경에서 **빠르고 효율적으로** 시스템 상태를 종합 점검할 수 있도록 도와주는 스크립트 모음입니다.

### ✨ 주요 특징

<table>
<tr>
<td width="50%">

#### 🚀 **성능 최적화**
- ⚡ **초고속 실행**: 3-8초 내 완료
- 📊 **실시간 진행률**: 시각적 진행 상황 표시
- 🎯 **스마트 점검**: 필요한 정보만 선별적 수집

</td>
<td width="50%">

#### 🔧 **사용자 친화적**
- 📁 **자동 파일 생성**: 타임스탬프 결과 파일
- 🌏 **다국어 지원**: 한글/영어 완벽 지원
- 📱 **간편한 실행**: 원클릭으로 모든 점검 완료

</td>
</tr>
</table>

---

## 📁 프로젝트 구조

```
Shell-Script/
├── 🪟 windows_system_check.bat      # Windows 10/11 점검 스크립트
├── 🐧 rocky_linux_system_check.sh   # Rocky Linux 8/9 점검 스크립트
├── 📖 README.md                     # 사용법 문서
└── 📄 LICENSE                       # MIT 라이선스
```

---

## 🚀 빠른 시작

### 🪟 Windows 10/11

```cmd
# 📥 다운로드 후 바로 실행
git clone https://github.com/user/repo.git
cd Shell-Script

# 🚀 기본 실행 (진행률 표시)
windows_system_check.bat

# 📊 상세 정보와 함께 실행
windows_system_check.bat --verbose

# ❓ 도움말 보기
windows_system_check.bat --help
```

### 🐧 Rocky Linux 8/9

```bash
# 📥 다운로드 후 바로 실행
git clone https://github.com/user/repo.git
cd Shell-Script

# 🔐 실행 권한 부여
chmod +x rocky_linux_system_check.sh

# 🚀 기본 실행 (진행률 표시)
./rocky_linux_system_check.sh

# 📊 상세 정보와 함께 실행
./rocky_linux_system_check.sh --verbose

# ❓ 도움말 보기
./rocky_linux_system_check.sh --help
```

---

## 📊 실행 결과 미리보기

### 🪟 Windows 실행 결과

```
========================================
    Windows 시스템 점검 (최적화 버전)
========================================
예상 소요 시간: 5-10초
[ 14%] ███░░░░░░░░░░░░░░░░ [1/7] 시스템 정보 수집 중...
[ 28%] ██████░░░░░░░░░░░░░░ [2/7] 하드웨어 상태 확인 중...
[ 42%] ████████░░░░░░░░░░░░░ [3/7] 파일시스템 상태 확인 중...
[ 57%] ███████████░░░░░░░░░░ [4/7] 서비스 및 포트 확인 중...
[ 71%] ██████████████░░░░░░░ [5/7] 네트워크 상태 확인 중...
[ 85%] █████████████████░░░░ [6/7] 성능 상태 확인 중...
[100%] ████████████████████░ [7/7] 보안 상태 확인 중...
========================================
           점검 완료!
결과 파일: system_check_2024-01-15_14-30-25.txt
========================================
```

### 🐧 Rocky Linux 실행 결과

```
========================================
    Rocky Linux 시스템 점검 (최적화 버전)
========================================
예상 소요 시간: 3-8초
[ 14%] ███░░░░░░░░░░░░░░░░ [1/7] 시스템 정보 수집 중...
[ 28%] ██████░░░░░░░░░░░░░░ [2/7] 하드웨어 상태 확인 중...
[ 42%] ████████░░░░░░░░░░░░░ [3/7] 파일시스템 상태 확인 중...
[ 57%] ███████████░░░░░░░░░░ [4/7] 서비스 및 포트 확인 중...
열린 포트 및 실행 중인 서비스:
  tcp  LISTEN 0.0.0.0:22 → sshd
  tcp  LISTEN 0.0.0.0:80 → httpd
  tcp  LISTEN 127.0.0.1:3306 → mysqld
[ 71%] ██████████████░░░░░░░ [5/7] 네트워크 상태 확인 중...
[ 85%] █████████████████░░░░ [6/7] 성능 상태 확인 중...
[100%] ████████████████████░ [7/7] 보안 상태 확인 중...
========================================
           점검 완료!
결과 파일: system_check_2024-01-15_14-30-25.txt
========================================
```

---

## 🔍 점검 항목 상세

<table>
<tr>
<th width="20%">영역</th>
<th width="20%">Windows</th>
<th width="20%">Rocky Linux</th>
<th width="40%">상세 내용</th>
</tr>
<tr>
<td><strong>🖥️ 시스템 정보</strong></td>
<td>✅</td>
<td>✅</td>
<td>OS 버전, 제조사, 모델, BIOS, 프로세서, 메모리, 부팅시간</td>
</tr>
<tr>
<td><strong>⚙️ 하드웨어</strong></td>
<td>✅</td>
<td>✅</td>
<td>메모리 상태, 디스크 정보, CPU 사용률, 온도 센서</td>
</tr>
<tr>
<td><strong>💾 파일시스템</strong></td>
<td>✅</td>
<td>✅</td>
<td>디스크 사용률, 파일시스템 타입, inode 사용률, 임시 파일</td>
</tr>
<tr>
<td><strong>🌐 네트워크</strong></td>
<td>✅</td>
<td>✅</td>
<td>인터페이스 정보, IP 주소, 라우팅 테이블, DNS 설정, 연결 상태</td>
</tr>
<tr>
<td><strong>🔌 서비스/포트</strong></td>
<td>✅</td>
<td>✅</td>
<td>열린 포트(실제 프로세스명 포함), 서비스 상태, 방화벽 상태</td>
</tr>
<tr>
<td><strong>📈 성능</strong></td>
<td>✅</td>
<td>✅</td>
<td>업타임, 프로세스 정보, 메모리 사용량, 로드 평균</td>
</tr>
<tr>
<td><strong>🔒 보안</strong></td>
<td>✅</td>
<td>✅</td>
<td>시스템 업데이트, SELinux 상태, 사용자 정보, 로그인 실패 기록</td>
</tr>
</table>

---

## ⚠️ 경고 임계값

<div align="center">

| 메트릭 | 🟢 정상 | 🟡 주의 | 🔴 경고 |
|--------|---------|---------|---------|
| **CPU 사용률** | < 70% | 70-80% | > 80% |
| **디스크 사용률** | < 75% | 75-85% | > 85% |
| **메모리 사용률** | < 80% | 80-90% | > 90% |

</div>

---

## 🔧 시스템 요구사항

### 🪟 Windows 10/11
- **OS**: Windows 10 (Build 1903+) / Windows 11
- **PowerShell**: 5.0 이상
- **권한**: 일반 사용자 (일부 기능은 관리자 권한 필요)

### 🐧 Rocky Linux 8/9
- **OS**: Rocky Linux 8.0+ / Rocky Linux 9.0+
- **Shell**: Bash 4.0 이상
- **권한**: 일반 사용자 (일부 기능은 sudo 권한 필요)

---

## 📝 출력 파일 정보

| 항목 | 설명 |
|------|------|
| **파일명 형식** | `system_check_YYYY-MM-DD_HH-MM-SS.txt` |
| **저장 위치** | 스크립트와 동일한 디렉토리 |
| **파일 형식** | UTF-8 인코딩 텍스트 파일 |
| **내용** | 전체 점검 결과 및 로그 |

---

## 🛠️ 문제 해결

<details>
<summary><strong>🪟 Windows 관련 문제</strong></summary>

### ❌ "wmic is not recognized" 오류
```cmd
# 해결방법: PowerShell 명령어로 자동 대체됨
# 추가 조치 불필요
```

### ❌ 한글 문자 깨짐 현상
```cmd
# 해결방법: UTF-8 인코딩 자동 설정됨
chcp 65001
```

### ❌ 관리자 권한 필요 오류
```cmd
# 해결방법: 관리자 권한으로 실행
# 우클릭 → "관리자 권한으로 실행"
```

</details>

<details>
<summary><strong>🐧 Rocky Linux 관련 문제</strong></summary>

### ❌ "Permission denied" 오류
```bash
# 해결방법: 실행 권한 부여
chmod +x rocky_linux_system_check.sh
```

### ❌ 명령어를 찾을 수 없음
```bash
# 해결방법: 필요한 패키지 설치
sudo yum install net-tools procps-ng ss
```

### ❌ 일부 기능 권한 부족
```bash
# 해결방법: sudo 권한으로 실행
sudo ./rocky_linux_system_check.sh
```

</details>

---

## 🤝 기여하기

이 프로젝트에 기여하고 싶으시다면:

1. **Fork** 이 저장소
2. **Feature Branch** 생성 (`git checkout -b feature/AmazingFeature`)
3. **Commit** 변경사항 (`git commit -m 'Add some AmazingFeature'`)
4. **Push** Branch (`git push origin feature/AmazingFeature`)
5. **Pull Request** 생성

---

## 📋 라이선스

이 프로젝트는 **MIT 라이선스** 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

---

## 📈 업데이트 이력

<details>
<summary><strong>📅 버전 히스토리</strong></summary>

### 🆕 v1.6.0 (2024-01-15)
- ✅ Rocky Linux 스크립트 완전 최적화
- ✅ 파일시스템 타입 및 inode 사용률 점검 추가
- ✅ 네트워크 인터페이스 및 연결 상태 상세 점검
- ✅ 로드 평균과 CPU 코어 수 비교 기능
- ✅ SELinux 상태 및 보안 포트 점검 강화
- ✅ Windows 스크립트 완전 한글화
- ✅ 한글 문자 인식 오류 완전 해결
- ✅ 모든 메시지 및 출력을 한글로 변경
- ✅ Windows 호환성 100% 보장
- ✅ 안정성 최대화

### 🔧 v1.4.0 (2024-01-10)
- ✅ Windows 스크립트 안정성 개선
- ✅ Linux 명령어 호환성 문제 해결
- ✅ 한글 문자 처리 오류 수정
- ✅ Windows 전용 명령어로 최적화
- ✅ 실행 안정성 대폭 향상

### 🎯 v1.3.0 (2024-01-05)
- ✅ 정확한 서비스 포트 식별 기능
- ✅ 실제 실행 중인 프로세스와 포트 연결 확인
- ✅ 포트 번호 추정이 아닌 정확한 서비스 이름 표시
- ✅ Windows: PID와 프로세스명 표시
- ✅ Linux: 실제 프로세스명 표시

### ⚡ v1.2.0 (2024-01-01)
- ✅ 최적화 버전 및 진행률 표시 기능
- ✅ 실시간 진행률 바 표시
- ✅ 실행 시간 3-8초로 단축
- ✅ 불필요한 파일 정리 및 간소화

</details>
