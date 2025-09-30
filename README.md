<div align="center">

# 🖥️ 시스템 점검 스크립트 모음

[![Windows](https://img.shields.io/badge/Windows-0078D4?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://rockylinux.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)
[![Made with ❤️](https://img.shields.io/badge/Made%20with-❤️-red.svg?style=for-the-badge)](https://github.com/xowk9876)

**Windows 10/11과 Rocky Linux 8/9 환경을 위한 종합 시스템 점검 도구**

</div>

---

## 📖 개요

<div align="center">

### ⚡ **초고속 시스템 점검 도구**

**5-10초 만에 완전한 시스템 상태를 파악하세요!**

</div>

이 프로젝트는 시스템 관리자가 Windows와 Linux 환경에서 **빠르고 효율적으로** 시스템 상태를 종합 점검할 수 있도록 도와주는 스크립트 모음입니다.

### ✨ 주요 특징

<div align="center">

| 🚀 **성능 최적화** | 🔧 **사용자 친화적** | 🛡️ **안전성** |
|:---:|:---:|:---:|
| ⚡ 초고속 실행 (5-10초) | 🌏 완전 한글화 | 🔒 권한 최소화 |
| 📊 실시간 진행률 표시 | 📁 자동 파일 생성 | 🛡️ 오류 처리 강화 |
| 🧠 스마트 점검 알고리즘 | 📱 원클릭 실행 | ✅ 안전한 명령어 사용 |

</div>

---

## 🚀 빠른 시작

<div align="center">

### ⚡ **원클릭 실행으로 5초 만에 시스템 점검 완료!**

</div>

---

## 🪟 Windows 10/11

<div align="center">

[![Windows](https://img.shields.io/badge/Windows-0078D4?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=PowerShell&logoColor=white)](https://docs.microsoft.com/powershell/)

</div>

### 📥 설치 및 실행

<div align="center">

```cmd
# 1️⃣ 저장소 클론
git clone https://github.com/xowk9876/OS_System_Check.git
cd OS_System_Check

# 2️⃣ 기본 실행 (진행률 표시)
windows_system_check.bat

# 3️⃣ 상세 정보와 함께 실행
windows_system_check.bat --verbose

# 4️⃣ 도움말 보기
windows_system_check.bat --help
```

</div>

### 🎯 실행 옵션

<div align="center">

| 🎮 옵션 | 📝 설명 | 💡 예시 | ⏱️ 소요 시간 |
|:---:|:---:|:---:|:---:|
| **기본 실행** | 진행률 표시와 함께 실행 | `windows_system_check.bat` | 5-8초 |
| `--verbose` | 상세한 디버그 정보 출력 | `windows_system_check.bat --verbose` | 8-12초 |
| `--help` | 도움말 및 사용법 표시 | `windows_system_check.bat --help` | 즉시 |

</div>

---

## 🐧 Rocky Linux 8/9

<div align="center">

[![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://rockylinux.org/)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=GNU%20Bash&logoColor=white)](https://www.gnu.org/software/bash/)

</div>

### 📥 설치 및 실행

<div align="center">

```bash
# 1️⃣ 저장소 클론
git clone https://github.com/xowk9876/OS_System_Check.git
cd OS_System_Check

# 2️⃣ 실행 권한 부여
chmod +x rocky_linux_system_check.sh

# 3️⃣ 기본 실행 (진행률 표시)
./rocky_linux_system_check.sh

# 4️⃣ 상세 정보와 함께 실행
./rocky_linux_system_check.sh --verbose

# 5️⃣ 도움말 보기
./rocky_linux_system_check.sh --help
```

</div>

### 🎯 실행 옵션

<div align="center">

| 🎮 옵션 | 📝 설명 | 💡 예시 | ⏱️ 소요 시간 |
|:---:|:---:|:---:|:---:|
| **기본 실행** | 진행률 표시와 함께 실행 | `./rocky_linux_system_check.sh` | 3-6초 |
| `--verbose` | 상세한 디버그 정보 출력 | `./rocky_linux_system_check.sh --verbose` | 6-10초 |
| `--help` | 도움말 및 사용법 표시 | `./rocky_linux_system_check.sh --help` | 즉시 |

</div>

---

## 📊 기능 비교표

<div align="center">

| 🎯 기능 | 🪟 Windows | 🐧 Rocky Linux | 📝 상세 설명 |
|:---:|:---:|:---:|:---:|
| **⚡ 실행 시간** | 5-8초 | 3-6초 | 초고속 시스템 점검 |
| **🔢 점검 항목** | 7개 카테고리 | 7개 카테고리 | 동일한 포괄적 점검 |
| **📊 진행률 표시** | ✅ 실시간 | ✅ 실시간 | 시각적 진행 상황 표시 |
| **🌏 한글 지원** | ✅ 완전 지원 | ✅ 완전 지원 | 모든 메시지 및 출력을 한글로 표시 |
| **🔐 권한 요구** | 🔓 일반 사용자 | 🔓 일반 사용자 | 관리자 권한 불필요 |
| **📄 결과 파일** | ✅ 자동 생성 | ✅ 자동 생성 | 타임스탬프 파일명 |
| **🛡️ 오류 처리** | ✅ 강화됨 | ✅ 강화됨 | 안전한 실행 보장 |
| **🔧 네트워크 점검** | ✅ 티밍 구성 | ✅ 본딩 구성 | 고급 네트워크 설정 확인 |

</div>

---

## 📋 점검 항목

<div align="center">

### 🔍 **7개 카테고리 종합 시스템 점검**

</div>

<table>
<tr>
<td width="50%">

### 🪟 **Windows 10/11**

<div align="center">

#### 🖥️ **1. 시스템 기본 정보**
- ✅ 운영체제 정보 (Windows 10/11 구분)
- ✅ 시스템 제조사 및 모델
- ✅ BIOS 버전
- ✅ 프로세서 정보
- ✅ 메모리 정보

#### 🔧 **2. 하드웨어 상태**
- ✅ 메모리 사용량 및 상태
- ✅ 디스크 정보 및 사용률
- ✅ CPU 사용률 및 상태
- ✅ 온도 센서 정보

#### 📁 **3. 파일시스템 점검**
- ✅ 디스크 사용률
- ✅ 디스크 상태 점검
- ✅ 임시 파일 정보

#### 🌐 **4. 네트워크 인터페이스**
- ✅ 주요 네트워크 어댑터 정보
- ✅ VPN 연결 상태
- ✅ 인터넷 연결 상태
- ✅ DNS 서버 정보
- ✅ 공용 DNS 서버 연결 테스트
- ✅ 라우팅 테이블 (주요 경로)
- 🆕 **네트워크 티밍 구성 상태**

#### 🔌 **5. 서비스 및 포트**
- ✅ 주요 열린 포트 (상위 10개)
- ✅ 주요 서비스 상태
- ✅ Windows 방화벽 상태

#### ⚡ **6. 성능 상태**
- ✅ 시스템 부팅 시간
- ✅ 현재 시간
- ✅ 상위 프로세스 (상위 10개)
- ✅ 메모리 사용량

#### 🛡️ **7. 보안 점검**
- ✅ Windows 업데이트 상태
- ✅ Windows Defender 상태
- ✅ 관리자 권한 확인
- ✅ 사용자 계정 정보
- ✅ 로그인 실패 기록

</div>

</td>
<td width="50%">

### 🐧 **Rocky Linux 8/9**

<div align="center">

#### 🖥️ **1. 시스템 기본 정보**
- ✅ OS 정보 (Rocky Linux 버전)
- ✅ 커널 정보
- ✅ 시스템 제조사 및 모델
- ✅ 프로세서 정보
- ✅ 메모리 정보

#### 🔧 **2. 하드웨어 상태**
- ✅ 메모리 사용량 및 상태
- ✅ 디스크 정보 및 사용률
- ✅ CPU 사용률 및 상태
- ✅ 온도 센서 정보

#### 📁 **3. 파일시스템 점검**
- ✅ 디스크 사용률
- ✅ 파일시스템 타입
- ✅ inode 사용률
- ✅ 마운트 포인트 정보

#### 🌐 **4. 네트워크 인터페이스**
- ✅ 네트워크 인터페이스 정보
- ✅ IP 주소 및 라우팅
- ✅ 네트워크 연결 상태
- ✅ DNS 설정
- 🆕 **네트워크 본딩 구성 상태**

#### 🔌 **5. 서비스 및 포트**
- ✅ 열린 포트 정보
- ✅ 실행 중인 서비스
- ✅ 방화벽 상태 (firewalld)
- ✅ SELinux 상태

#### ⚡ **6. 성능 상태**
- ✅ 시스템 업타임
- ✅ 로드 평균
- ✅ 상위 프로세스
- ✅ 메모리 사용량

#### 🛡️ **7. 보안 점검**
- ✅ 시스템 업데이트 상태
- ✅ 보안 포트 점검
- ✅ 사용자 계정 정보
- ✅ 로그인 실패 기록

</div>

</td>
</tr>
</table>

---

## ⚠️ 경고 임계값

<div align="center">

### 🚨 **시스템 상태 모니터링 기준**

| 📊 메트릭 | 🟢 정상 | 🟡 주의 | 🔴 경고 | 💡 권장 조치 |
|:---:|:---:|:---:|:---:|:---:|
| **⚡ CPU 사용률** | < 70% | 70-80% | > 80% | 프로세스 최적화 또는 하드웨어 업그레이드 |
| **💾 디스크 사용률** | < 75% | 75-85% | > 85% | 불필요한 파일 정리 또는 디스크 확장 |
| **🧠 메모리 사용률** | < 80% | 80-90% | > 90% | 메모리 누수 확인 또는 RAM 추가 |

</div>

---

## 📸 실행 결과 미리보기

<div align="center">

### 🎬 **실제 실행 화면 미리보기**

</div>

<table>
<tr>
<td width="50%">

### 🪟 **Windows 실행 화면**

<div align="center">

```cmd
🖥️  Windows 시스템 점검을 시작합니다...
===============================================================

📊 진행률: [████████████████████████████████████████] 100% (7/7)

✅ 시스템 점검 완료!
📄 결과 파일: system_check_2025-09-30_20-11-45.txt
⏱️  실행 시간: 6.2초
```

**실행 과정:**
1. 🖥️ 시스템 정보 수집 중...
2. 🔧 하드웨어 상태 확인 중...
3. 📁 파일시스템 상태 확인 중...
4. 🌐 네트워크 상태 확인 중...
5. 🔌 서비스 및 포트 확인 중...
6. ⚡ 성능 상태 확인 중...
7. 🛡️ 보안 상태 확인 중...

</div>

</td>
<td width="50%">

### 🐧 **Rocky Linux 실행 화면**

<div align="center">

```bash
🖥️  Rocky Linux 시스템 점검을 시작합니다...
═══════════════════════════════════════════════════════════════

📊 진행률: [████████████████████████████████████████] 100% (7/7)

✅ 시스템 점검 완료!
📄 결과 파일: system_check_2025-09-30_20-25-06.txt
⏱️  실행 시간: 4.8초
```

**실행 과정:**
1. 🖥️ 시스템 정보 수집 중...
2. 🔧 하드웨어 상태 확인 중...
3. 📁 파일시스템 상태 확인 중...
4. 🌐 네트워크 상태 확인 중...
5. 🔌 서비스 및 포트 확인 중...
6. ⚡ 성능 상태 확인 중...
7. 🛡️ 보안 상태 확인 중...

</div>

</td>
</tr>
</table>

---

## 🛠️ 문제 해결

<div align="center">

### 🔧 **자주 발생하는 문제와 해결방법**

</div>

<table>
<tr>
<td width="50%">

### 🪟 **Windows 문제**

<div align="center">

| 🚨 문제 | ✅ 해결방법 | 💡 추가 정보 |
|:---:|:---:|:---:|
| **wmic 명령어 오류** | PowerShell로 자동 대체됨 | 스크립트 내장 오류 처리 |
| **한글 문자 깨짐** | UTF-8 인코딩 자동 설정됨 | `chcp 65001` 자동 실행 |
| **관리자 권한 필요** | 우클릭 → "관리자 권한으로 실행" | 일부 고급 기능만 필요 |
| **PowerShell 실행 정책** | `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser` | 스크립트 실행 허용 |

</div>

</td>
<td width="50%">

### 🐧 **Rocky Linux 문제**

<div align="center">

| 🚨 문제 | ✅ 해결방법 | 💡 추가 정보 |
|:---:|:---:|:---:|
| **Permission denied** | `chmod +x rocky_linux_system_check.sh` | 실행 권한 부여 |
| **명령어를 찾을 수 없음** | `sudo yum install net-tools procps-ng ss` | 필수 패키지 설치 |
| **권한 부족** | `sudo ./rocky_linux_system_check.sh` | 관리자 권한으로 실행 |
| **Bash 버전 오류** | `bash --version` 확인 후 업데이트 | Bash 4.0 이상 필요 |

</div>

</td>
</tr>
</table>

---

## 📈 업데이트 이력

<div align="center">

### 📅 **버전 히스토리**

</div>

<details>
<summary><strong>🆕 최신 업데이트 내역</strong></summary>

### 🆕 **v2.1 (2025-09-30)**
<div align="center">

| 🎯 주요 개선사항 | 📝 상세 내용 |
|:---:|:---:|
| **🔧 Linux 본딩 구성 상태 체크** | 본딩 모듈 로드 상태 확인, 인터페이스 및 모드 분석, 슬레이브 인터페이스 상태 모니터링, NetworkManager 본딩 연결 확인 |
| **🔧 Windows 티밍 구성 상태 체크** | NIC 티밍 팀 정보 분석, 팀 관련 어댑터 상태 확인, Hyper-V 가상 스위치 팀 구성, 네트워크 어댑터 바인딩 순서 |
| **🐛 버그 수정** | Windows 타임스탬프 형식 수정, CPU 사용률 계산 개선 (bc 명령어 제거), 진행률 표시 정확도 향상 |

</div>

### 🔧 **v2.0 (2025-09-21)**
<div align="center">

| 🎯 주요 개선사항 | 📝 상세 내용 |
|:---:|:---:|
| **🛡️ 보안 강화** | Windows Update 서비스 체크 제거, 방화벽 상태 상세 정보 추가 (도메인/개인/공용 프로필) |
| **🔍 네트워크 개선** | 바이러스 백신 상태 개선 (Windows Defender 상세 정보), 네트워크 정보 정리 (VMware, TAP 어댑터 필터링) |
| **📚 문서화** | 라우팅 테이블 용도 설명 추가, DNS 서버 정보 확장 |
| **🐛 버그 수정** | PowerShell 구문 오류 완전 해결, 모든 명령어를 안전한 배치 파일 명령어로 대체 |

</div>

</details>

---

## 📋 라이선스

<div align="center">

### 📜 **MIT 라이선스**

이 프로젝트는 **MIT 라이선스** 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

</div>

---

## 👨‍💻 작성자

<div align="center">

### 🚀 **Tae-system**

[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/xowk9876)
[![Instagram](https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/tae_system/)

</div>

---

<div align="center">

### ⭐ **이 프로젝트가 도움이 되었다면 Star를 눌러주세요!**

**Made with ❤️ by Tae-system**

</div>