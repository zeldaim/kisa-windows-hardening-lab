#Requires -RunAsAdministrator

# PC-02 : 최소 암호 길이 0 설정
net accounts /minpwlen:0 | Out-Null

# PC-05 : Print Spooler 서비스 실행
$spooler = Get-Service -Name "Spooler" -ErrorAction SilentlyContinue
if ($spooler -and $spooler.Status -ne "Running") {
    Set-Service -Name "Spooler" -StartupType Automatic
    Start-Service -Name "Spooler" -ErrorAction SilentlyContinue
}

# PC-15 : 공용 네트워크 방화벽 비활성화
Set-NetFirewallProfile -Profile Public -Enabled False
