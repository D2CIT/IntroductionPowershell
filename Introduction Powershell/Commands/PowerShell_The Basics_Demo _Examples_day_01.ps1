#############################################################################################################
#
#   POWERSHELL THE BASICS 
#____________________________________________________________________________________________________________
#
#   ####    ##    ###        # #####
#   #   #  #  #  #           #   #
#   #   #    #   #    ####   #   #
#   #   #   #    #           #   #
#   ####   ####   ###        #   #
#____________________________________________________________________________________________________________
#
#    Course by D2C-IT ( www.d2c-it.nl)
#
#    Author : Mark van de Waarsenburg
#    Date   : May 2020
#    Part   : Day 0ne  (https://www.2pdf.nl/pdf-naar-doc/)
#
#############################################################################################################

#======================================================================
# Bekende commando's
#======================================================================
#region Bekende commando's
  # Aliases for well known commands
    dir /s
    ls
    get-childitem
  # Create Folder
    mkdir c:\powershell
  # Test if folder is Created
    test-path c:\powershell
  # Set PowerShell path to folder
    set-location c:\powershell
  # Create Folder in current Path
    mkdir demo
  # Set PowerShell path to folder ( with Alias)
    cd demo
  ###################################3
  # Demo Copy files
  ###################################
  # Create folder (without output)
    mkdir c:\powershell\demo\DemoCopyFile | out-null
  # Create file 
    "create test file" | out-file c:\powershell\demo\DemoCopyFile\Test_File_01.txt
  # Copy File
    copy-item -Path c:\powershell\demo\DemoCopyFile\Test_File_01.txt -Destination c:\powershell\demo\DemoCopyFile\Test_File_02.txt
    # With Alias
      copy c:\powershell\demo\DemoCopyFile\Test_File_02.txt c:\powershell\demo\DemoCopyFile\Test_File_03.txt
      cp c:\powershell\demo\DemoCopyFile\Test_File_03.txt c:\powershell\demo\DemoCopyFile\Test_File_04.txt
    # Without Parameternames
      copy-item c:\powershell\demo\DemoCopyFile\Test_File_04.txt c:\powershell\demo\DemoCopyFile\Test_File_05.txt
      dir c:\powershell\demo\DemoCopyFile
  # Remove Files with alias command
    set-location DemoCopyFile
    del T*_01.txt
    dir c:\powershell\demo\DemoCopyFile
  # Remove files with cmdlet 
    remove-item -Recurse T*_02.txt
    remove-item -Recurse T* -Confirm:$False

  # Set location to root  
    cd\

  # Example Alias + Cmdlet parameters
    dir /s          # this will fail /s is not a parameter of get-childitem ( Dir is alias of  get-childitem )
    dir -recurse

#endregion

#======================================================================  
# Aliasses
#======================================================================
#region Aliases
  # Show all Aliases
    get-alias
  # Show cmdlet of alias 
    get-alias dir
    get-alias ls
    get-alias cd
  # Show Aliases of Cmdlet
    get-alias -Definition cd            # this will fail because cd is not a cmdlet but an alias
    get-alias -Definition get-childitem
    get-alias -Definition copyitem
  
# cmdlet parameters EventLog
    get-eventlog -LogName System -ComputerName .,localhost -verbose
    get-eventlog -LogName application -ComputerName .,localhost -verbose
    get-eventlog -LogName System -Newest 10

#endregion

#======================================================================
# Tab completion,afkortingen en parameter aliasen
#======================================================================
#region Tab completion
Get-Se #tab

    # Afkorten van parametername. Moet uniqyue zijn
      get-service -comp localhost 
      get-service -cn localhost
      get-process -name system
      get-process -n system

      gps system


#======================================================================
#Parameters
#======================================================================\
  # Show all services of localhost
    get-service
  # Show on service 
    get-service -name EventSystem 
    get-service -name EventSystem -computername localhost
  # ZO KORT MOGELIJK
    gps system -C .
    gps system -CN .
  # Show Help of get-service
    get-help get-service -full

#Postitionele : [-Class] <String>  (required = true)
#Postitionele : [[-Name    ] <String[]>]
#	       [[-Property] <String[]>]
#Named	     : [-ComputerName <String[]>]

#endregion

#======================================================================
#overige commando's
#======================================================================
#region
    # ping is not a PowerShell cmdlet but can be used
      ping localhost
    # test-connection is the PowerShell cmdlet of ping
      test-connection localhost
      test-connection localhost -Count 1
      (test-connection localhost -Count 1).IPV4Address
      (test-connection localhost -Count 1).IPV4Address.IPAddressToString
#endregion

