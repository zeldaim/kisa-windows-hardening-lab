#Requires -RunAsAdministrator

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) {
    New-Item -ItemType Directory -Path $resultDir | Out-Null
}

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
    $fileName  = "PC15_Bad.txt"
    $result    = "Bad"
    $statusStr = ($badItems -join " / ")
} else {
    $fileName  = "PC15_Good.txt"
    $result    = "Good"
    $statusStr = ($allStatus -join " / ")
}

$content = "ITEM_NAME : PC-15 (Windows Firewall Settings)`r`nSTATUS    : $statusStr`r`nRESULT    : $result"

Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
