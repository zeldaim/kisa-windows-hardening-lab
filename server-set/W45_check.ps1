#Requires -RunAsAdministrator
# W45_check.ps1 — 백신 프로그램 설치 여부 점검

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) { New-Item -ItemType Directory -Path $resultDir | Out-Null }

$mpStatus = Get-MpComputerStatus -ErrorAction SilentlyContinue

if ($mpStatus -ne $null) {
    $fileName  = "W45_Good.txt"
    $result    = "Good"
    $statusStr = "Windows Defender = Installed / AntivirusEnabled = $($mpStatus.AntivirusEnabled)"
} else {
    $fileName  = "W45_Bad.txt"
    $result    = "Bad"
    $statusStr = "Windows Defender = Not Installed"
}

$content = "ITEM_NAME : W-45 (Antivirus Program Installation)`r`nSTATUS    : $statusStr`r`nRESULT    : $result"
Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
