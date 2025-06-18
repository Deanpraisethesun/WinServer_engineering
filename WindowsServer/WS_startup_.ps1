# autologon
Set-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value Tsmc!234
Set-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value Administrator
Set-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 1

# proxy
netsh winhttp set proxy http://proxy-**.its.***.net:8080
#proxy-jp.its.
$server = "http://proxy-**.its.***.net"

Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyServer -Value "$($server):8080"
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyEnable -Value 1

#BCDedit
bcdedit /timeout 300
$OSVer= Get-ComputerInfo | Select-Object -ExpandProperty OsName
bcdedit /set description $OSVer
bcdedit /enum | findstr description

<#

.\smartupdate /s /tpmbypass /softwareonly


#Start-Process -FilePath "C:\path\to\cp029814.exe" -ArgumentList "/S" -Wait

#>

<#
 VBS, HVCI and System Guard

reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\SystemGuard" /v "Enabled" /t REG_DWORD /d 1 /f

#>