#======================================================================
# Providers
#======================================================================
#region Providers
  # Create a new drive letter to a folder with Net use ( not a powershell Cmlet)
    net use * \\localhost\c$
    net use 
  # Show drives via WMI 
    Get-WmiObject Win32_NetworkConnection 
  # NOTE:      
  # - wel te zien in de Explore (open explorer)
  # - wel in een andere PowerShell session (open ander Powershell session)

  # Create a new driveletter to a folder with New-PSDrive ( Run PowerShell as Administrator)
    New-PSDrive -Name W -PSProvider FileSystem -Root \\localhost\c$
    New-PSDrive -Name Powershell -PSProvider FileSystem -Root \\localhost\c$
    get-psdrive -name Powershell | remove-psdrive 
    get-psdrive 
    cd w:
  # NOTE: 
  # - alleen te zien in deze powershell session
  # - niet te zien via net use
  # - niet te zien in explorer

  # Open powershell (NOT AS ADMINISTRATOR)
    New-PSDrive -Name m -PSProvider FileSystem -Root \\localhost\c$ -Persist
  # NOTE:      
  # - wel te zien in de Explore (open explorer)
  # - wel in een andere PowerShell session (open ander Powershell session)

  # Shwo All cmdlets with a noun name psdrive 
    gcm -noun psdrive
    get-psdrive -name m | remove-psdrive 
    remove-psdrive -name m
    get-psdrive | where {$_.provider -like "*filesystem"}

  # Show available CMDlets
    get-command
    gcm  
    (get-command).count
    get-command -verb get
    get-command -noun netw*
    get-command get-netw*
    Get-Command -noun *net
    gcm -noun pssnapin
    get-command -CommandType Alias
    get-command -CommandType Function
    get-command -CommandType Cmdlet
  # Show Count Aliases , Functions and Cmdlets    => SubExpression Example)
    write-host " Functions : $((get-command -CommandType Function).count)"
    write-host " Aliases   : $((get-command -CommandType alias).count)"
    write-host " Cmdlets   : $((get-command -CommandType Cmdlet).count)"

#endregion

#======================================================================
# Het Help systeem
#======================================================================
#region HELP
  # Use help to search for cmdlets
    get-help get    
    get-help *job*
    get-help job
    get-help -verb new
  # show Help of cmdlet
    get-help get-command 
    get-help get-command -Detailed
    get-help get-command -Examples
    get-help get-command -full
    get-help get-command -ShowWindow
    get-help get-command -Online
  # Aliases ... of toch niet
  # help is not an alias but a function for get-help | more
    help get-command
    cd function:
    type help
    dir h*
    set-location c:
  # Man is and Alias for help and NOT for get-help
    man get-command
    get-alias man
    get-alias -definition Help

  # Update Help. help is updateable. So out of the box the help is empty
    update-help -force
  # Save the help files to a separate folder for hosts without internet connection  (USB disk or networkshare)
    save-help -destinationPath C:\Powershell\Download_Help
  # update Help from a separate folder
    update-help -sourcepath C:\Powershell\Download_Help -Force



#======================================================================
# Het Help systeem
#======================================================================
  # get-help of cmdlet and check the syntax
    get-help get-eventlog
  # Note :
  #- verplicht positioneel : [-LogName] <String>
  #- optioneel positioneel : [[-InstanceId] <Int64[]>]
  #- named                 : [-After <DateTime>]
  #    	   		  [-ComputerName <String[]>]
  #- overig		: [<CommonParameters>]

  # Get help about common parameters
    get-help common
  # show About topix, default whitepapers about PowerShell stuff
    help about
    help about_Remote

#endregion

#======================================================================
# Understanding the pipeline
#======================================================================
#region the pipline
  # Show all services
    get-service
  # Show one service
    get-service -name wuauserv

  # Show all service but place those in the pipline and filter :
  # - only the services with the name Wuauserv
      get-service | Where-object name -like Wuauserv
  # - only the services starting with the letter W
      get-service | Where-object {$_.name -like "W*"} | Get-Member
  # - what kind of object is this ? With get-member you wiil only output what kind of object it is in the pipeline
      get-service | Where-object {$_.name -like "W*"} | Get-Member
  # - only the services with the name Wuauserv in list format
      get-service | Where-object {$_.name -like "Wuauserv"} | fl *
  # - only the services with the name Wuauserv in table format
      get-service | Where-object {$_.name -like "Wuauserv"} | ft *   
  # - All service with the status running
      get-service | Where-object {$_.status -eq "running"}
  # - All service with the status running ---> and stop all running service :-)  
  #   Let op -WHATIF!!!!
      get-service | Where-object {$_.status -eq "running"} | stop-service -whatif

#======================================================================
# pipeline Out-default
#======================================================================
    # List all processes. Default Powershell will out it to out-default
    get-process
    get-process | out-default


    # ? is alias for where-object
    get-service | Where-object {$_.status -eq "stopped"} | set-service -startuptype disabled -whatif
    get-service | ?{$_.status -eq "stopped"} | start-service -whatif

#endregion

#======================================================================
# out cmdlets
#======================================================================
#region
    get-command -verb out
    get-help -verb out-*
#endregion

