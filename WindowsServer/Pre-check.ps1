### 初始化 ###
$rootDir = Split-Path $PSScriptRoot -Parent
$jsonConfig = Get-Content "$rootDir\TestRecipe.json" | ConvertFrom-Json
$TestCases = Get-Content "TestCase.txt"

### 狀態與輸出格式 ###
enum Status { 通過; 失敗 }
$statusIcons = @{ 
    [Status]::通過 = @{ Object="[✓] "; Color="Green" }
    [Status]::失敗 = @{ Object="[✗] "; Color="Red" }
}

### 核心檢查函式 ###
function Test-SMBProtocol {
    param([ValidateSet("v1","v2")]$Version)
    $config = Get-SmbServerConfiguration
    return $Version -eq "v1" ? $config.EnableSMB1Protocol : $config.EnableSMB2Protocol
}

function Confirm-SMBStatus {
    $result = @{
        "SMBv1禁用" = (Test-SMBProtocol "v1") -eq $false
        "SMBv2啟用" = (Test-SMBProtocol "v2") -eq $true
    }
    $result.Values -contains $false ? [Status]::失敗 : [Status]::通過
}

function Confirm-OSBuild {
    $osVer = (Get-ComputerInfo).WindowsVersion
    $buildMatch = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").UBR -eq $jsonConfig.BuildNumber
    return $buildMatch ? [Status]::通過 : [Status]::失敗
}

### 主執行流程 ###
try {
    $TestCases.ForEach{
        $status = & "Confirm-$($_)"
        $output = $statusIcons[$status]
        Write-Host $output.Object -NoNewline -ForegroundColor $output.Color
        Write-Host $_ 
    }
    exit [int][Status]::通過
}
catch { 
    Write-Error "檢查程序異常中斷"
    exit [int][Status]::失敗
}
