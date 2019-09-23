
##############################################################################
# Password Database
##############################################################################
 Function get-KeePassPassword                  {
    <#
    .Synopsis
        To retrieve password from keypass database
    .DESCRIPTION
        To retrieve password from keypass database in powershell. Store you passwors in keypass and use them with on single masterpassword

       Author : Mark van de Waarsenburg
       Date   : 30-1-2017
                http://www.cloudcorner.nl/

    .NOTES


    .PARAMETER PathToKeePassFolder
        the path to the Keypass program files folder. Default entry is $env:ProgramFiles(x86)\KeePass Password Safe 2"
    .PARAMETER PathToDB
        The path to the keypass database. Default is de keypass database NewDatabase.kdbx in the root of the script.
    .PARAMETER EntryToFind
        The entry to find. It is the title of the keypass entry.
    .EXAMPLE
        get-KeePassPassword  -PathToKeePassFolder "C:\Program Files (x86)\KeePass Password Safe 2"  -PathToDB ".\NewDatabase.kdbx" -EntryToFind "Sample Entry"
    .EXAMPLE
        get-KeePassPassword  -PathToDB ".\NewDatabase.kdbx" -EntryToFind "Sample Entry"
    .EXAMPLE
        $PathToDB      = "E:\Keypass\NewDatabase.kdbx"
        $EntryToFind   = "Administrator"

        #Plainpassword from Keypass
        $Passwordfromkeypass = get-KeePassPassword -PathToDB  $PathToDB  -EntryToFind $EntryToFind
        $Passwordfromkeypass.password
        $Passwordfromkeypass.username

    .EXAMPLE
        $PathToDB      = "E:\Keypass\NewDatabase.kdbx"
        $EntryToFind   = "Administrator"

        #secure Password
        $Passwordfromkeypass = (ConvertTo-SecureString ((get-KeePassPassword -PathToDB  $PathToDB  -EntryToFind $EntryToFind).password ) -AsPlainText -Force )
   #>

    [CmdletBinding()]

    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$False)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $PathToKeePassFolder = "C:\Program Files (x86)\KeePass Password Safe 2" ,

        # Param2 help description
        [String]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $PathToDB = ".\NewDatabase.kdbx",

        # Param3 help description
        [Parameter(Mandatory=$True)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String]
        $EntryToFind 
 
       
    )

    Begin{

            #Load all .NET binaries in the folder
            (Get-ChildItem -recurse $PathToKeePassFolder |             
                Where-Object {($_.Extension -EQ ".dll") -or ($_.Extension -eq ".exe")} | 
                    ForEach-Object { 
                                $AssemblyName = $_.FullName
                                 Try {
                                    [Reflection.Assembly]::LoadFile($AssemblyName) 
                                 } Catch{ }
                            } 
            ) | out-null


            Function Get-PasswordInKeePassDB              {
                <#
                .Synopsis
                    Gets matching EntryToFind in KeePass DB
                .DESCRIPTION
                    Gets matching EntryToFind in KeePass DB using Windows Integrated logon
                .EXAMPLE
                    Example of how to use this cmdlet
                    Get-PasswordInKeePassDB -PathToDB "C:\Powershell\PowerShell.kdbx" -EntryToFind "MasterPassword"
                #>



                [CmdletBinding()]
                [OutputType([String[]])]

                param(                
                    # Path To password DB
                    $PathToDB = "E:\Keypass\NewDatabase.kdbx",
                    # Entry to find in DB
                    $EntryToFind = "Administrator",
                    # Password used to open KeePass DB        
                    [Parameter(Mandatory=$true)][String]$PasswordToDB 
                )

                begin{
                    #Load keypass variables and objects
                    $KeypassDatabase       = new-object KeePassLib.PwDatabase
                    $CompositeKey          = new-object KeePassLib.Keys.CompositeKey
                    $CompositeKey.AddUserKey((New-Object KeePassLib.Keys.KcpPassword($PasswordToDB))); 
                    $IOConnectionInfo      = New-Object KeePassLib.Serialization.IOConnectionInfo
                    $IOConnectionInfo.Path = $PathToDB
                    $NULLstatusLogger      = New-Object KeePassLib.Interfaces.NullStatusLogger
                    #open database

                    $KeypassDatabase.Open($IOConnectionInfo,$CompositeKey,$NULLstatusLogger)  
                                              
                }#endBegin

                process{
                    $PasswordItems = $KeypassDatabase.RootGroup.GetObjects($true, $true)
                    foreach($passwordItem in $PaswwordItems){
                               
                        if ($passwordItem.Strings.ReadSafe("Title") -eq $EntryToFind){
                            $KeypassEntry = New-object -TypeName PSobject -Property @{
                                    "Password" =  $passwordItem.Strings.ReadSafe("Password")
                                    "Username" =  $passwordItem.Strings.ReadSafe("UserName")
                                    "Title"    =  $passwordItem.Strings.ReadSafe("Title")
                                    "URL"      =  $passwordItem.Strings.ReadSafe("URL")
                                    "Notes"      =  $passwordItem.Strings.ReadSafe("Notes")
                            }
                            #$passwordItem.Strings.ReadSafe("Password")
                                
                        }#endIf
                    }#endIf
                                              
                        
                }#endprocess

                End{
                    $KeypassDatabase.Close()  
                    return $KeypassEntry                        
                }#endEnd

   
  

            } #endFunction
            Function Get-PasswordInKeePassDBUsingPassword {
                <#
                .Synopsis
                    Short description
                .DESCRIPTION
                    Long description
                .EXAMPLE
                    Example of how to use this cmdlet
                    GetPasswordInKeePassDBUsingPassword -EntryToFind "domain\username" -PasswordToDB myNonTopSeceretPasswordInClearText
                .EXAMPLE
                    Get password using Integrated logon to get master password and then use that to unlock and find the password in the big one.
                    Get-PasswordInKeePassDBUsingPassword -EntryToFind "domain\username" -PasswordToDB (Get-PasswordInKeePassDB -EntryToFind "MasterPassword")
                #>

                [CmdletBinding()]
                [OutputType([String[]])]

                Param
                (
                    # Path To password DB
                    $PathToDB = "E:\Keypass\NewDatabase.kdbx",
                    # Entry to find in DB
                    $EntryToFind = "Administrator",
                    # Password used to open KeePass DB        
                    [Parameter(Mandatory=$true)][String]$PasswordToDB
                )
               
                begin{
             
                    $KeypassDatabase       = new-object KeePassLib.PwDatabase

                    $CompositeKey          = new-object KeePassLib.Keys.CompositeKey
                    $CompositeKey.AddUserKey((New-Object KeePassLib.Keys.KcpPassword($PasswordToDB))); 
                    $IOConnectionInfo      = New-Object KeePassLib.Serialization.IOConnectionInfo
                    $IOConnectionInfo.Path = $PathToDB
                    $NULLstatusLogger      = New-Object KeePassLib.Interfaces.NullStatusLogger

                    $KeypassDatabase.Open($IOConnectionInfo,$CompositeKey,$NULLstatusLogger)                    
                }


                Process{
                    $PasswordItems = $KeypassDatabase.RootGroup.GetObjects($true, $true)
                        foreach($PasswordItem in $PasswordItems)
                        {
             
                            if ($PasswordItem.Strings.ReadSafe("Title") -eq $EntryToFind)
                            {
                                #$passwordItem.Strings.ReadSafe("Password")
                                $KeypassEntry = New-object -TypeName PSobject -Property @{
                                    "Password" =  $passwordItem.Strings.ReadSafe("Password")
                                    "Username" =  $passwordItem.Strings.ReadSafe("UserName")
                                    "Title"    =  $passwordItem.Strings.ReadSafe("Title")
                                    "URL"      =  $passwordItem.Strings.ReadSafe("URL")
                                    "Notes"    =  $passwordItem.Strings.ReadSafe("Notes")

                            }
                            }
                        }
                }

                End{
                        $KeypassDatabase.Close()
                        $PasswordToDB = $null                       
                            return $KeypassEntry  
                        
                }

               
     

            } #endFunction

    }#endprocess

    Process{
        If(!($PlainPassword)){
                $BSTR                 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($(read-host -Prompt "Password of KeePASS : " -AsSecureString))
                $Global:PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)            
        }

        $Password      = Get-PasswordInKeePassDBUsingPassword -PathToDB $PathToDB -PasswordToDB $PlainPassword  -EntryToFind $EntryToFind
    
    }#process

    End{
        return $Password  
    }#end

 } #End Function 
 Function set-KeePassPassword                  {
      <#
     .Synopsis
        aanmaken nieuw keypass entry en het wijzgingen van een entry
     .DESCRIPTION
        Long description
     .EXAMPLE
          $PathToDB      = "E:\Keypass\NewDatabase2.kdbx"
          $Entryname     = "Adminmw"
          $EntryUsername = "Adminmw"
          $entryPassword = "DitisEentestWachtwoord"
          set-KeePassPassword -PathToDB $PathToDB -Entryname $Entryname -EntryUsername $EntryUsername -EntryPassword $entryPassword -EntryURL "www.nu.nl" -EntryNotes "testaccount"
          get-KeePassPassword -PathToDB $PathToDB -EntryToFind $EntryToFind  
     .EXAMPLE
        Another example of how to use this cmdlet
     #>
     [CmdletBinding()]
     Param
     (
        # Param1 path to keypass application
        [Parameter(Mandatory=$False)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $PathToKeePassFolder = "C:\Program Files (x86)\KeePass Password Safe 2",
        # Param2 Keypass database
        [Parameter(Mandatory=$False)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $PathToDB            =   "E:\Keypass\NewDatabase2.kdbx", 
        [switch]$force,             
       # Param3 Entryname
        [Parameter(Mandatory=$True)]
        [String]$Entryname,
        [String]$EntryUsername,
        [String]$EntryPassword ,
        [String]$EntryURL,
        [String]$EntryNotes 
     )
 
     Begin{
            If($force){
                   $BSTR                = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($(read-host -Prompt "Password of KeePASS database : " -AsSecureString))
                   $Global:PasswordToDB = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR) 
            }
            If(!($PasswordToDB)){
                    $BSTR                = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($(read-host -Prompt "Password of KeePASS database : " -AsSecureString))
                    $Global:PasswordToDB = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)            
            }

            #############################################################################################
            # Connect to keyvault
            #############################################################################################
            $NULLstatusLogger      = New-Object KeePassLib.Interfaces.NullStatusLogger
            $KeypassDatabase       = new-object KeePassLib.PwDatabase
            $CompositeKey          = new-object KeePassLib.Keys.CompositeKey
            $IOConnectionInfo      = New-Object KeePassLib.Serialization.IOConnectionInfo
            $IOConnectionInfo.Path = $PathToDB
    
                $CompositeKey.AddUserKey((New-Object KeePassLib.Keys.KcpPassword($PasswordToDB))); 
                $KeypassDatabase.Open($IOConnectionInfo,$CompositeKey,$NULLstatusLogger)   



     }#Begin

     Process{

        #############################################################################################
        # Add new entry to Keyvault
        #############################################################################################
        $general   = $KeypassDatabase.RootGroup.FindGroup($KeypassDatabase.RootGroup.Groups.Uuid[0].UuidBytes,0)
        $NewEntry  = New-Object KeePassLib.PwEntry($general , $true , $true)

        #set entry
        if($Entryname){
            $title    = New-Object KeePassLib.Security.ProtectedString($true , $Entryname)
            $NewEntry.Strings.Set("Title",$title)
        }
        if($EntryUsername){
            $username = New-Object KeePassLib.Security.ProtectedString($true , $EntryUsername)
             $NewEntry.Strings.Set("UserName",$username)
             
        }
        if($EntryPassword){
            $Pass     = New-Object KeePassLib.Security.ProtectedString($true , $EntryPassword)
            $NewEntry.Strings.Set("Password",$pass)
        }
        if($EntryURL){
            $url  = New-Object KeePassLib.Security.ProtectedString($true , $EntryURL)
            $NewEntry.Strings.Set("UserName",$url)
        }
        If($EntryNotes){
            $Notes      = New-Object KeePassLib.Security.ProtectedString($true , $EntryNotes)
             $NewEntry.Strings.Set("UserName",$Notes)
        }
    
        #Add to keypass
        $general.AddEntry($NewEntry,1)
        $KeypassDatabase.Save($IStatusLogger)
        $KeypassDatabase.Close()


     }#Process

     End{

        $KeypassDatabase.Close() 

     }#End

 } #End Function 
 Function Connectto-Keepass                    {

    <#
    .Synopsis
       connect to keeypass
    .DESCRIPTION
       connect to keeypass. ReturnsTrue or false
    .EXAMPLE
        $PathTokeepassDB      = "C:\Users\Markv\OneDrive\Share\KeyVault\KeyvaultBackup.kdbx"
        $BSTR                 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($(read-host -Prompt "Password of KeePASS ($i/3) : " -AsSecureString))
        $Global:PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR) 
        
         Connectto-Keepass -PlainPassword $PlainPassword -PathTokeepassDB $PathTokeepassDB

    .EXAMPLE
        $i = 0
        do{
            $i++
 
            Write-host "[Error] : Password is invalid"
            $BSTR                 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($(read-host -Prompt "Password of KeePASS ($i/3) : " -AsSecureString))
            $Global:PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)      
   
   
        }while ((Connectto-Keepass -PlainPassword $PlainPassword -PathTokeepassDB $PathTokeepassDB) -eq $false)

    #>

    [CmdletBinding()]

    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        $PlainPassword,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true, Position=1)]
        $PathTokeepassDB
    )

    Begin{
        #Test path to keeypass database
        If(!(Test-path $PathTokeepassDB)){Write-Host "[error] : Keepass database ($PathTokeepassDB) not found" -ForegroundColor Red ; break }  

        Function Load-Keypass{
            $PathToKeePassFolder  = "C:\Program Files (x86)\KeePass Password Safe 2" 
            #Load all .NET binaries in the folder
            (Get-ChildItem -recurse $PathToKeePassFolder |             
                Where-Object {($_.Extension -EQ ".dll") -or ($_.Extension -eq ".exe")} | 
                    ForEach-Object { 
                                $AssemblyName = $_.FullName
                                    Try {
                                    [Reflection.Assembly]::LoadFile($AssemblyName) 
                                    } Catch{ }
                            } 
            ) | out-null

        }#end Function

        Load-Keypass
    
    
    }#Begin

    Process{
    
        $KeypassDatabase       = new-object KeePassLib.PwDatabase
        $CompositeKey          = new-object KeePassLib.Keys.CompositeKey
        $CompositeKey.AddUserKey((New-Object KeePassLib.Keys.KcpPassword($PlainPassword))); 
        $IOConnectionInfo      = New-Object KeePassLib.Serialization.IOConnectionInfo
        $IOConnectionInfo.Path = $PathTokeepassDB
        $NULLstatusLogger      = New-Object KeePassLib.Interfaces.NullStatusLogger

        Try{
            $KeypassDatabase.Open($IOConnectionInfo,$CompositeKey,$NULLstatusLogger)   
            Write-verbose "Connected to keepass" 
            $passwordcheck = $true
        }catch{
            $passwordcheck = $false
        }

       
        #$passwordItems = $KeypassDatabase.RootGroup.GetObjects($true, $true)
        #   foreach($passworditem in $passworditems){
        #    $passwordItem.Strings.ReadSafe("Title")
        #   }

    }#Process

    End{
        return $passwordcheck
    }#end

    

} #End Function 
##############################################################################
# Password and encryption Functions
##############################################################################
 Function New-AESKey                            {
    <#
     .Synopsis
        New-AESKey  
     .DESCRIPTION
        New-AESKey  
     .EXAMPLE 
        New-AESKey 
     .EXAMPLE 
        New-AESKey -AESKeySize 24       
    #>

    [CmdletBinding()] 

    param(
        [Parameter(Mandatory=$false)]
        [ValidateSet(16,24,32)]
        [int]$AESKeySize = 32
    )

    begin{}

    process{
        # Define AES KEY
          $AESKey = (New-Object Byte[] $AESKeySize)

        # Create Random AES Key in length specified in $Key variable.
          [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($AESKey)
    }

    end{
        return $AESKey
    }

} #End Function
 Function Convertto-SecureHashAES               {
    <#
     .Synopsis
        Convertto-SecureHashAES   
     .DESCRIPTION
        Convertto-SecureHashAES will convert plain text  to a hash.  
     .EXAMPLE 
         $AESKey     = new-AESKey -AESKeySize 16
         Convertto-SecureHashAES -token "ditiseensecuretoken" -tokenName "UnsealKey1" -AESKey $AESKey 
         
         Name         Hash                                                                                                                                                                                 
         ----         ----                                                                                                                                                                                 
         {UnsealKey1} 76492d1116743f0423413b16050a5345MgB8ADIATDMANA...

    #>

    [CmdletBinding()]     

    Param(
        # Param1 help description
        [Parameter(Mandatory=$true)]
        [string[]]$token ,
        [Parameter(Mandatory=$true)]
        [string[]]$tokenName ,

        # Param3 help description
        [Parameter(Mandatory=$false)]
        $AESKey
     
    )

    begin{
        if(!($AESKey)){$AESKey= new-AESKey }      
    }

    process{
        New-object -TypeName PSObject -Property @{
            AESKey = $AESkey
            Hash   = ConvertFrom-SecureString -SecureString (Convert-PLainpasswordtoSecurestring -token $token) -Key $AESKey
            Name   = $tokenName
        }
    }

    end{
        return $result
    }

} #End Function
 Function Convertfrom-SecureHashAES             {
    <#
     .Synopsis
        Convertfrom-SecureHashAES   
     .DESCRIPTION
        Convertfrom-SecureHashAES will convert the hashed token back to plain text 
     .EXAMPLE 
        $AESKey      = new-AESKey -AESKeySize 16
        $HashedToken = Convertto-SecureHashAES -token "DitIsEenSecureToken" -tokenName "UnsealKey1" -AESKey $AESKey

        Convertfrom-SecureHashAES -Hash $($HashedToken.hash) -AESKey $AESKey
    #>

    [CmdletBinding()]  

    param(
        # Param help description
        [Parameter(Mandatory=$true)]
        $AESKey,
        # Param help description
        [Parameter(Mandatory=$true)]    
        $Hashtoken 
    )

    begin{}

    process{
        $Hashtoken | ConvertTo-SecureString -key $AESKey | 
                ForEach-Object {[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($_))}
    }

    end{}
} #End Function  
              
 Function ConverSecurestringtoPLainPassword      {

    Param($secureString)

    Begin{
        $SecurePassword = $secureString
    }

    Process{        

            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
            $PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR) 
    
    }

    End{
        return $PlainPassword
    }



} #End Function
 Function ConvertPLainpasswordtoSecurestring     {

    $password   = "ZeergeheimPassword!" | ConvertTo-SecureString -asPlainText -Force
    $username   = "lab\adminmw"

    $credential = New-Object System.Management.Automation.PSCredential($username,$password)
} #End Function
 Function Create-SecurePasswordFile              {
    #Create-SecurePasswordFile -username svckl_LJP -Exportfile "D:\Mijn Test\Password\password.txt"
    Param(  $username ,
            $Exportfile = ".\Credentials_$username.txt"
    )

    Begin{  
        Write-host "Create Passwordfile"
    }

    Process{
        $credentials = Read-Host "$Username" -AsSecureString 
        $credentials | ConvertFrom-SecureString | out-file $Exportfile
    }
    
    End{
        Write-host "Passwordfile Created"
    }
} #End Function
 Function Create-SecurePasswordHash              {
    #Create-SecurePasswordHash -username domainname\username
    Param(  
        $username             
    )

    Begin{   
        Write-host "Create Passwordfile"
    }

    Process{
    $credentials = Read-Host "$Username" -AsSecureString 
    $hash = $credentials | ConvertFrom-SecureString 
    }
    
    End{
       Return $hash
    }
} #End Function
 Function Get-PasswordFromSecureFile             {
    <#
   .Example
    Get-PasswordFromSecureFile -importFile "D:\Mijn Test\Password\Password.xml" -username klpd\svckl_LJP
    Get-PasswordFromSecureFile -importFile "s:\password.txt" -username politienl\sysmark
    #>
    Param(
           [string]$importFile,
           [String]$username
    )

    Begin{
    }

    Process{  
    	    If ($ImportFile -like "*.txt"){$Password   = Get-Content $importFile} 
			ElseIf ($ImportFile -like "*.xml"){$Password  = Import-Clixml $importFile}            
            $password = $Password | ConvertTo-SecureString
            #Set credentials
            $credentials = New-object System.Management.Automation.PSCredential -ArgumentList $username, $password   
    }

    End{
            return $credentials
    }
} #End Function
 Function Get-PasswordFromHash                   {
    <#
   .Example
    Get-PasswordFromHash -Hash $hash -username politienl\sysmark 
    #>
    Param(
           [string]$Hash,
           [String]$username
    )

    Begin{
        #$hash = Create-SecurePasswordHash -username adminmw
        #ConverSecurestringtoPLainPassword -secureString $password
    }

    Process{  
         
            $password = $Hash | ConvertTo-SecureString
            #Set credentialsk
            $credentials = New-object System.Management.Automation.PSCredential -ArgumentList $username, $password   
    }

    End{
            return $credentials
    }
} #End Function