#======================================================================
# write-output versus Write-Host
#======================================================================
#region write-output versus Write-Host
  # Show all cmdlets starting with the verb write
    get-command -verb write
  # Write-* examples ( no difference ..... but :-) )
    write-output "Dit is een Test"
    write-host "Dit is een Test"
  # Show help of both
    get-help write-output
    get-help write-host
  # Show difference
    write-output "Dit is een Test, write-output schrijft naar de Pipeline" -foreground yellow
    write-host "Dit is een Test, write-host schrijft direct naar de console window" -foreground yellow
  
  # write-output is an object so can be used in the pipelin
    write-output "test" | gm 
    (write-output "test" | gm).TypeName
    (write-output "test" | gm).TypeName | select -Unique
    write-output "test" | where-object {$_.length -gt 10}
    write-output "test" | where-object {$_.length -lt 10}
  # write-host will write directly to the commandline so it is not an object for pipline use
    write-host "hello" | gm    # will fail
    write-host "hello" | where-object {$_.length -gt 10}

#endregion

#======================================================================
#Providers
#======================================================================
#region providers
  # Sheet: Providers:
    Get-PSProvider
    Get-Command -Noun item
  
  # Sheet: Filesysteem PS Provider
    Get-PSDrive
    Get-ChildItem C:\PowerShell
    Get-ChildItem C:\PowerShell -File
    Get-ChildItem C:\PowerShell -Recurse 
    Get-ChildItem C:\PowerShell -Directory -Recurse | select fullname

  # Sheet: Navigeren en Wildcards
    Set-Location -Path C:\PowerShell
  # set location te registry : HKLM   
    Set-Location HKLM:software
    Get-ChildItem
    New-Item TestKey
  # return to C:\PowerShell
    Set-Location C:\PowerShell
  # Create new folder if not exists ( Example 1 )
    If(test-path  C:\PowerShell\NewFolder)
    {
        Write-host "The folder C:\PowerShell\NewFolder already exists" -for Green
    }
    else
    {
        Write-host "The folder C:\PowerShell\NewFolder will be created" -for yellow
        mkdir C:\PowerShell\NewFolder
    }#EndIf
  # Create new folder if not exists ( Example 2 )
    If(!(test-path  C:\PowerShell\NewFolder1))
    {
        Write-host "The folder C:\PowerShell\NewFolder will be created" -for yellow
        mkdir C:\PowerShell\NewFolder
    }
  # Create new folder if not exists ( Example 3 )
    If(!(test-path  C:\PowerShell\NewFolder1)){ mkdir C:\PowerShell\NewFolder1 }
  # Create new folder with new-item cmdlet
    New-Item C:\PowerShell\NewFolder2
    New-Item -type directory C:\PowerShell\NewFolder3

    Get-Item *.exe
    Help Get-Item -full

    get-itemproperty HKLM:\SYSTEM\CurrentControlSet\Control\Windows
    get-childitem HKLM:\SYSTEM\CurrentControlSet\Control\Windows\Shutdowntime
    
    New-Item PowerShellDemoExample 
    get-itemproperty "windows nt\currentversion"
    Set-Location HKCU:Software\*
#endregion   

#======================================================================
# Some registry examples
#======================================================================
#region Registry
  # Some examples to show HKCU
    Get-ChildItem -Path HKCU:\ | Select-Object Name
    Get-ChildItem -Path Registry::HKEY_CURRENT_USER
    Get-ChildItem -Path Microsoft.PowerShell.Core\Registry::HKEY_CURRENT_USER
    Get-ChildItem -Path Registry::HKCU
    Get-ChildItem -Path Microsoft.PowerShell.Core\Registry::HKCU
    Get-ChildItem HKCU:
    Get-ChildItem -Path HKCU:\ -Recurse
    Get-ChildItem -Path HKCU:\Software -Recurse | Where-Object {($_.SubKeyCount -le 1) -and ($_.ValueCount -eq 4) }

  # copy keys
    Copy-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' -Destination HKCU:
    Copy-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' -Destination HKCU: -Recurse

  # Create New Key
    New-Item -Path HKCU:\Software_DeleteMe
    New-Item -Path Registry::HKCU\Software_DeleteMe

  # Remove Keys
    Remove-Item -Path HKCU:\Software_DeleteMe
    Remove-Item -Path 'HKCU:\key with spaces in the name'
    Remove-Item -Path HKCU:\CurrentVersion -WhatIf

  # Read Key Value
    Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Windows -name Shutdowntime

  # Change Key value
    # get current value ( default is yes)
      Get-ItemProperty -Path "HKCU:\Control Panel\Sound" -Name beep
    # Change to No
      Set-ItemProperty -Path "HKCU:\Control Panel\Sound" -Name beep  -Value no
    # Show it;s no
      (Get-ItemProperty -Path "HKCU:\Control Panel\Sound" -Name beep).beep
    # change Bakc to yes
      Set-ItemProperty -Path "HKCU:\Control Panel\Sound" -Name beep  -Value yes


  # PowerShell Registry HKEY_LOCAL_MACHINE listing
    Set-Location HKLM:\
    Get-Childitem -ErrorAction SilentlyContinue | Format-Table Name, SubKeyCount, ValueCount -AutoSize


#endregion
 
