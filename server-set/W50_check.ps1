#Requires -RunAsAdministrator
# W50_check.ps1 — 감사 실패 시 시스템 중단 설정 점검

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) { New-Item -ItemType Directory -Path $resultDir | Out-Null }

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$value   = (Get-ItemProperty -Path $regPath -Name "CrashOnAuditFail" -ErrorAction SilentlyContinue).CrashOnAuditFail

if ($value -eq 0) {
    $fileName  = "W50_Good.txt"
    $result    = "Good"
    $statusStr = "CrashOnAuditFail = Disabled"
} else {
    $fileName  = "W50_Bad.txt"
    $result    = "Bad"
    $statusStr = "CrashOnAuditFail = Enabled"
}

$content = "ITEM_NAME : W-50 (Crash On Audit Full)`r`nSTATUS    : $statusStr`r`nRESULT    : $result"
Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