####################################################################################
#  BASICS PAssword
####################################################################################

  $password       = "Z33rGeheim"

  $SecurePassword = $password | ConvertTo-SecureString -asPlainText -Force
 
  $SecurePassword = Read-Host -Prompt "Add Password" -AsSecureString


  
# Convert Back to plain password
  $BSTR          = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
  $PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR) 
  $PlainPassword

  ConverSecurestringtoPLainPassword -secureString  $SecurePassword 


# Set Credential variable
  $SecurePassword = Read-Host -Prompt "Add Password" -AsSecureString
  $credential     = New-Object System.Management.Automation.PSCredential("lab\admininistrator",$SecurePassword)
  $credential     = New-object System.Management.Automation.PSCredential -ArgumentList "lab\admininistrator", $password   
  $credential     = get-credential -Message "Add credentials" -username "lab\admininistrator"

# Convert Back to plain password
  ConverSecurestringtoPLainPassword -secureString  ($credential.password)
  

# Secure. Safe your password secure
  $password       = "Z33rGeheim_LetsHash"
  $SecurePassword = $password | ConvertTo-SecureString -asPlainText -Force
  $credential     = New-Object System.Management.Automation.PSCredential("lab\admininistrator",$SecurePassword)

  $hash           = $credential.Password | ConvertFrom-SecureString 
  $hash           = "01000000d08c9ddf0115d1118c7a00c04fc297eb01000000994aa0e13460c34bace385604ea9dbf60000000002000000000010660000000100002000000042ac943290c4d84a97c55815b1c286c6623146114c8ab142d0a584fcd9b73618000000000e8000000002000020000000084dcd83b383475464963894edd80f6139d7214f22eafbea9be7a75c797b6fa7300000003f6be8fac73bab8ee890f248f5ff12e4b2f06bb05300e9f5b4adb74530403ef441349fec760b6a9a536d300880144f2d4000000022ae0cbe081eb2210a77126f078f595b610bca0187b0cac8c6dd9b047fe2d369aa7ed78ba08bffd66803d34092743b048f8e1d03ab29acce9a77cf4272205280"
  $SecurePassword = $hash   | ConvertTo-SecureString
   
  $hash | out-file C:\powershell\Passwordhash.txt 
  $readhash       = get-content C:\powershell\Passwordhash.txt 
  $SecurePassword = $readhash  | ConvertTo-SecureString

