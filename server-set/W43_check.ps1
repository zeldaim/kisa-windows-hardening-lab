#Requires -RunAsAdministrator
# W43_check.ps1 — 이벤트 로그 파일 접근 제어 점검

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) { New-Item -ItemType Directory -Path $resultDir | Out-Null }

$targetPaths = @(
    "$env:SystemRoot\system32\config",
    "$env:SystemRoot\system32\LogFiles"
)

$badItems = @()

foreach ($path in $targetPaths) {
    $acl         = Get-Acl -Path $path -ErrorAction SilentlyContinue
    $everyoneAce = $acl.Access | Where-Object { $_.IdentityReference -match "Everyone" }
    if ($everyoneAce) {
        $badItems += $path
    }
}

if ($badItems.Count -gt 0) {
    $fileName  = "W43_Bad.txt"
    $result    = "Bad"
    $statusStr = "Everyone permission found: " + ($badItems -join " / ")
} else {
    $fileName  = "W43_Good.txt"
    $result    = "Good"
    $statusStr = "No Everyone permission on target paths"
}

$content = "ITEM_NAME : W-43 (Event Log File Access Control)`r`nSTATUS    : $statusStr`r`nRESULT    : $result"
Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
