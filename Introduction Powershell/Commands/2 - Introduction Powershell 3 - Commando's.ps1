######################################################################



#======================================================================
# Sheet Objecten
#======================================================================
cd\
cls
get-process
get-process | select * | Out-GridView
Get-Process | ConvertTo-HTML | Out-File processes.html
.\processes.html


#======================================================================
# Sheet Waarom Gebruikt Powershell objecten?
#======================================================================
Get-Process

#======================================================================
##Sheet Hoe vinden we wat we met objecten kunnen?
#======================================================================
Get-Process | gm
Get-Process -Name Notepad | Stop-Process
Stop-Process –name Notepad

#======================================================================
# Sheet Sorteren en Selecteren
#======================================================================
Get-Process | Sort-Object VM –descending
Get-Process | Select-Object -property Name,ID,VM,PM
Get-Process | Sort VM -descending | Select Name,ID,VM |	gm

#======================================================================
# Sheet Filteren en vergelijken
#======================================================================
  Get-Service –name e*,*s*
  Get-ADComputer -filter "Name -eq 'l080073'"
  Get-Service | Where {$_.name -like "e*"

#======================================================================
# Sheet Vergelijkingen
#======================================================================
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
# Sheet Filteren van objecten uit de pipeline
#======================================================================
Get-Service | get-member
Get-Service | gm

Get-Service | Where-Object -filter { $_.Status -eq 'Running' }
Get-Service | Where { $_.Status -eq 'Running' }
Gsv | ? { $_.Status -eq 'Running' }


Get-content .\computers.txt | 
    Foreach{
		    Get-Service -ComputerName $_| Where { $_.Status -eq 'Running'}
    }#Foreach

Foreach($_ in (Get-content .\computers.txt)){
    Get-Service -ComputerName $_ | Where { $_.Status -eq 'Running'}
}#Foreach

#======================================================================
# Sheet Het iteratief model
#======================================================================
Get-Process
Get-Process | Where-Object -filter { $_.Name -notlike 'powershell*' }
Get-Process | Where{ $_.Name -notlike 'powershell*' } | Sort VM -descending
Get-Process | Where{ $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10
Get-Process | Where{ $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10 | Measure-Object -property VM -sum
(Get-Process | Where{ $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10 | Measure-Object -property VM -sum).sum
(Get-Process | Where{ $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10 | Measure-Object -property VM -sum).sum /1mb
[math]::round((Get-Process | Where{ $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10 | Measure-Object -property VM -sum).sum /1mb)
$uitkomst = [math]::round((Get-Process | Where { $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10 | Measure-Object -property VM -sum).sum /1mb)
write-host $uitkomst "MB" -foreground Yellow

#verkort
$uitkomst = [math]::round((ps | ? { $_.Name -notlike 'powershell*' } | Sort VM -des | Select -f 10 | Measure -p VM -sum).sum /1mb)
write-host "Ze hebben samen" $uitkomst "MB in gebruik" -foreground Yellow


#======================================================================
# Sheet Hoe stuurt ps data door de pipeline?
#======================================================================
  dir | select name
  notepad computers.txt
  Get-Content computers.txt
  Get-Content computers.txt | Get-Service
  Get-Content computers.txt | Get-Member
  help get-service -Full
  Get-Content computers.txt | foreach-object {get-service -computer $_})
  (get-service).name | out-file c:\demo\service.txt
  notepad services.txt
  Get-Content services.txt | Get-Service
  
  calc
  get-process -name calc*
  get-process -name calc* | Stop-Process
  help stop-process -Full
  get-process -name s* | stop-process –whatif

#======================================================================
# Sheet Hoe worden objecten tekst?
#======================================================================
  Get-Service
  Get-Service | Out-Host

#======================================================================
# Sheet Default Output
#======================================================================
  notepad C:\windows\system32\WindowsPowerShell\v1.0\DotNetTypes.format.ps1xml
  get-service | get-member

#======================================================================
# Sheet Formatting Subsystem
#======================================================================
  get-command -verb format
  help format-wide
  get-service | fw
  get-service | FW displayname
  get-service | FW name -auto
  get-service | FW -col 4
  help format-list
  get-service | Format-list status,displayname,name
  get-service | Format-list *
  get-service | Fl name,displayname,status -groupby status   (niet wat je verwacht Header)
  get-service | sort status | Fl name,displayname,status -groupby status
  help format-table
  get-service |FT
  get-service |FT name,status
  get-service |FT name,status -auto  (zie excel)
  get-process | ft *
  get-process | ft * -auto
  get-process | ft * -auto -wrap
  gsv | sort status | ft displayname -groupby status
  ps | ft name,id,vm,pm
  ps | ft name,id,vm,pm -auto
  ps | sort vm | ft name,id,vm,pm -auto | out-file c:\test.txt
  ps | gm
  gwmi win32_logicaldisk
  gwmi win32_logicaldisk -filter "drivetype=3"
  gwmi win32_logicaldisk -filter "drivetype=3" | Ft deviceid,size,freespace
  gwmi win32_logicaldisk -filter "drivetype=3" | FT deviceID,@{label="size(mb)";expression={($_.size /1GB)}}, @{label="Freespace(mb)";expression={($_.Freespace /1mb)}}
  gwmi win32_logicaldisk -filter "drivetype=3" | FT deviceID,@{label="size(mb)";expression={($_.size /1GB -as[int])}}, @{label="Freespace(mb)";expression={($_.Freespace /1mb) -as[int]}}

    