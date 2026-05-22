#Requires -RunAsAdministrator

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) {
    New-Item -ItemType Directory -Path $resultDir | Out-Null
}

$mpStatus = Get-MpComputerStatus -ErrorAction SilentlyContinue

if ($mpStatus -eq $null) {
    $content = "ITEM_NAME : PC-13 (Antivirus Program Update)`r`nSTATUS    : Windows Defender = Not Available`r`nRESULT    : Review"
    Set-Content -Path (Join-Path $resultDir "PC13_Review.txt") -Value $content -Encoding UTF8
    return
}

$defVer     = $mpStatus.AntivirusSignatureVersion
$lastUpdate = $mpStatus.AntivirusSignatureLastUpdated
$daysSince  = ((Get-Date) - $lastUpdate).Days

if ($daysSince -le 7) {
    $fileName = "PC13_Good.txt"
    $result   = "Good"
} else {
    $fileName = "PC13_Bad.txt"
    $result   = "Bad"
}

$content = "ITEM_NAME : PC-13 (Antivirus Program Update)`r`nSTATUS    : SignatureVersion = $defVer / LastUpdated = $($lastUpdate.ToString('yyyy-MM-dd')) ($daysSince days ago)`r`nRESULT    : $result"

Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
