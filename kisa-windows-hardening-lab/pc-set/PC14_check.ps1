#Requires -RunAsAdministrator

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) {
    New-Item -ItemType Directory -Path $resultDir | Out-Null
}

$mpStatus = Get-MpComputerStatus -ErrorAction SilentlyContinue

if ($mpStatus -eq $null) {
    $content = "ITEM_NAME : PC-14 (Real-Time Protection)`r`nSTATUS    : Windows Defender = Not Installed`r`nRESULT    : Bad"
    Set-Content -Path (Join-Path $resultDir "PC14_Bad.txt") -Value $content -Encoding UTF8
    return
}

$rtEnabled = $mpStatus.RealTimeProtectionEnabled

if ($rtEnabled) {
    $fileName = "PC14_Good.txt"
    $result   = "Good"
} else {
    $fileName = "PC14_Bad.txt"
    $result   = "Bad"
}

$content = "ITEM_NAME : PC-14 (Real-Time Protection)`r`nSTATUS    : RealTimeProtectionEnabled = $rtEnabled`r`nRESULT    : $result"

Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