# Convert Back to plain password
  ConverSecurestringtoPLainPassword -secureString $SecurePassword

# Use The functions
  Create-SecurePasswordFile -username administrator -Exportfile C:\powershell\Passwordhash.txt 
  $credential = Get-PasswordFromSecureFile -importFile C:\powershell\Passwordhash.txt  -username administrator
  ConverSecurestringtoPLainPassword -secureString   $credential.Password

  $hash = Create-SecurePasswordHash -username domainname\username
  $credential = Get-PasswordFromHash -Hash $hash -username domainname\username
  ConverSecurestringtoPLainPassword -secureString   $credential.Password

####################################################################################
#  AES Encryption
####################################################################################
 $password       = "Z33rGeheim_metAES"
 $SecurePassword = $password | ConvertTo-SecureString -asPlainText -Force
 $securePassword = Convert-PLainpasswordtoSecurestring -token $password

# AES
 [int]$AESKeySize = 32
     $AESKey     = (New-Object Byte[] $AESKeySize)
# Create Random AES Key in length specified in $Key variable.
  [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($AESKey)
  $AESKey

  $SecurePasswordinHash = ConvertFrom-SecureString -SecureString $SecurePassword -Key $AESKey
# Convert back 
  $reversedPassword =  $SecurePasswordinHash | ConvertTo-SecureString -key $AESKey | ForEach-Object {[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($_))}
  $reversedPassword

# use the function 
  $AESKey      = new-AESKey -AESKeySize 16
  $HashedToken = Convertto-SecureHashAES -token "DitIsEenSecureToken" -tokenName "UnsealKey1" -AESKey $AESKey
  Convertfrom-SecureHashAES -Hash $($HashedToken.hash) -AESKey $AESKey

#---------------------------------------------------
# Extra : Secure the AES key aswell
#---------------------------------------------------
# Secure The AES Key with personal Hash

  #Create AES Key
  $AESKey               = new-AESKey -AESKeySize 16  
  #Convert AES to Hash 
  $AESKeyHash           = $($AESKey -join " ") | ConvertTo-SecureString -asPlainText -Force  | ConvertFrom-SecureString
  #save Hash to file
  $AESKeyHash | out-file C:\powershell\Secure_AES_hash.txt
  #read Hash from file
  $AESKeyHash           = get-content  C:\powershell\Secure_AES_hash.txt

# Convert Back AES Key for AES Key Hash
  $SecureStringToBSTR  = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($($AESKeyHash | ConvertTo-SecureString))
  $AESKey              = ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($SecureStringToBSTR)) -split (" ")  

  #Load Psssword
  $password       = "Z33rGeheim_metAESHASH"
  $SecurePassword = $password | ConvertTo-SecureString -asPlainText -Force
  $securePassword = Convert-PLainpasswordtoSecurestring -token $password
  #create a Password hash
  $SecurePasswordinHash = ConvertFrom-SecureString -SecureString $SecurePassword -Key $AESKey
  $SecurePasswordinHash
  #ConvertBAck to plain password
  Convertfrom-SecureHashAES -Hash $SecurePasswordinHash -AESKey $AESKey



