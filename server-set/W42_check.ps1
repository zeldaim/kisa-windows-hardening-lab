#Requires -RunAsAdministrator
# W42_check.ps1 — 보안 이벤트 로그 설정 점검

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) { New-Item -ItemType Directory -Path $resultDir | Out-Null }

$log      = Get-WinEvent -ListLog Security -ErrorAction SilentlyContinue
$maxSizeKB = [math]::Floor($log.MaximumSizeInBytes / 1024)
$logMode  = $log.LogMode  # Circular / AutoBackup / Retain

$sizeOk = ($maxSizeKB -ge 10240)
$modeOk = ($logMode -eq "AutoBackup")

if ($sizeOk -and $modeOk) {
    $fileName = "W42_Good.txt"
    $result   = "Good"
} else {
    $fileName = "W42_Bad.txt"
    $result   = "Bad"
}

$content = "ITEM_NAME : W-42 (Security Event Log Settings)`r`nSTATUS    : MaxSize = ${maxSizeKB}KB / LogMode = $logMode`r`nRESULT    : $result"
Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
