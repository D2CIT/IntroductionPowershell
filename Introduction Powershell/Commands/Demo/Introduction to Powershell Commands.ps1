
#region Demo 1
#======================================================================
#Bekende commando's
#======================================================================
dir
ls
get-childitem

cd demo
mkdir demo
mkdir copytest
copy copytest copytest2
cp copytest copytest2
copy-item copytest copytest2
del c*

cd\
cd demo

dir /s
dir -recurse

get-alias
get-alias dir
get-alias ls
get-alias cd
get-alias -Definition CD
get-alias -Definition get-childitem
get-alias -Definition copyitem
get-eventlog -LogName service -ComputerName . -verbose
get-eventlog -LogName application -ComputerName . -verbose

get-help commonparamaters

#======================================================================
#Tab completion,afkortingen en parameter aliasen
#======================================================================
get-se
get-service -co

get-service -comp localhost
get-process -name system
get-process -n system

get-service -cn localhost

#======================================================================
#Parameters
#======================================================================
get-service -computername localhost
get-service localhost
get-help get-service -full

#Postitionele : [-Class] <String>  (required = true)
#Postitionele : [[-Name    ] <String[]>]
#	       [[-Property] <String[]>]
#Named	     : [-ComputerName <String[]>]


#======================================================================
#Pipeline
#======================================================================
get-service
get-service -name wuauserv
get-service | Where-object {$_.name -like "wuauserv"}
get-service | Where-object {$_.name -like "Wuauserv"} | gm
get-service | Where {$_.name -like "w*"} | Sort status
get-service | Where {$_.name -like "w*"} | Sort status | out-file -FilePath c:\data\cursus\output.txt -append
get-service | Where {$_.name -like "w*"} | Sort status | export-csv -Path  c:\data\cursus\output.csv -Append -Delimiter ";" -NoTypeInformation
get-service | ?{$_.status -eq "stopped"} | start-service -whatif

 get-process | stop-service -whatif
 get-process | gm
 get-help get-service
 
 get-process -name FortiSSLVPNdaemon
 get-service -name FortiSslvpnDaemon


#endregion

######################################################################

#region  Demo 2

    #======================================================================
    #Het Help systeem
    #======================================================================
    update-help
    save-help -destinationPath c:\demo\updatehelp
    update-help -sourcepath C:\Demo\Help

    get-help get-eventlog
    #- verplicht positioneel : [-LogName] <String>
    #- optioneel positioneel : [[-InstanceId] <Int64[]>]
    #- named                 : [-After <DateTime>]
    #    	   		  [-ComputerName <String[]>]
    #- overig		: [<CommonParameters>]

    get-help common
    help about
    get-help get-command -online
    get-command
    get-command get
    get-help get
    get-help get-command
    help get-command
    man get-command
    - help = function
    cd function:
    dir h*
    type help
    c:
    get-alias man
    get-alias -definition Help

    get-help get
    get-help *job*
    get-help job
    get-help -verb new

    #======================================================================
    #out cmdlets
    #======================================================================
    get-command -verb out
    get-help -verb out-*

    #======================================================================
    #write-output versus Write-Host
    #======================================================================
    get-command -verb write
    write-output "Dit is een Test"
    write-host "Dit is een Test"
    get-help write-output
    get-help write-host
    write-output "Dit is een Test, write-output schrijft naar de Pipeline" -foreground yellow
    write-host "Dit is een Test, write-host schrijft direct naar de console window" -foreground yellow
    write-output "test" | gm
    write-output "test" | where-object {$_.length -gt 10}
    write-output "test" | where-object {$_.length -lt 10}

    write-host "hello" | gm
    write-host "hello" | where-object {$_.length -gt 10}

    #======================================================================
    #Providers
    #======================================================================
    Sheet: Providers:
      Get-PSProvider
      Get-Command -Noun item
  
    Sheet: Filesysteem PS Provider
      Get-PSDrive
      Get-ChildItem C:\demo
  
    Sheet: Navigeren en Wildcards
      Set-Location -Path C:\demo
      cd HKLM:software
      Get-ChildItem
      New-Item TestKey
      cd C:\Demo
      mkdir testfolder1
      New-Item testfolder2
      New-Item -type directory testfolder3
      Get-Item *.exe
      Help Get-Item -full
      New-Item HKCU:Software\*
      Set-Location HKCU:Software\*
      Set-Location C:\demo
      mkdir *

        cd c:\cursus
        get-pdrive
        mkdir "files"
        cd..
        cd windows
        dir
        cd..
        cd program files
        cd "program files"
        help dir
        dir -filter *.ps1 -recurse
        cd HKLM:          #(remoting regeistry via invoke-command)
        dir  
        cd software\mircrosoft
        dir -recurse | more
        dir -filter reg* -recurse
        get-item -path
        get-itemproperty "windows nt\currentversion"
        get-command -noun item *
        cd HKCU:
        mkdir "Sogeti"
        cd "Sogeti"
        new-itemproperty -path -name  cursus -value powershell
        get-itemproperty
        new-psdrive Sogeti -psprovider registry -root HKCU:\Sogeti

