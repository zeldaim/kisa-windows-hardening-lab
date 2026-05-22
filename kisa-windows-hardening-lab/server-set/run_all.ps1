Get-ChildItem -Path "." -Filter "*_check.ps1" | ForEach-Object { & $_.FullName }
