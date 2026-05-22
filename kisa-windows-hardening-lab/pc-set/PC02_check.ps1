#Requires -RunAsAdministrator

$resultDir = Join-Path $PSScriptRoot "result"
if (-not (Test-Path $resultDir)) {
    New-Item -ItemType Directory -Path $resultDir | Out-Null
}

$tmpCfg = "$env:TEMP\secpol_pc02.cfg"
secedit /export /cfg $tmpCfg /quiet

$minLength  = [int](Get-Content $tmpCfg | Select-String "MinimumPasswordLength").ToString().Split("=")[1].Trim()
$complexity = [int](Get-Content $tmpCfg | Select-String "PasswordComplexity").ToString().Split("=")[1].Trim()

Remove-Item $tmpCfg -Force -ErrorAction SilentlyContinue

$lengthOk     = ($minLength -ge 8)
$complexityOk = ($complexity -eq 1)

if ($lengthOk -and $complexityOk) {
    $fileName = "PC02_Good.txt"
    $result   = "Good"
} else {
    $fileName = "PC02_Bad.txt"
    $result   = "Bad"
}

$content = "ITEM_NAME : PC-02 (Password Policy)`r`nSTATUS    : MinimumPasswordLength = $minLength / PasswordComplexity = $complexity`r`nRESULT    : $result"

Set-Content -Path (Join-Path $resultDir $fileName) -Value $content -Encoding UTF8
