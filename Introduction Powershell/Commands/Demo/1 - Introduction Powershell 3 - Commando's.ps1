
######################################################################
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
#overige commando's
#======================================================================
ping
test-connection

net use * \\localhost\c$
net use 
Get-WmiObject Win32_NetworkConnection 
 - niet te zien in de explorer	(open explorer)
 - wel in een andere PS session (open ander Powershell session)

New-PSDrive -Name W -PSProvider FileSystem -Root \\localhost\c$
w:
 - alleen te zien in deze powershell session
 - niet te zien via net use
 - niet te zien in explorer
gcm -noun psdrive
get-psdrive
remove-psdrive -name w
get-psdrive | where {$_.provider -like "*filesystem"}

get-command
get-command -verb get
gcm -noun pssnapin
gcm -noun module

get-services
get-_service
w:


######################################################################
======================================================================
Het Help systeem
======================================================================
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

update-help
save-help -destinationPath c:\demo\updatehelp
update-help -sourcepath C:\Demo\Help

get-help get
get-help *job*
get-help job
get-help -verb new


======================================================================
Het Help systeem
======================================================================
get-help get-eventlog
- verplicht positioneel : [-LogName] <String>
- optioneel positioneel : [[-InstanceId] <Int64[]>]
- named                 : [-After <DateTime>]
    	   		  [-ComputerName <String[]>]
- overig		: [<CommonParameters>]

get-help common
help about
get-help get-command -online



#####################################################################
======================================================================
Understanding the pipeline
======================================================================
get-service
get-service |Where-object {$_.name -like "Wuauserv"} | gm
get-service |Where-object {$_.name -like "Wuauserv"} | fl *
get-service |Where-object {$_.name -like "Wuauserv"} | ft *
get-service |Where-object {$_.status -eq "running"}
get-service |Where-object {$_.status -eq "running"} | stop-service -whatif
get-service |Where-object {$_.name -like "Wuauserv"}
======================================================================
pipeline Out-default
======================================================================
get-process
get-process | out-default
help *service*
get-service | ?{$_.status -eq "stopped"} | set-service -startuptype disabled -whatif
get-service | ?{$_.status -eq "stopped"} | start-service -whatif

======================================================================
out cmdlets
======================================================================
get-command -verb out
get-help -verb out-*

======================================================================
write-output versus Write-Host
======================================================================
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


#####################################################################
======================================================================
Providers
======================================================================
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