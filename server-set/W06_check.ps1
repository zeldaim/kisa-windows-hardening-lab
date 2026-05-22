#Requires -RunAsAdministrator
# W06_check.ps1 — Administrators 그룹 멤버 점검

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) { New-Item -ItemType Directory -Path $resultDir | Out-Null }

$members     = Get-LocalGroupMember -Group "Administrators"
$memberNames = ($members | Select-Object -ExpandProperty Name | ForEach-Object { $_.Split("\")[-1] }) -join ", "

# SID -500 (built-in Administrator) 제외한 나머지 존재 여부 확인
$nonAdmin = $members | Where-Object {
    $sid = $_.SID.Value
    $sid -notlike "S-1-5-21-*-500"
}

if ($nonAdmin) {
    $fileName = "W06_Bad.txt"
    $result   = "Bad"
} else {
    $fileName = "W06_Good.txt"
    $result   = "Good"
}

$content = "ITEM_NAME : W-06 (Administrators Group Members)`r`nSTATUS    : $memberNames`r`nRESULT    : $result"
Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
