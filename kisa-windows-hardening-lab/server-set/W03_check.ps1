#Requires -RunAsAdministrator
# W03_check.ps1 — 불필요한 계정 점검 (자동 판정 불가 — Review)

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) { New-Item -ItemType Directory -Path $resultDir | Out-Null }

$accounts = (Get-LocalUser | Select-Object -ExpandProperty Name) -join ", "

$content = "ITEM_NAME : W-03 (Unnecessary Account Removal)`r`nSTATUS    : $accounts`r`nRESULT    : Review"
Set-Content -Path (Join-Path $resultDir "W03_Review.txt") -Value $content -Encoding UTF8