####################################################################################
#  KEEPASS
####################################################################################
# GET PASSWORD form keepass
  $PathTokeepassDB      = "C:\Users\Markv\SynologyDrive\06_Zakelijk\10_Git\IntroductionPowershell\Introduction Powershell\Commands\Passwords\TestDatabase.kdbx"
  $BSTR                 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($(read-host -Prompt "Password of KeePASS ($i/3) : " -AsSecureString))
        
  Connectto-Keepass -PlainPassword $([System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR))  -PathTokeepassDB $PathTokeepassDB 


  $EntryToFind   = "Cursus_Powershell"
# secure Password
  $Passwordfromkeypass = (ConvertTo-SecureString ((get-KeePassPassword -PathToDB  $PathTokeepassDB  -EntryToFind $EntryToFind).password ) -AsPlainText -Force )

# Convert Back to plain password
  $BSTR          = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Passwordfromkeypass)
  $PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR) 
  $PlainPassword


  $x = get-KeePassPassword -PathToDB $PathTokeepassDB -EntryToFind Cursus_Powershell

  $y = $x.Password | Convertto-SecureString -asPlainText -Force

  
  $Entryname     = "Powershell"
  $EntryUsername = "Powershell"
  $entryPassword = "DitisEentestWachtwoord"
  set-KeePassPassword -PathToDB $PathTokeepassDB -Entryname $Entryname -EntryUsername $EntryUsername -EntryPassword $entryPassword -EntryURL "www.nu.nl" -EntryNotes "testaccount" -force
  get-KeePassPassword -PathToDB $PathTokeepassDB -EntryToFind $Entryname 


