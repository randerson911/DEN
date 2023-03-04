[CmdletBinding(DefaultParametersetname="NoExport")]
Param(
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $True)]
    [string]$username,
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $True)]
    [string]$password,
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $True)]
    [String]$domain
)

# TODO: Dynamically take username, password and hostname during build phase for build-variables.json.
# $username = "Steven"
# $password = "ComtechAdminPassword123!"
# $domain = "Student"

function Add-Registry() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [String]$path,
        [String]$key,
        [String]$type,
        $value
    )
    # Creates nested registry keys
    Write-Output "[*] Adding value: '$value' to key: '$key' on registry path: '$path'" 
    Try {
        If (-Not (Test-Path $path)) {
            Add-Registry -path ($path | Split-Path -Parent) -key ($path | Split-Path -Leaf)
        }
        If ($value) {
            Write-Output "[*] Adding value: '$value' to key: '$key' on registry path: '$path'" *>> "$logsLocation\Registry.log"
            If ($type) {
                Set-ItemProperty -Path $path -Name $key -Type $type -Value $value -Force *>> "$logsLocation\Registry.log"
            }
            else {
                Set-ItemProperty -Path $path -Name $key -Value $value -Force *>> "$logsLocation\Registry.log"
            }
            $newValue = (Get-ItemProperty -Path $path -Name $key).$key
            $newValue *>> "$logsLocation\Registry.log"
            if ($value -ne $newValue) {
                Write-Output "[!] New value: '$newValue' does not match old: '$value' under key: '$key', path: '$path'" 
            }
            else {
                Write-Output "[+] Successfully added VALUE: '$value' to key: '$key' on registry path: '$path'" 
            }
        }
        else {
            New-Item -Path $path -Name $key -Force *>> "$logsLocation\Registry.log"
            Write-Output "[+] Successfully added KEY: '$key' to registry path: '$path'" 
        }
    }
    Catch {
        Write-Output "[-] Error adding value: '$value' to key: '$key' on registry path: '$path'" 
    }
}

function Set-Autologon() {
    [CmdletBinding()]
    param (
        [String]$domain = "$domain",
        [String]$user = "$username",
        [String]$pass = "$password"
    )
    # Create cached autologon settings and reboot. This is rrequired to create initial user profile. Otherwise sysprep will trash the image.
    try {
        #C:\Tools\SysinternalsSuite\AutoLogon.exe "$username" "$hostname" "$password" -accepteula
        Write-Output "[*] Set autologon to user: '$domain\$user', password: '$pass'." 

        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "DefaultDomain" -value "$domain" -type String
        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "DefaultUsername" -value "$username" -type String
        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "DefaultPassword" -value "$pass" -type String
        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "AutoAdminLogon" -value 1 -type String

        #Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "ForceAutoLogon" -value 1 -type String
        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "AutoLogonCount" -value 10 -type dword

        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "AutoRestartShell" -value 00000001 -type dword
        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "CachedLogonsCount" -value "10" -type String
        #Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "ForceUnlockLogon" -value 00000000 -type dword
        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "PasswordExpiryWarning" -value 00000005 -type dword
        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "Shell" -value "explorer.exe" -type String
        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "ShellInfrastructure" -value "sihost.exe" -type String
        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "SiHostCritical" -value 00000000 -type dword
        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "SiHostReadyTimeOut" -value 00000000 -type dword
        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "SiHostRestartCountLimit" -value 00000000 -type dword
        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "SiHostRestartTimeGap" -value 00000000 -type dword
        #Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "Userinit" -value "C:\\windows\\system32\\userinit.exe," -type String

        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "WinStationsDisabled" -value "0" -type String
        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "DisableCAD" -value 00000001 -type dword
        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "ShutdownFlags" -value 00000007 -type dword
        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "EnableFirstLogonAnimation" -value 00000000 -type dword
        Add-Registry -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -key "DefaultDomainName" -value "$domain" -type String

        #"AutoLogonSID"="S-1-5-21-1547069162-3854204317-3181239818-500"
        Write-Output "[+] Successfully added user: '$domain\$user' to autologon." 
    }
    Catch {
        Write-Output "[-] Error when adding autologon for user: '$domain\$user'" 
    }
}

Set-Autologon -domain $domain -user $username -pass $password
