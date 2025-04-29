### 初始化 ###
$rootDir = Split-Path $PSScriptRoot -Parent
$jsonConfig = Get-Content "$rootDir\TestRecipe.json" | ConvertFrom-Json
$testCases = Get-Content "TestCase.txt"

### 狀態碼 ###
enum ExitCode { Success=0; Failure=1 }

### 安全協議檢查函數 ###
function Test-SecurityProtocol {
    param(
        [ValidateSet('SMB','RDP')]
        $Protocol
    )

    $result = [ExitCode]::Success
    switch ($Protocol) {
        'SMB' { 
            $config = Get-SmbServerConfiguration
            if ($config.EnableSMB1Protocol -or $config.EnableSMB2Protocol) { 
                $result = [ExitCode]::Failure
            }
        }
        'RDP' {
            $regValue = Get-ItemPropertyValue "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name fDenyTSConnections
            if ($regValue -ne 1) { $result = [ExitCode]::Failure }
        }
    }

    Write-Host "[$('✓','✗')[$result]] 已禁用$Protocol" -ForegroundColor (@('Green','Red')[$result])
    return $result
}

### 系統版本檢查函數 ###
function Get-SystemBuildVersion {
    $osInfo = [regex]::Match((systeminfo), 'OS Name:\s+Microsoft Windows Server (\d{4})')
    $osVer = "WS$($osInfo.Groups[1].Value)"
    
    $buildInfo = if ($osInfo.Groups[1].Value -eq '2016') {
        (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').UBR
    } else {
        [regex]::Match((cmd /c ver), '\.(\d+)\]').Groups[1].Value
    }

    [PSCustomObject]@{
        OSVersion = $osVer
        BuildNumber = $buildInfo
        ExpectedBuild = $jsonConfig.OS_VER.$osVer
    }
}

### 主執行流程 ###
try {
    $testCases.ForEach{
        if (Test-Path "Function:$_") {
            & $_ | ForEach-Object { 
                Write-Host "檢查項目：$_" 
            }
        }
    }
}
catch { Write-Error "執行失敗"; exit [ExitCode]::Failure }
