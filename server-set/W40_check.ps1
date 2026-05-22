#Requires -RunAsAdministrator
# W40_check.ps1 — 감사 정책 점검

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) { New-Item -ItemType Directory -Path $resultDir | Out-Null }

$audit = auditpol /get /category:* /r | ConvertFrom-Csv

$policies = @(
    @{ Subcategory = "User Account Management";  Expected = "Failure";            Label = "Account Management"        },
    @{ Subcategory = "Credential Validation";    Expected = "Success and Failure"; Label = "Account Logon Events"      },
    @{ Subcategory = "Sensitive Privilege Use";  Expected = "Success and Failure"; Label = "Privilege Use"             },
    @{ Subcategory = "Directory Service Access"; Expected = "Failure";            Label = "Directory Service Access"  },
    @{ Subcategory = "Logon";                    Expected = "Success and Failure"; Label = "Logon Events"              },
    @{ Subcategory = "Audit Policy Change";      Expected = "Success and Failure"; Label = "Policy Change"             }
)

$badItems  = @()
$allStatus = @()

foreach ($policy in $policies) {
    $row = $audit | Where-Object { $_.Subcategory -eq $policy.Subcategory }

    if ($row -eq $null) {
        $allStatus += "$($policy.Label) = Not Found"
        $badItems  += "$($policy.Label) = Not Found"
        continue
    }

    $current = $row."Inclusion Setting".Trim()
    $allStatus += "$($policy.Label) = $current"

    if ($current -ne $policy.Expected) {
        $badItems += "$($policy.Label) = $current (Expected: $($policy.Expected))"
    }
}

if ($badItems.Count -gt 0) {
    $fileName  = "W40_Bad.txt"
    $result    = "Bad"
    $statusStr = ($badItems -join " / ")
} else {
    $fileName  = "W40_Good.txt"
    $result    = "Good"
    $statusStr = ($allStatus -join " / ")
}

$content = "ITEM_NAME : W-40 (Audit Policy Settings)`r`nSTATUS    : $statusStr`r`nRESULT    : $result"
Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