####################################################################################
#  Hashicorp Vault with API and psVault module
####################################################################################
& "C:\Program Files\Mozilla Firefox\firefox.exe" https://github.com/D2CIT/Hashicorp-Vault

#Download module and place in C:\Program Files\WindowsPowerShell\Modules
# - check if files are locked
    $Path  = "C:\Program Files\WindowsPowerShell\Modules\psvault" ;
    $files =  get-childitem -path $Path -recurse | where {$_.Attributes -eq "Archive" } ;
    foreach($file in $files){ 
         write-host " - Unblock $($file.FullName)" ; 
         Unblock-File -Path  $file.FullName 
    }#EndForeach

# note : examples how to use this module see examples folder in module. 
#  - "C:\Program Files\WindowsPowerShell\Modules\PSVault\1.0.1\Examples\01_install-vault.ps1"
#  - "C:\Program Files\WindowsPowerShell\Modules\PSVault\1.0.1\Examples\02_examples_API.ps1"

    
# Load VauLtobject
$vaultobject = Get-Vaultobject -Address "http://127.0.0.1:8200" -Token "s.q7h4Yhit1uwf3onsIOfZkzzO"  # example token.
    
# Set Vaultobject for connection to API 
    $VaultToken  = $env:VAULT_TOKEN
    $VaultObject = [pscustomobject]@{"uri" = "http://127.0.0.1:8200";"auth_header" = @{"X-Vault-Token" = $VaultToken }}

