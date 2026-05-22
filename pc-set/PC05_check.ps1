#Requires -RunAsAdministrator

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) {
    New-Item -ItemType Directory -Path $resultDir | Out-Null
}

$targets    = @("Spooler", "RemoteRegistry")
$badItems   = @()
$allStatus  = @()

foreach ($svcName in $targets) {
    $svc         = Get-Service -Name $svcName -ErrorAction SilentlyContinue
    $displayName = if ($svcName -eq "Spooler") { "Print Spooler" } else { "Remote Registry" }

    if ($svc -eq $null) {
        $allStatus += "$displayName = Not Found"
    } else {
        $allStatus += "$displayName = $($svc.Status)"
        if ($svc.Status -eq "Running") {
            $badItems += "$displayName = Running"
        }
    }
}

if ($badItems.Count -gt 0) {
    $fileName   = "PC05_Bad.txt"
    $result     = "Bad"
    $statusStr  = ($badItems -join " / ")
} else {
    $fileName   = "PC05_Good.txt"
    $result     = "Good"
    $statusStr  = ($allStatus -join " / ")
}

$content = "ITEM_NAME : PC-05 (Unnecessary Services)`r`nSTATUS    : $statusStr`r`nRESULT    : $result"

Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
