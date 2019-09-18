###################################################
#Gathering Hardware / Software Information
###################################################
get-counter
Get-CimInstance
Get-WmiObject
get-eventlog

#region examples
    get-counter -ListSet *memory* | where {$_.countersetname -eq "memory"} | select -Expand paths
    Get-CimInstance win32_physicalmemory | ft
    get-cimclass -ClassName *disk*
    Get-WmiObject -class win32_logicaldisk
    get-cimclass *bios*
    get-eventlog
    Get-EventLog -Newest 5 -LogName "Application"
    Get-EventLog -LogName System -EntryType Error
    Get-EventLog -LogName "Windows PowerShell" -ComputerName "localhost", "labdc01"
    Get-EventLog -Newest 5 -LogName "Application"
   $log = Get-EventLog -Log System -Newest 1
    $log | Format-List -Property *
#endregion

###################################################
#Gathering network Information
###################################################
ipconfig
Get-NetIPConfiguration
get-SMBMapping
new-SMBmapping

#region examples
    Ipconfig /all
    Get-NetIPConfiguration
    Get-NetIPAddress | ft
    GCM *dns*
    Get-DnsClient
    Get-DnsClientServerAddress
    Get-DnsClientCache
#endregion

###################################################
#Gathering registry information
###################################################
get-psprovider
Get-Item
Get-ItemProperty
Set-ItemProperty

#region Examples
    #NOTE letop op. Wel als Administrator!!
    $regPath = "hklm:\software\psintroduction"
    #Create RegKey and value
        new-item -Path hklm:\software -Name PSintroduction        
        New-ItemProperty  -Path  hklm:\software\psintroduction -Name "PackageInstalled" -PropertyType "String" -Value '0'
        New-ItemProperty  -Path  hklm:\software\psintroduction -Name "PackageName" -PropertyType "String" -Value 'PSintroduction.msi'
    #set registry value
        Set-ItemProperty -Path $regPath -name packageinstalled -value 0
        Get-Item $regPath 



    #Simple script. Set regkey. 
    # Controlleer of de key gevonden kan worden en set de waarde.
    # Als de key niet gevonden kan worden maak je de key en de waardes aan.
    If(Test-Path $regPath){
        Set-ItemProperty -Path $regPath -name packageinstalled -value 0
        Get-Item $regPath 
    }Else{
        Write-host "Registrypath $regpath not found" -for red
        Write-host "- Create Registrypath $regpath" -for Yellow
        new-item -Path hklm:\software -Name PSintroduction        
        New-ItemProperty  -Path  hklm:\software\psintroduction -Name "PackageInstalled" -PropertyType "String" -Value '0'
        New-ItemProperty  -Path  hklm:\software\psintroduction -Name "PackageName" -PropertyType "String" -Value 'PSintroduction.msi'
    }
#endregion

###################################################
#working withe files and printers
###################################################
Get-ChildItem
Copy-Item
Move-Item
Rename-Item
Get-Printer
add-printer
remove-printer

#region Examples
    get-childitem c:\data -recurse
    get-childitem c:\ -recurse -include *.png
    copy c:\data -Destination e:\data
    icacls.exe #view and setting permissions
    icacls.exe C:\Data
    Get-Printer
    Get-Printer -computername localhost
    add-printer -ConnectionName \\dc01\mktg-pr-101
    add-printer -name "\\dc01\mktg printer 101"
#endregion


###################################################
#working with activedirectory (ADDS)
###################################################
#region Examples connect to AD
    $RemoteServer  = "labdc01"
    $Module        = "ActiveDirectory"
    $remoteSession = new-pssession -computer $RemoteServer
    Invoke-Command -session $remoteSession -script { Import-Module ActiveDirectory }
    Import-PSSession -session $remoteSession -module $module #-prefix Rem
#endregion
get-aduser -identity user01
get-aduser -identity user01 -property *
Set-ADAccountPassword -Reset -NewPassword Welkom01#@$
get-aduser -filter *
Get-ADGroup -filter *
Get-ADGroup g_aut_test02 
Get-ADGroupMember g_aut_test02
New-ADUser -Name "Jaap de bruin" -GivenName Jaap -Surname Bruin -SamAccountName Jdebruin -UserPrincipalName Jdebruin@lab.local -AccountPassword (Read-Host -AsSecureString "AccountPassword") -Enabled $true
#Remoting Basics
Enable-PSRemoting
Get-PSSessionConfiguration
Set-PSSessionConfiguration
Set-NetFirewallRule

Enable-PSRemoting #aanzetten psremorting
Enable-PSRemoting -Force

#Enable-PSRemoting
#localadminaccount
#get-item WSMan:\localhost\Client\TrustedHosts
#set-item WSMan:\localhost\Client\TrustedHosts -value "webserver01"

get-netfirewallrule | where displayname -like "*windows management instrumentation*" | select displayname,name,enabled
get-netfirewallrule | where displayname -like "*windows management instrumentation*" | Set-NetFirewallRule -Enabled $true -verbose


#remoting with powershell
Get-Process -ComputerName
new-pssession
Enter-PSSession
Remove-PSSession
Invoke-Command
New-CimSession

Get-Process -ComputerName labdc01
get-service -ComputerName localhost,labdc01
gcm *-PSSession


#connect to domain controller and import Module
$RemoteServer  = "labdc01"
$Module        = "ActiveDirectory"
$remoteSession = new-pssession -computer $RemoteServer
Invoke-Command -session $remoteSession -script { Import-Module ActiveDirectory }
Import-PSSession -session $remoteSession -module $module #-prefix Rem

Remove-PSSession -Session $remoteSession








