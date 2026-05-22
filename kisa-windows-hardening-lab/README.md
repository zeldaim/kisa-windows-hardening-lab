# KISA Windows Hardening Lab

KISA 윈도우 보안 점검 항목을 PowerShell로 자동화한 실습 환경입니다.  
취약 환경 조성 → 자동 점검 → 수동 하드닝 → 재점검 흐름으로 구성됩니다.

---

## 환경

| 항목 | 내용 |
|---|---|
| PC 세트 | Windows 10 |
| 서버 세트 | Windows Server 2016 |
| 실행 도구 | PowerShell 5.1 (관리자 권한 필요) |

---

## 디렉토리 구조

```
kisa-windows-hardening-lab/
├── pc-set/
│   ├── PC_settings.ps1     # 취약 환경 조성 (Win10)
│   ├── PC02_check.ps1      # 패스워드 정책
│   ├── PC05_check.ps1      # 불필요한 서비스
│   ├── PC13_check.ps1      # 백신 서명 업데이트
│   ├── PC14_check.ps1      # 실시간 보호
│   ├── PC15_check.ps1      # 방화벽 설정
│   ├── run_all.ps1         # 전체 점검 실행
│   └── result/             # 점검 결과 저장
│
└── server-set/
    ├── W_settings.ps1      # 취약 환경 조성 (WinSrv2016)
    ├── W01_check.ps1       # Administrator 계정명 변경
    ├── W02_check.ps1       # Guest 계정 비활성화
    ├── W03_check.ps1       # 불필요한 계정
    ├── W04_check.ps1       # 계정 잠금 임계값
    ├── W05_check.ps1       # 평문 암호 저장
    ├── W06_check.ps1       # Administrators 그룹 멤버
    ├── W18_check.ps1       # 불필요한 서비스 (Simple TCP/IP)
    ├── W39_check.ps1       # 백신 서명 업데이트
    ├── W40_check.ps1       # 감사 정책
    ├── W41_check.ps1       # NTP 시간 동기화
    ├── W42_check.ps1       # 보안 로그 크기/모드
    ├── W43_check.ps1       # 로그 파일 접근 제어
    ├── W45_check.ps1       # 백신 설치 여부
    ├── W50_check.ps1       # CrashOnAuditFail
    ├── W64_check.ps1       # 방화벽 설정
    ├── run_all.ps1         # 전체 점검 실행
    └── result/             # 점검 결과 저장
```

---

## 실습 흐름

```
1. *_settings.ps1 실행    # 취약 환경 조성
2. run_all.ps1 실행       # 전체 점검
3. result/ 폴더 확인      # Bad 항목 확인
4. 수동 하드닝            # GUI 또는 PowerShell로 설정 변경
5. run_all.ps1 재실행     # Good으로 변경 확인
```

> ⚠️ `*_settings.ps1`은 실습용 취약 환경 조성 스크립트입니다. 운영 환경에서 절대 실행하지 마세요.

---

## 결과 파일 형식

```
ITEM_NAME : W-01 (Administrator Account Rename)
ACCOUNT   : Administrator
RESULT    : Bad
```

- `Wxx_Good.txt` → 양호
- `Wxx_Bad.txt` → 취약 (하드닝 필요)
- `Wxx_Review.txt` → 수동 검토 필요

---

## 점검 항목 요약

### PC 세트 (Windows 10)

| ID | 점검 내용 | 판정 기준 |
|---|---|---|
| PC-02 | 패스워드 정책 | 최소 길이 ≥ 8, 복잡성 = 활성화 |
| PC-05 | 불필요한 서비스 | Spooler, RemoteRegistry 중지 |
| PC-13 | 백신 서명 업데이트 | 7일 이내 업데이트 |
| PC-14 | 실시간 보호 | RealTimeProtection = True |
| PC-15 | 방화벽 설정 | 전 프로필 활성화 |

### 서버 세트 (Windows Server 2016)

| ID | 점검 내용 | 판정 기준 |
|---|---|---|
| W-01 | Administrator 계정명 변경 | 이름 ≠ "Administrator" |
| W-02 | Guest 계정 비활성화 | Enabled = False |
| W-03 | 불필요한 계정 | Review (수동 확인) |
| W-04 | 계정 잠금 임계값 | 1 ≤ 값 ≤ 5 |
| W-05 | 평문 암호 저장 비활성화 | ClearTextPassword = 0 |
| W-06 | Administrators 그룹 멤버 | 본계정(SID-500)만 존재 |
| W-18 | Simple TCP/IP 서비스 | 미설치 또는 중지 |
| W-39 | 백신 서명 업데이트 | 7일 이내 업데이트 |
| W-40 | 감사 정책 6개 항목 | KISA 권고 기준 일치 |
| W-41 | NTP 시간 동기화 | time.windows.com 또는 내부 NTP |
| W-42 | 보안 로그 크기/모드 | ≥ 10MB + AutoBackup |
| W-43 | 로그 파일 접근 제어 | Everyone 권한 없음 |
| W-45 | 백신 설치 여부 | Windows Defender 설치됨 |
| W-50 | CrashOnAuditFail | 비활성화 (0) |
| W-64 | 방화벽 설정 | 전 프로필 활성화 |

---

## 수동 하드닝 GUI 경로

| 항목 | 도구 | 경로 |
|---|---|---|
| W-01, 02, 03, 06 | `lusrmgr.msc` | 사용자 / 그룹 |
| W-04, 05 | `secpol.msc` | 계정 정책 > 암호/잠금 정책 |
| W-40 | `secpol.msc` | 로컬 정책 > 감사 정책 |
| W-42 | `eventvwr.msc` | Windows 로그 > 보안 > 속성 |
| W-64 | `wf.msc` | 각 프로필 속성 |
| W-50 | `regedit` | HKLM\SYSTEM\CurrentControlSet\Control\Lsa |

---

## References

- [KISA 주요정보통신기반시설 기술적 취약점 분석·평가 방법 상세가이드](https://www.kisa.or.kr)
- [Microsoft Sysinternals Sysmon](https://learn.microsoft.com/ko-kr/sysinternals/downloads/sysmon)
