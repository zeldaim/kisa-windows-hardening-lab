#Requires -RunAsAdministrator
# W02_check.ps1 — Guest 계정 비활성화 점검

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) { New-Item -ItemType Directory -Path $resultDir | Out-Null }

$guest = Get-LocalUser -Name "Guest" -ErrorAction SilentlyContinue

if ($guest.Enabled -eq $false) {
    $fileName = "W02_Good.txt"
    $result   = "Good"
} else {
    $fileName = "W02_Bad.txt"
    $result   = "Bad"
}

$content = "ITEM_NAME : W-02 (Guest Account Status)`r`nSTATUS    : Enabled = $($guest.Enabled)`r`nRESULT    : $result"
Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
