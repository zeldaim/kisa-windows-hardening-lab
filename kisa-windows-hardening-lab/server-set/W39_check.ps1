#Requires -RunAsAdministrator
# W39_check.ps1 — 백신 프로그램 업데이트 점검

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) { New-Item -ItemType Directory -Path $resultDir | Out-Null }

$mpStatus = Get-MpComputerStatus -ErrorAction SilentlyContinue

if ($mpStatus -eq $null) {
    $content = "ITEM_NAME : W-39 (Antivirus Program Update)`r`nSTATUS    : Windows Defender not available`r`nRESULT    : Review"
    Set-Content -Path (Join-Path $resultDir "W39_Review.txt") -Value $content -Encoding UTF8
    return
}

$defVer     = $mpStatus.AntivirusSignatureVersion
$lastUpdate = $mpStatus.AntivirusSignatureLastUpdated
$daysSince  = ((Get-Date) - $lastUpdate).Days

if ($daysSince -le 7) {
    $fileName = "W39_Good.txt"
    $result   = "Good"
} else {
    $fileName = "W39_Bad.txt"
    $result   = "Bad"
}

$content = "ITEM_NAME : W-39 (Antivirus Program Update)`r`nSTATUS    : SignatureVersion = $defVer / LastUpdated = $($lastUpdate.ToString('yyyy-MM-dd')) ($daysSince days ago)`r`nRESULT    : $result"
Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
