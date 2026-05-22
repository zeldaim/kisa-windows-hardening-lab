#Requires -RunAsAdministrator
# W01_check.ps1 — Administrator 계정명 변경 점검

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) { New-Item -ItemType Directory -Path $resultDir | Out-Null }

$adminAccount = Get-LocalUser | Where-Object { $_.SID.Value -like "S-1-5-21-*-500" }
$currentName  = $adminAccount.Name

if ($currentName -eq "Administrator") {
    $fileName = "W01_Bad.txt"
    $result   = "Bad"
} else {
    $fileName = "W01_Good.txt"
    $result   = "Good"
}

$content = "ITEM_NAME : W-01 (Administrator Account Rename)`r`nACCOUNT   : $currentName`r`nRESULT    : $result"
Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
