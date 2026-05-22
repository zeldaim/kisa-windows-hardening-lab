#Requires -RunAsAdministrator
# W04_check.ps1 — 계정 잠금 임계값 점검

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) { New-Item -ItemType Directory -Path $resultDir | Out-Null }

$tmpCfg = "$env:TEMP\secpol_w04.cfg"
secedit /export /cfg $tmpCfg /quiet

$threshold = (Get-Content $tmpCfg | Select-String "LockoutBadCount").ToString().Split("=")[1].Trim()
$threshold = [int]$threshold

Remove-Item $tmpCfg -Force -ErrorAction SilentlyContinue

if ($threshold -ge 1 -and $threshold -le 5) {
    $fileName = "W04_Good.txt"
    $result   = "Good"
} else {
    $fileName = "W04_Bad.txt"
    $result   = "Bad"
}

$content = "ITEM_NAME : W-04 (Account Lockout Threshold)`r`nSTATUS    : LockoutBadCount = $threshold`r`nRESULT    : $result"
Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
