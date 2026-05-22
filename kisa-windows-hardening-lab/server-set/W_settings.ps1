#Requires -RunAsAdministrator

# W-01 : Administrator 계정명 원복 (취약 상태)
$adminAccount = Get-LocalUser | Where-Object { $_.SID.Value -like "S-1-5-21-*-500" }
if ($adminAccount -and $adminAccount.Name -ne "Administrator") {
    Rename-LocalUser -Name $adminAccount.Name -NewName "Administrator"
}

# W-02 : Guest 계정 활성화 (취약 상태)
Enable-LocalUser -Name "Guest" -ErrorAction SilentlyContinue

# W-03 : 불필요한 계정 생성 (취약 상태)
foreach ($acct in @("test02", "test03")) {
    if (-not (Get-LocalUser -Name $acct -ErrorAction SilentlyContinue)) {
        $pw = ConvertTo-SecureString "asd123!@" -AsPlainText -Force
        New-LocalUser -Name $acct -Password $pw -PasswordNeverExpires | Out-Null
    }
}

# W-06 : Jack 계정을 Administrators 그룹에 추가 (취약 상태)
if (-not (Get-LocalUser -Name "Jack" -ErrorAction SilentlyContinue)) {
    $pw = ConvertTo-SecureString "asd123!@" -AsPlainText -Force
    New-LocalUser -Name "Jack" -Password $pw -PasswordNeverExpires | Out-Null
}
$isAdmin = Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue |
           Where-Object { $_.Name -like "*\Jack" -or $_.Name -eq "Jack" }
if (-not $isAdmin) {
    Add-LocalGroupMember -Group "Administrators" -Member "Jack"
}

# W-40 : 계정 관리 감사 로깅 비활성화 (취약 상태)
auditpol /set /category:"Account Management" /success:disable /failure:disable 2>&1 | Out-Null