# Create  Secret Engine
    $SecretEngineName = "kv_powershell2"
    $uri              = "$($vaultobject.uri)/v1/sys/mounts/$SecretEngineName" 
    $KV_version       = 2

    #API CAll
    $payload = "{
        `"type`": `"kv`",
        `"options`": {
            `"version`": `"$KV_version`"
        }
    }"    
    Invoke-RestMethod -uri $uri -headers $($vaultObject.auth_header) -Method post -body $payload

    #use function from psVault module
    new-VaultSecretEngine -vaultobject $VaultObject -SecretEngineName $SecretEngineName

# Get KV Engine configuration
    $uri     = "$($vaultobject.uri)/v1/$SecretEngineName/config"
    Invoke-RestMethod -Uri $uri -Method get -Headers $VaultObject.auth_header  
    
# Set KV Engine configuration
    $uri     = "$($vaultobject.uri)/v1/$SecretEngineName/config"
    $payload = '{
        "max_versions": 5,
        "cas_required": false
    }'
    Invoke-RestMethod -Uri $uri -Method post -Headers $VaultObject.auth_header -body $Payload   

# Create Secret
    $SecretEngineName = $SecretEngineName
    $Application      = "vsphere_api"
    $environment      = "prd" 
    $secretPath       = "$Application/$environment"
    $uri_V1           = "$($vaultobject.uri)/v1/$SecretEngineName/$secretPath" 
    $uri_V2           = "$($vaultobject.uri)/v1/$SecretEngineName/data/$secretPath"
    #Secret to store
    $username         = "Administrator"
    $password         = "ZeerGeheim_PS"
    $Server           = "srv01"
    
    #API Call
    $data ="{`"data`": { `"username`": `"$username`", `"password`": `"$Password`",`"server`": `"$server`" }}"
    Invoke-RestMethod -uri $uri_v2 -headers $($vaultObject.auth_header) -Method post -body $data

    #use function from psVault module
    set-VaultSecret -VaultObject $vaultobject -secretEnginename $SecretEngineName `
                                              -SecretPath $secretPath `
                                              -username $username `
                                              -password $Password `
                                              -environment $environment `
                                              -tag $tag `
                                              -server $server
    get-VaultSecret -VaultObject $vaultobject -secretEnginename $SecretEngineName -SecretPath $secretPath 
