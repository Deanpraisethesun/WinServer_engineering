# 啟動Windows Time服務
Start-Service -Name W32Time

# 啟用NTP伺服器模式
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer" -Name "Enabled" -Value 1

# 設置NTP伺服器參數
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config" -Name "AnnounceFlags" -Value 5

# 重啟Windows Time服務
Restart-Service -Name W32Time

# 驗證配置
w32tm /query /configuration
