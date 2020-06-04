
################################################################################
# Install and Configure host with DSC
# ------------------------------------------------------------------------------
#    Author  : Mark van de Waarsenburg (Netherlands)
#    Company : D2C-IT  - Dare to Change IT
#    Date    : 29-9-2018
#    Script  : Setup DSC test environemnt
#
################################################################################


param(
    [Parameter(Mandatory=$false)]
    $ScriptFolder = "c:\scripts" , 
    
    [Parameter(Mandatory=$false)]
    $ComputerName = "$Env:computername" ,

    [Parameter(Mandatory=$false)]
    $IPAddress    = "192.168.56.11",

    [Parameter(Mandatory=$false)]
    $Password     = "S3cr3tP@ssw0rd12!"
)

#Functions
Function Install-DomainController {

    [CmdletBinding()]

    Param(

        [Parameter(Mandatory=$false)]                       
        [string]$ComputerName      = "$env:computername" ,                         
    
        [Parameter(Mandatory=$true)]  
        [string]$IPAddress         = "192.168.56.40",  
    
        [Parameter(Mandatory=$false)]               
        [array]$DnsIpAddress       = @("$IPAddress","10.0.2.3") , 
    
        [Parameter(Mandatory=$false)]
        [string]$GatewayAddress    = "10.0.2.2", 
    
        [Parameter(Mandatory=$false)]                   
        [string]$InterfaceAlias    = "Ethernet 2",
    
        [Parameter(Mandatory=$false)]                  
        [string]$DomainName        = "d2cit.it" ,
    
        [Parameter(Mandatory=$false)]
        [string]$DomainUsername    = "d2cit\Adminmw",
    
        [Parameter(Mandatory=$false)]
        [string]$DomainDN          = "DC=d2cit,DC=it" , 
      
        [Parameter(Mandatory=$false)]
        [string]$scriptfolder      = "c:\Scripts", 
    
        [Parameter(Mandatory=$false)]                     
        [string]$CertificateFile   = "$scriptfolder\PowerShell\Cert\" + $ComputerName + "_DscPublicKey.cer" , 
        [Parameter(Mandatory=$false)]  
        [string]$outputPathLCM    =  "$scriptfolder\PowerShell\dsc\lcmconfigSecure" ,

        [Parameter(Mandatory=$false)]  
        [string]$outputPath       =  "$scriptfolder\PowerShell\dsc\BuildDomainController" ,

        [switch]$ForceCreateSelfSignedCertificate,
        [Boolean]$rebootNodeIfNeeded = $true,
        [Switch]$IncludeLCM,
        [Switch]$Force
    
    )

    Begin{
  
        configuration BuildDomainController         {

            Import-DscResource -ModuleName xActiveDirectory, xComputerManagement, xNetworking, xDnsServer, PSDesiredStateConfiguration 

            Node localhost
            {
                LocalConfigurationManager {
                    ActionAfterReboot = 'ContinueConfiguration'
                    ConfigurationMode = 'ApplyOnly'
                    RebootNodeIfNeeded = $true
                }

                ###########################################################################
                # Set IPAdress , Local Admin Password and Hostname
                ###########################################################################  
                xIPAddress NewIPAddress {
                    IPAddress      = $node.IPAddress
                    InterfaceAlias = $node.InterfaceAlias
                    AddressFamily  = 'IPV4'
                }
                xDefaultGatewayAddress NewIPGateway {
                    Address = $node.GatewayAddress
                    InterfaceAlias = $node.InterfaceAlias
                    AddressFamily = 'IPV4'
                    DependsOn = '[xIPAddress]NewIPAddress'
                }
                xDnsServerAddress PrimaryDNSClient {
                    Address = $node.DnsAddress
                    InterfaceAlias = $node.InterfaceAlias
                    AddressFamily = 'IPV4'
                    DependsOn = '[xDefaultGatewayAddress]NewIPGateway'
                }

                User Administrator {
                    Ensure    = 'Present'
                    UserName  = 'Administrator'
                    Password  = $domainCred
                    DependsOn = '[xDnsServerAddress]PrimaryDNSClient'
                }
                xComputer NewComputerName {
                    Name = $node.ThisComputerName
                    DependsOn = '[User]Administrator'
                }

                ###########################################################################
                # Install Windows features
                ###########################################################################  
                WindowsFeature ADDSInstall {
                    Ensure = 'Present'
                    Name = 'AD-Domain-Services'
                    DependsOn = '[xComputer]NewComputerName'
                }
                WindowsFeature RSAT-AD-Tools {
                    Ensure = 'Present'
                    Name = 'RSAT-AD-Tools'
                    DependsOn = '[WindowsFeature]ADDSInstall'
                    IncludeAllSubFeature = $true
                }
            

                ###########################################################################
                # Create First Domain
                ###########################################################################
                xADDomain FirstDC {
                    DomainName = $node.DomainName
                    DomainAdministratorCredential = $domainCred
                    SafemodeAdministratorPassword = $domainCred
                    DatabasePath = $node.DCDatabasePath
                    LogPath = $node.DCLogPath
                    SysvolPath = $node.SysvolPath 
                    DependsOn = '[WindowsFeature]ADDSInstall'
                }

                ###########################################################################
                # Create default OU structure
                ###########################################################################
                xADOrganizationalUnit D2C {
                    Name = "d2c"  
                    Path = "$($node.DomainDN)"          
                    Description = "Root OU D2C"
                    ProtectedFromAccidentalDeletion = $True
                    DependsOn = '[xADDomain]FirstDC'
                }

                xADOrganizationalUnit computers {
                    Path = "OU=D2C,$($node.DomainDN)"
                    Name = "computers"            
                    Description = "Computer OU"
                    ProtectedFromAccidentalDeletion = $True
                    DependsOn = '[xADOrganizationalUnit]D2C'
                }
                xADOrganizationalUnit users {
                    Path = "OU=D2C,$($node.DomainDN)"
                    Name = "users"            
                    Description = "users OU"
                    ProtectedFromAccidentalDeletion = $True
                    DependsOn = '[xADOrganizationalUnit]D2C'
                }
                xADOrganizationalUnit groups {
                    Path = "OU=D2C,$($node.DomainDN)"
                    Name = "groups"            
                    Description = "Groups OU"
                    ProtectedFromAccidentalDeletion = $True
                    DependsOn = '[xADOrganizationalUnit]D2C'
                }
        
                ###########################################################################
                # Create Users and add to the correct OU's
                ###########################################################################
                xADUser Adminmw {
                    DomainName = $node.DomainName
                    Path = "ou=users,ou=D2C,$($node.DomainDN)"
                    UserName = 'AdminMW'
                    GivenName = 'Mark'
                    Surname = 'van de Waarsenburg'
                    DisplayName = 'Mark van de Waarsenburg'
                    Enabled  = $true
                    Password = $domainCred
                    DomainAdministratorCredential = $domainCred
                    PasswordNeverExpires = $true
                    DependsOn = '[xADOrganizationalUnit]users'
                }
                xADUser AdminJM {
                    DomainName = $node.DomainName
                    Path = "ou=users,ou=D2C,$($node.DomainDN)"
                    UserName = 'AdminJM'
                    GivenName = 'Jean-Marc'
                    Surname = 'Zohlandt'
                    DisplayName = 'Jean-Marc Zohlandt'
                    Enabled = $true
                    Password = $domainCred
                    DomainAdministratorCredential = $domainCred
                    PasswordNeverExpires = $true
                    DependsOn = '[xADOrganizationalUnit]users'
                }
                xADUser JohnB {
                    DomainName = $node.DomainName
                    Path = "ou=users,ou=D2C,$($node.DomainDN)"
                    UserName = 'JohnB'
                    GivenName = 'Johan'
                    Surname = 'Bergman'
                    DisplayName = 'Johan Bergman'
                    Enabled = $true
                    Password = $domainCred
                    DomainAdministratorCredential = $domainCred
                    PasswordNeverExpires = $true
                    DependsOn = '[xADOrganizationalUnit]users'
                }
                xADUser PietH {
                    DomainName = $node.DomainName
                    Path = "OU=users,OU=D2C,$($node.DomainDN)"
                    UserName = 'PietH'
                    GivenName = 'Piet'
                    Surname = 'Hollander'
                    DisplayName = 'Piet Hollander'
                    Enabled = $true
                    Password = $domainCred
                    DomainAdministratorCredential = $domainCred
                    PasswordNeverExpires = $true
                    DependsOn = '[xADOrganizationalUnit]users'
                }
                ###########################################################################
                # Create and configure Groups
                ###########################################################################
                xADGroup IT {
                    GroupName = 'IT'
                    Path = "OU=groups,OU=D2C,$($node.DomainDN)"
                    Category = 'Security'
                    GroupScope = 'Global'
                    MembersToInclude = 'AdminMW', 'AdminJM'
                    DependsOn = '[xADOrganizationalUnit]groups'
                }
                xADGroup DomainAdmins {
                    GroupName = 'Domain Admins'
                    Path = "CN=users,$($node.DomainDN)"
                    Category = 'Security'
                    GroupScope = 'Global'
                    MembersToInclude = 'AdminJM', 'AdminMW'
                    DependsOn = '[xADDomain]FirstDC'
                }
                xADGroup EnterpriseAdmins {
                    GroupName = 'Enterprise Admins'
                    Path = "CN=users,$($node.DomainDN)"
                    Category = 'Security'
                    GroupScope = 'Universal'
                    MembersToInclude = 'AdminMW'
                    DependsOn = '[xADDomain]FirstDC'
                }
                xADGroup SchemaAdmins {
                    GroupName = 'Schema Admins'
                    Path = "CN=users,$($node.DomainDN)"
                    Category = 'Security'
                    GroupScope = 'Universal'
                    MembersToInclude = 'AdminMW'
                    DependsOn = '[xADDomain]FirstDC'
                }
                xDnsServerADZone addReverseADZone {
                    Name = '56.168.192.in-addr.arpa'
                    DynamicUpdate = 'Secure'
                    ReplicationScope = 'Forest'
                    Ensure = 'Present'
                    DependsOn = '[xADDomain]FirstDC'
                }
            }#Node
        } #configuration  

        configuration lcmconfigSecure               {
            #parameters
            param(
                [string[]]$computername,
                $CertificateID ,
                [boolean]$rebootNodeIfNeeded
            )

            #Target Node
            Node $computername {
                LocalconfigurationManager {
                    ConfigurationMode              = "applyAndAutocorrect"
                    ConfigurationModeFrequencyMins = 15
                    CertificateID                  = $CertificateID
                    RefreshMode                    = "Push"
                    rebootNodeIfNeeded             = $rebootNodeIfNeeded
                }

              
            }
        } #configuration
        
        
        if (!(test-path "$scriptfolder\PowerShell\Cert\") ){
            mkdir "$scriptfolder\PowerShell\Cert"
        }
        #if (!(test-path $OutputPathLCM ) ){mkdir $OutputPathLCM}
      
    }

    Process{

        # CREATE LOCAL SELFSIGNEDCERTIFICATE    
        if (!(test-path "$CertificateFile") -or $ForceCreateSelfSignedCertificate) {
            $cert = New-SelfSignedCertificate -Type DocumentEncryptionCertLegacyCsp `
                                              -DnsName "DSCEncryptionCert_$($env:computername)" `
                                              -FriendlyName "Server Authentication" `
                                              -HashAlgorithm SHA256 
            $cert | Export-Certificate -FilePath $CertificateFile -Force
        }
        $ImpCert = Import-Certificate -filepath $CertificateFile -CertStoreLocation cert:\localmachine\my
        
        #Run LCM
        if($LCM -or !(test-path $OutputPathLCM )){
            #Set LCM
            lcmconfigSecure -CertificateID $ImpCert.Thumbprint -computername localhost -OutputPath $OutputPathLCM -rebootNodeIfNeeded $rebootNodeIfNeeded
            
        }#EndIf
        # Push LCMConfiguration
        Set-DscLocalConfigurationManager -Path $outputPathLCM -Force -ComputerName localhost


        # Build MOF File for 
        If(!(test-path "$outputPath\localhost.mof") -or $Force){
            # Set paramaters for Config    
            $ConfigDataSecure = @{
                AllNodes = @(
                    @{
                        Nodename                    = "localhost"
                        ThisComputerName            = $ComputerName
                        IPAddress                   = $IPAddress 
                        DnsAddress                  = $DnsIpAddress
                        GatewayAddress              = $GatewayAddress
                        InterfaceAlias              = $InterfaceAlias
                        DomainName                  = $DomainName
                        DomainDN                    = $DomainDN
                        DCDatabasePath              = "C:\AD\NTDS"
                        DCLogPath                   = "C:\AD\NTDS"
                        SysvolPath                  = "C:\AD\Sysvol"
                        PSDscAllowPlainTextPassword = $false
                        PSDscAllowDomainUser        = $true
                        CertificateFile             = $CertificateFile
                        Thumbprint                  = $ImpCert.Thumbprint
                    }
                )#AllNodes
            }#ConfigData

            #Set Password            
            $SecurePassword = $password | ConvertTo-SecureString -asPlainText -Force
            $domainCred     = New-Object System.Management.Automation.PSCredential("d2cit\administrator",$SecurePassword)

            #Create MOF File
            BuildDomainController -ConfigurationData  $ConfigDataSecure -OutputPath $outputPath
        }#EndIf
               
        # Push Configuration
        Start-DscConfiguration -Wait -Force -Path C:\Scripts\PowerShell\dsc\BuildDomainController -Verbose  
    }

    end{}

} #EndFunction

write-host "=========================================================="
write-host "  02 : Domain controller  ( $ComputerName | $IPAddress )  "
write-host "=========================================================="

# Create Domain controller (Default Server will reboot)
    Install-domaincontroller -ScriptFolder $ScriptFolder `
                             -ComputerName $ComputerName `
                             -IPAddress $IPAddress `
                             -DomainName 'd2cit.it' `
                             -DomainUsername 'd2cit\adminmw' `
                             -DomainDN "DC=d2cit,DC=it" `
                             -rebootNodeIfNeeded $false