# get Secret
    #API Call
    $result = Invoke-RestMethod -uri $uri_v2  -headers $($vaultObject.auth_header) -Method get 
    $object = New-Object -TypeName psobject -Property @{
                username       = $result.data.data.username
                password       = $result.data.data.password
                server         = $result.data.data.server 
                environment    = $result.data.data.environment
                tag            = $result.data.data.Tag
                created_time   = $result.data.metadata.created_time 
                deletion_time  = $result.data.metadata.deletion_time
                destroyed      = $result.data.metadata.destroyed
                version        = $result.data.metadata.version
                request_id     = $result.request_id 
                lease_duration = $result.lease_duration
                renewable      = $result.renewable
                wrap_info      = $result.wrap_info
                warnings       = $result.warnings
                auth           = $result.auth
            }#EndObject
    $object

    #use function from psVault module
    get-VaultSecret -VaultObject $vaultobject -secretEnginename $SecretEngineName -SecretPath $secretPath

    #Set credential
    $username       = $(get-VaultSecret -VaultObject $vaultobject -secretEnginename $SecretEngineName -SecretPath $secretPath).username
    $password       = $(get-VaultSecret -VaultObject $vaultobject -secretEnginename $SecretEngineName -SecretPath $secretPath).password | ConvertTo-SecureString -asPlainText -Force
    $credential     = New-object System.Management.Automation.PSCredential -ArgumentList $username, $password   