#endregion

######################################################################

#region Demo 3
    #======================================================================
    #Sheet Objecten
    #======================================================================
    cls
    get-process
    get-process | select *
    Get-Process | ConvertTo-HTML | Out-File processes.html
    .\processes.html


    #======================================================================
    #Sheet Hoe vinden we wat we met objecten kunnen?
    #======================================================================
    Get-Process | gm
    Get-Process -Name Notepad | Stop-Process
    Stop-Process –name Notepad

    #======================================================================
    #Sheet Sorteren en Selecteren
    #======================================================================
    Get-Process | Sort-Object VM –descending
    Get-Process | Select-Object -property Name,ID,VM,PM
    Get-Process | Sort VM -descending | Select Name,ID,VM |	gm

    #======================================================================
    #Sheet Filteren en vergelijken
    #======================================================================
    Get-Service –name e*,*s*
    Get-ADComputer -filter "Name -eq 'l080073'"
    Get-Service | Where {$_.name -like "e*"}
    5 -eq 5
    "hello" -eq "help"
    10 -ne 5
    "hello" -ne "hello"
    10 -ge 5
    (Get-Date) -le '2012-12-02'
    10 -lt 10
    100 -gt 10
    "help" -ceq "Help"
    "help" -cne "HELP"
    (5 -gt 10) -and (10 -gt 100) 
    (5 -gt 10) -or (10 -lt 100) 
    0 -eq -not 1
    (!(4 -gt 5))
    “hello” –like “*ll*”
    "DC=medewerkers,DC=AD,DC=HVU,DC=NL" -match '^dc=([a-z]|[0-9])*(,dc=([a-z]|[0-9])*)*$'

    #======================================================================
    #Sheet Filteren van objecten uit de pipeline
    #======================================================================
    Get-Service | Where-Object -filter { $_.Status -eq 'Running' }
    Get-Service | Where { $_.Status -eq 'Running' }
    gsv | where status -eq running
    Get-Service | gm

    $services = Get-Service 
    foreach ($_ in $services) {
        If($_.status -like "Running"){
            Write-host " $($_.name) is $($_.status)" -for Green
        } else {
            Write-host " $($_.name) is $($_.status)" -for red
        }#endIF
     }#end Foreach

    #======================================================================
    #Sheet Het iteratief model
    #======================================================================
    Get-Process
    Get-Process | Where-Object -filter { $_.Name -notlike 'powershell*' }
    Get-Process | Where-Object -filter { $_.Name -notlike 'powershell*' } | Sort VM -descending
    Get-Process | Where-Object -filter { $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10
    Get-Process | Where-Object -filter { $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10 | Measure-Object -property VM -sum
    (Get-Process | Where-Object -filter { $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10 | Measure-Object -property VM -sum).sum
    (Get-Process | Where-Object -filter { $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10 | Measure-Object -property VM -sum).sum /1mb
    [math]::round((Get-Process | Where-Object -filter { $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10 | Measure-Object -property VM -sum).sum /1mb)
    $uitkomst = [math]::round((Get-Process | Where-Object -filter { $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10 | Measure-Object -property VM -sum).sum /1mb)
    write-host $uitkomst "MB" -foreground Yellow

    #======================================================================
    # Sheet Variables
    #======================================================================
    Get-psdrive
    Dir variable:
    Get-command –noun variable
    Get-help new-variable -detail
    New-variable -name var –value 5
    Get-variable –name var
    Set-variable –name var –value 10
    Get-variable –name var
    $var = 5
    $var 
    $x = 1
    $x = $x + 1
    $x = "localhost"
    $x = $x + 1
    $x = $x  * 5
    $services = Get-Service
    $services[0]
    $services[1] 
    $services[-1] 
    $services = $services | Where-Object {$_.status -eq "running"} | select -first 10
    ${mijn variabele} = 5
    ${mijn variabele} 
    remove-variable -name Var

    $ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000 = "test de lange Naam"


    $string = "1,2,3,4"
    $result = $string -split","
    $result[0]
    $result[1]
    $result[-1]
    $string.split(',')
    $result -join "$"
    $result -join ","
    $Computername = "Localhost"
    Gwmi win32_operatingsystem $computerName
    $X++

    #Verschill tussen "" en ''
    $computernaam = 'SERVER-R2'
    "De computernaam is $computernaam"
    'De computernaam is $computernaam'

    #Escape Karakter (Back Tick)
    cd \
    cd \demo 
    cd '\program files'  
    cd \program` files 
    $value =  123
    $zin = "de variable $value bevat $value"
    $zin = "De Variable '$value bevat $value“


    $var = "hello"  
    $object | get-member
    $object.length
    $number = 5
    $number.length
    $number | get-member
    $folder = get-item c:\windows
    $folder | gm
    $file = get-item c:\windows\explorer.exe
    $file | gm

    $var = "Hello"
    $var.toupper()
    $var = 5
    $var.toupper()
    $var | GM
    [string]$var2 = "hello"    
    $var2.toupper()
    $var2 = 5
    $var2.toupper()
    $var2 | GM
#endregion

######################################################################

#Manier 1
Get-WmiObject -class Win32_LogicalDisk | select PScomputername,DeviceID,FreeSpace,Size | fl

#Manier 2
Get-WmiObject -class Win32_LogicalDisk -filter "drivetype=3 " |
    Sort-Object -property DeviceID |
        Select-Object -property `
            @{name='Hostname'     ;expression={$_.PScomputername}},
            @{name='DriveLetter'  ;expression={$_.DeviceID }},
        	@{name='FreeSpace(MB)';expression={$_.FreeSpace / 1MB -as [int]}},
            @{name='Size(GB)'     ;expression={$_.Size / 1GB -as [int]}},
            @{name='%Free'        ;expression={$_.FreeSpace / $_.Size * 100 -as [int]}} 

#Manier 3
Get-WmiObject -class Win32_LogicalDisk -filter "drivetype=3" |
    Sort-Object -property DeviceID | 
            Foreach{
                new-object -TypeName PSobject -Property @{
                    "Hostname"     = $_.PScomputername
                    "Driveletter"  = $_.DeviceID
                    "FreeSpace"    = "$($_.FreeSpace / 1gb -as [int]) GB)"
                    "Size"         = "$($_.Size / 1gb -as [int]) GB"
                    "Free"         = "$($_.FreeSpace / $_.Size * 100 -as [int]) %"           
                }
            } | Select Hostname,Driveletter,Size,FreeSpace,Free

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ``````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````#endRegion