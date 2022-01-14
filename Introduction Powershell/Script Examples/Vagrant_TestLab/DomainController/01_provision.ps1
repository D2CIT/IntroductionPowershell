################################################################################
# Prepare Host for Domain Controller
# ------------------------------------------------------------------------------
#    Author  : Mark van de Waarsenburg (Netherlands)
#    Company : D2C-IT  - Dare to Change IT
#    Date    : 29-9-2018
#    Script  : Setup server
#
################################################################################


Function test-Elevated
{
    <#
    .Synopsis
        test-elevated  
    .DESCRIPTION
        test-elevated  wil test if powershel is started with elevated rights
    .EXAMPLE
        test-elevated 

        WARNING: This script needs to be run As Admin (elevated)
    #>

    [CmdletBinding()]

    param()

    process{

        If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")){    
            write-warning  "This script needs to be run As Admin (elevated)"
            Break
        }
    }

} #EndFunction
Function set-Newfolder
{
    <#
    .Synopsis
        set-Newfolder  
    .DESCRIPTION
        set-Newfolder wil create an new folder if not exists
    .EXAMPLE
        set-Newfolder -path c:\PowerShell
    #>

    [CmdletBinding()]

    param (
        # Param1 help description
        [Parameter(Mandatory=$false, Position=0)]
        [string]$path
    )

    if(!(test-path $path)){
        mkdir $path | out-null
        if(!(test-path $path)){
            write-waring "[note] : Error creating Path $path !!!"
        }else{
            write-host "[note] : Path $path created" -for green
        }#EndIf 
    }else{
        write-host "[note] : Path $path already exists" -for green
    } #EndIf

} #EndFunction
Function set-PackageProvider
{
    <#
    .Synopsis
        set-PackageProvider  
    .DESCRIPTION
        set-PackageProvider will configure Nuget Package Provider
    .EXAMPLE
        set-PackageProvider -name nuget
    #>

    [CmdletBinding()]

    param (
        # Param1 help description
        [Parameter(Mandatory=$false, Position=0)]
        [ValidateSet("nuget")]
        [string]$name = "nuget"
    )

    If( get-PackageProvider | where-object {$_.name -like "$name"}){
        Write-host "[Note] : PackageProvider Nuget is installed"  -for Green
    }Else{
        Write-host "[Note] : Could not find PackageProvider Nuget and will be installed"  -for Yellow
        # Setup packageSource
        Get-PackageSource -name PSGallery | set-PackageSource -trusted -Force -ForceBootstrap | out-null
        Install-PackageProvider -name NuGet -force -Confirm:$false | out-null
    }#EndIF

} #EndFunction
Function set-DSCResource
{
    <#
    .Synopsis
        set-DSCResources  
    .DESCRIPTION
        set-DSCResources  will download and set powershell DSCresources
    .EXAMPLE
        set-DSCResources        
    .EXAMPLE
        set-DSCResources -DSCmodules xComputerManagement,xNetworking
    #>

    [CmdletBinding()]

    param (
        # Param1 help description
        [Parameter(Mandatory=$false, Position=0)]
        [string[]]$DSCmodule  = @("xComputerManagement","xNetworking","xDnsServer","xActiveDirectory","xPSDesiredStateConfiguration","xWinRM","xTimeZone","xWinEventLog","xAdcsDeployment","xSmbShare","xfailovercluster" )   
    )

    if($(get-InternetConnection) -like $true){            
        # IMPORT DSC RESOURCES
        write-host "[Note] : Install Powershell Modules for DSC" -for Yellow
        $installedModules = (get-module -ListAvailable | Where-Object {$_.name -like "x*"}).name
        Foreach($Module in $DSCmodule){
            
            if($installedModules -contains $module){
                write-host "         - Module $module " -for green
            }else{
                write-host "         - install Module $module " -for Yellow
                Install-Module -Name $Module -Confirm:$false -Force
            }                        
        }#Foreach
    }else{
        Write-host "No internet connection. Dsc resource can not be dowloaded"
    }#endIf
} #EndFunction
Function get-InternetConnection
{
    <#
    .Synopsis
        get-InternetConnection 
    .DESCRIPTION
        get-InternetConnection  will check the internet connection by pinging a website
    .EXAMPLE
        get-InternetConnection -site "www.nu.nl"
    #>

    [CmdletBinding()]

    param (
        # Param1 help description
        [Parameter(Mandatory=$false, Position=0)]
        [string]$site  = "www.nu.nl"   
    )


    If(!(test-connection -ComputerName $site -Count 1 -Quiet)){
        Write-Host -ForegroundColor Red -NoNewline "[Note] : Internet Connection down..."
        Write-Host ""
        wait 3
        $false
    }Else{
        Write-Host -ForegroundColor green -NoNewline "[Note] : Internet Connection OK"
        Write-Host ""
        $true
    }#EndIf

} #EndFunction


################################################################################
choco feature enable -n allowGlobalConfirmation

write-host "=========================================================="
write-host "  01 : Pre_config                                         "
write-host "=========================================================="
$Domaincontroller = $true

# Create Folder
    set-Newfolder "c:\scripts"

# Install packageprovider Nuget
    set-PackageProvider 

if($Domaincontroller -eq $true)
{
    # Download and install needed DSC resources
        set-DSCResource 
}#Endif