# Create Policy
    $vaultpath  = "C:\vault"
    $PolicyPath = "$VaultPath\config\policy"
    $PolicyName = "p_" + $SecretEngineName + "_" + $Application + "_" + $environment
    $PolicyFile = "$PolicyPath\$PolicyName.hcl"

    $capabilities =  "[`"read`",`"list`"]" 
    $path   = "$SecretEngineName/*"
    "path `"$Path`" {"                  | out-file -Encoding ascii -FilePath $PolicyFile
    "    capabilities = $capabilities " | out-file -Encoding ascii -FilePath $PolicyFile -append
    "}"                                 | out-file -Encoding ascii -FilePath $PolicyFile -append                             
    
    $capabilities =  "[`"read`",`"list`",`"create`",`"update`",`"delete`"]" 
    $path   = "$SecretEngineName/$Application/$environment/*"
    "path `"$Path`" {"                  | out-file -Encoding ascii -FilePath $PolicyFile -append
    "    capabilities = $capabilities " | out-file -Encoding ascii -FilePath $PolicyFile -append
    "}"                                 | out-file -Encoding ascii -FilePath $PolicyFile -append 

     vault policy write $PolicyName  $PolicyFile


# List policies
    $uri    = "$($vaultobject.uri)/v1/sys/policy" 
    $result = Invoke-RestMethod -Uri $uri -Method get -Headers $VaultObject.auth_header
    $policies = $result.policies
    $policies
