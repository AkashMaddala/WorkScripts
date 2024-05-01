# Clear the console
Clear-Host

#region Set Execution Policy
Write-Host "Setting Execution Policy..."
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
    Write-Host "Execution Policy set successfully." -ForegroundColor Green
} catch {
    Write-Host "Failed to set Execution Policy. Error: $_" -ForegroundColor Red
}
Get-ExecutionPolicy -List
#endregion

#region Change DNS
Write-Host "Changing DNS Settings..."
$netadapter = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
if ($netadapter) {
    try {
        Set-DnsClientServerAddress -InterfaceIndex $netadapter.IfIndex -ServerAddresses ("153.91.26.71", "1.1.1.1")
        Write-Host "DNS settings changed successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to change DNS settings. Error: $_" -ForegroundColor Red
    }
} else {
    Write-Host "No active network adapter found." -ForegroundColor Yellow
}
#endregion

#region Set LocalAdmin Account and Password
Write-Host "Setting Local Administrator Account and Password..."
$Username = "localadmin"
$Password = Read-Host "Enter Password" -AsSecureString

$group = "Administrators"
$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
$existing = $adsi.Children | Where-Object { $_.SchemaClassName -eq 'user' -and $_.Name -eq $Username }

if ($existing -eq $null) {
    Write-Host "Creating new local user $Username."
    try {
        & NET USER $Username $Password /add /y /expires:never
        Write-Host "Adding local user $Username to $group."
        & NET LOCALGROUP $group $Username /add
        Write-Host "Local user $Username created successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to create local user $Username. Error: $_" -ForegroundColor Red
    }
} else {
    Write-Host "Setting password for existing local user $Username."
    try {
        & NET USER $Username $Password /expires:never
        Write-Host "Password for local user $Username updated successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to update password for local user $Username. Error: $_" -ForegroundColor Red
    }
}
#endregion

#region Set local administrator account password


Write-Host "Setting Local Administrator Account and Password..."
$AdminName = "Administrator"
#$Password = Read-Host "Enter Password" -AsSecureString

#$group = "Administrators"
$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
#$existing = $adsi.Children | Where-Object { $_.SchemaClassName -eq 'user' -and $_.Name -eq $AdminName }

if ($existing -eq $true) {
    Write-Host "Setting password for existing local user $AdminName."
    try {
        & NET USER $AdminName $Password /expires:never
        Write-Host "Password for local user $AdminName updated successfully." -ForegroundColor Green
        } catch {
        Write-Host "Failed to create local user $AdminName. Error: $_" -ForegroundColor Red
    }
} else {
    Write-Host "Setting password for existing local user $AdminName."
    try {
        #& NET USER $AdminName $Password /expires:never
        Write-Host "Password for local user $AdminName updated successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to update password for local user $AdminName. Error: $_" -ForegroundColor Red
    }
}

#endregion

#region Installing ZA Host using exe installer

Start-Process -FilePath :C:\ -ArgumentList "/silent","/install" -Wait

#endregion