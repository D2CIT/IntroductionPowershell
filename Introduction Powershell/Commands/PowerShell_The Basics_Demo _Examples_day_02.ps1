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
#    Part   : Day Two
#
#############################################################################################################

#======================================================================
# Objecten
#======================================================================
#region

    get-process
    get-process | select * | Out-GridView
    Get-Process | ConvertTo-HTML | Out-File processes.html
    .\processes.html

  # Sheet Hoe vinden we wat we met objecten kunnen?
    Get-Process | gm
    Get-Process -Name Notepad | Stop-Process
    Stop-Process –name Notepad
#endregion

#======================================================================
# Werken met Objecten
#======================================================================
#region 
  # Sheet Sorteren en Selecteren  
    Get-Process | Sort-Object VM –descending
    Get-Process | Select-Object -property Name,ID,VM,PM
    Get-Process | Sort VM -descending | Select Name,ID,VM |	gm

  # Sheet Filteren en vergelijken
    Get-Service –name e*,*s*
    Get-ADComputer -filter "Name -eq 'l080073'"
    Get-Service | Where { $_.name -like "e*" }

  # Sheet Vergelijkingen
    5 -eq 5
    "hello" -eq "help"
    10 -ne 5
    "hello" -ne "hello"
    10 -ge 5
    (Get-Date).ToShortDateString() -le "23/10/2019"
    get-date -Format yyyymmdd-HH:MM:ss
    10 -lt 10
    100 -gt 10
    "help" -ceq "Help"
    "help" -cne "HELP"
    (10 -gt 5) -and (100 -gt 10) 
    (5 -gt 10) -or (10 -lt 100) 
    0 -eq -not 1
    (!(4 -gt 5))
    “hello” –like “*ll*”
    "DC=medewerkers,DC=AD,DC=HVU,DC=NL" -match '^dc=([a-z]|[0-9])*(,dc=([a-z]|[0-9])*)*$'


  # Sheet Filteren van objecten uit de pipeline
    Get-Service | get-member
    Get-Service | gm

    Get-Service | Where-Object -filter { $_.Status -eq 'Running' }
    Get-Service | Where { $_.Status -eq 'Running' }
    Gsv | ? { $_.Status -eq 'Running' }

    $file = "C:\Powershell\computers.txt"
    Get-content $file  | 
        Foreach{
		        Get-Service -ComputerName $_ | Where { $_.Status -eq 'Running'} | select name,status,pscomputername
        }#Foreach

    $x = Foreach($computername in (Get-content $file )){
        Get-Service -ComputerName $computername | Where { $_.Status -eq 'Running'} | Out-GridView
    }#Foreach 
    $x | Out-GridView



#endregion


#======================================================================
# Het iteratief model
#======================================================================
#region
 # opdracht laat de 10 meest virtuel gebeugende processen zien
    Get-Process
    Get-Process | Where-Object -filter { $_.Name -notlike 'powershell*' }
    Get-Process | Where{ $_.Name -notlike 'powershell*' } | Sort VM -descending
    Get-Process | Where{ $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10
    Get-Process | Where{ $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10 | Measure-Object -property VM -sum
    (Get-Process | Where{ $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10 | Measure-Object -property VM -sum).sum
    (Get-Process | Where{ $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10 | Measure-Object -property VM -sum).sum /1mb
    [math]::round((Get-Process | Where{ $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10 | Measure-Object -property VM -sum).sum /1mb)
    $uitkomst = [math]::round((Get-Process | Where { $_.Name -notlike 'powershell*' } | Sort VM -descending | Select -first 10 | Measure-Object -property VM -sum).sum /1gb)
    write-host $uitkomst "GB" -foreground Yellow

    #verkort
    $uitkomst = [math]::round((ps | ? { $_.Name -notlike 'powershell*' } | Sort VM -des | Select -f 10 | Measure -p VM -sum).sum /1mb)
    write-host "Ze hebben samen" $uitkomst "MB in gebruik" -foreground Yellow

#endregion


#======================================================================
# Hoe stuurt ps data door de pipeline?
#======================================================================
#region
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
#endregion


#======================================================================
# Formatting Subsystem
#======================================================================
#region

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

    
#endregion