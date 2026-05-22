#Requires -RunAsAdministrator
# W64_check.ps1 — Windows 방화벽 설정 점검

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) { New-Item -ItemType Directory -Path $resultDir | Out-Null }

$profiles  = Get-NetFirewallProfile
$badItems  = @()
$allStatus = @()

foreach ($profile in $profiles) {
    $allStatus += "$($profile.Name) = $($profile.Enabled)"
    if (-not $profile.Enabled) {
        $badItems += "$($profile.Name) = Disabled"
    }
}

if ($badItems.Count -gt 0) {
    $fileName  = "W64_Bad.txt"
    $result    = "Bad"
    $statusStr = ($badItems -join " / ")
} else {
    $fileName  = "W64_Good.txt"
    $result    = "Good"
    $statusStr = ($allStatus -join " / ")
}

$content = "ITEM_NAME : W-64 (Windows Firewall Settings)`r`nSTATUS    : $statusStr`r`nRESULT    : $result"
Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
