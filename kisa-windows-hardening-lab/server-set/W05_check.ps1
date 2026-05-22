#Requires -RunAsAdministrator
# W05_check.ps1 — 해독 가능한 암호화로 저장 점검

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) { New-Item -ItemType Directory -Path $resultDir | Out-Null }

$tmpCfg = "$env:TEMP\secpol_w05.cfg"
secedit /export /cfg $tmpCfg /quiet

$value = (Get-Content $tmpCfg | Select-String "ClearTextPassword").ToString().Split("=")[1].Trim()
$value = [int]$value

Remove-Item $tmpCfg -Force -ErrorAction SilentlyContinue

if ($value -eq 0) {
    $fileName  = "W05_Good.txt"
    $result    = "Good"
    $statusMsg = "Disabled"
} else {
    $fileName  = "W05_Bad.txt"
    $result    = "Bad"
    $statusMsg = "Enabled"
}

$content = "ITEM_NAME : W-05 (Store Passwords Using Reversible Encryption)`r`nSTATUS    : ClearTextPassword = $statusMsg`r`nRESULT    : $result"
Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
