#Requires -RunAsAdministrator
# W18_check.ps1 — 불필요한 서비스 점검 (Simple TCP/IP)

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) { New-Item -ItemType Directory -Path $resultDir | Out-Null }

$svc = Get-Service -Name "simptcp" -ErrorAction SilentlyContinue

if ($svc -eq $null) {
    $fileName  = "W18_Good.txt"
    $result    = "Good"
    $statusStr = "Simple TCP/IP = Not Installed"
} elseif ($svc.Status -eq "Running") {
    $fileName  = "W18_Bad.txt"
    $result    = "Bad"
    $statusStr = "Simple TCP/IP = Running"
} else {
    $fileName  = "W18_Good.txt"
    $result    = "Good"
    $statusStr = "Simple TCP/IP = $($svc.Status)"
}

$content = "ITEM_NAME : W-18 (Unnecessary Services)`r`nSTATUS    : $statusStr`r`nRESULT    : $result"
Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
