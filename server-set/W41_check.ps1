#Requires -RunAsAdministrator
# W41_check.ps1 — NTP 시간 동기화 점검

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) { New-Item -ItemType Directory -Path $resultDir | Out-Null }

$regPath   = "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters"
$ntpRaw    = (Get-ItemProperty -Path $regPath -Name "NtpServer" -ErrorAction SilentlyContinue).NtpServer
$ntpServer = $ntpRaw.Split(",")[0].Trim()

if ($ntpServer -eq "time.windows.com") {
    $fileName = "W41_Good.txt"
    $result   = "Good"
} else {
    $fileName = "W41_Review.txt"
    $result   = "Review"
}

$content = "ITEM_NAME : W-41 (NTP Time Synchronization)`r`nSTATUS    : NtpServer = $ntpServer`r`nRESULT    : $result"
Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
