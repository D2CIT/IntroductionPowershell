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
#    Part   : 4
#
#############################################################################################################

#======================================================================
# WMI / CIM
#======================================================================
#region
    #WMIC
      wmic.exe partition get name,bootable,size,type

    #WMI & Powershell
      help Get-WmiObject -full
      Get-WmiObject -namespace "root/default" -list
      Get-WmiObject -list 
      GWMI -list
      Get-WmiObject -list | where {$_.name -like "win32_Disk*"}
      Get-WmiObject -list | where {$_.name -like "win32_log*"}
      Get-WmiObject -list | where {$_.name -like "win32_*"}

      Get-WmiObject win32_operatingsystem | select *
      Get-WmiObject win32_operatingsystem | fl *
  
    #vergelijkings operators WMI (Let op : Geen * maar %)
      Get-WmiObject win32_service
      Get-WmiObject win32_service -filter "B* "
      Get-WmiObject win32_service -filter "name like 'b%'"
      Get-WmiObject win32_service -filter "name='bits'"
      Get-WmiObject win32_service -filter "name='bits'" 
      Get-WmiObject win32_service -filter "name='Bits'" 
      Get-WmiObject win32_operatingsystem -filter "buildnumber>6000"
      Get-WmiObject win32_operatingsystem
      Get-WmiObject win32_operatingsystem | fl *
      Get-WmiObject win32_diskdrive | fl *
  
    #Weinig verschil lokaal versus remote
      Get-WmiObject win32_operatingsystem
      Get-WmiObject win32_operatingsystem -computername labdc01
      Get-WmiObject win32_operatingsystem -computername (Get-Content c:\demo\computers.txt)
  
    #Alternate credentials NOT Local
      Get-WmiObject win32_diskdrive -Credential "lab\admin"
      Get-WmiObject win32_diskdrive -computername labdc01 -Credential "lab\admin"

    #CIM!!
      Get-Command -noun CIM*
      Get-Cimclass -classname *disk*
      Get-WmiObject -class win32_operatingsystem
      Get-CimInstance -ClassName Win32_ComputerSystem

      $s = New-CimSession –ComputerName localhost,labdc01
      Get-CimInstance -ClassName Win32_ComputerSystem -CimSession $s
    # List all classes in a namespace
      Get-CimClass -Namespace root\CIMv2
      Get-WmiObject -Namespace root\CIMv2 -List

      (Get-CimClass -Namespace root\CIMv2).count
      (Get-WmiObject -Namespace root\CIMv2 -List).count

    # list all classes containing “service” in their name
      Get-CimClass -Namespace root\CIMv2 | Where CimClassName -like ‘*service*’ | Sort CimClassName

     (or)

      Get-CimClass -Namespace root\CIMv2 -Classname *service*
      Get-WmiObject -Namespace root\CIMv2 -List | Where Name -like ‘*service*’ | Sort Name

    # get all class instances
      Get-CimInstance -Namespace root\CIMv2 -ClassName Win32_OperatingSystem | select *
      Get-WmiObject -Namespace root\CIMv2 -Class Win32_OperatingSystem

    # filter class instances
      Get-CimInstance -Namespace root\CIMv2 -ClassName Win32_LogicalDisk -Filter “DriveType=3”
      Get-WmiObject -Namespace root\CIMv2 -Class Win32_LogicalDisk -Filter “DriveType=3”

    # show all properties
      Get-CimInstance -Namespace root\CIMv2 -ClassName Win32_OperatingSystem | Get-Member
      Get-WmiObject -Namespace root\CIMv2 -Class Win32_OperatingSystem | Get-Member

    # show all properties and values
      Get-CimInstance -Namespace root\CIMv2 -ClassName Win32_OperatingSystem | fl *
      Get-WmiObject -Namespace root\CIMv2 -Class Win32_OperatingSystem | fl *

    # remote computer
      Get-CimInstance -Namespace root\CIMv2 -ClassName Win32_BIOS -ComputerName Localhost
      Get-WmiObject -Namespace root\CIMv2 -Class Win32_BIOS -ComputerName localhost

    # use CIM command to talk to non-CIM computer
      Get-CimInstance -Namespace root\CIMv2 -ClassName win32_BIOS -CimSession (
        New-CimSession -ComputerName OLD-xp-pc -SessionOption (
            New-CimSessionOption -Protocol Dcom
        )
      )
#endregion

#======================================================================
# VRAGEN WMI
#======================================================================
#region 
 # get-wmiobject --> alias is gwmi
 get-wmiobject -list *network*
  get-wmiobject win32_Networkadapterconfiguration | where {$_.ipaddress -ne $Null}
   get-wmiobject win32_Networkadapterconfiguration | where {$_.ipaddress -ne $Null} | gm
    $ipconf = get-wmiobject win32_Networkadapterconfiguration | where {$_.ipaddress -ne $Null}
    $ipconf.ReleaseDHCPLease()
    $ipconf.RenewDHCPLease()

 get-wmiobject -list *Quick*fix*
 gwmi -class Win32_QuickFixEngineering 
 get-hotfix

 (gwmi -class Win32_QuickFixEngineering).count
 (get-hotfix).count

 Get-WmiObject win32_operatingsystem | gm
 Get-WmiObject win32_operatingsystem | select csname,serialnumber,buildnumber,caption | FT
 Get-WmiObject win32_operatingsystem | select @{Name='ComputerName';e={$_.CSname}},
                                              @{Name='BiosSerial';e={(gwmi win32_bios).serialnumber}},
                                              @{Name='OSbuild';e={$_.Buildnumber}},
                                              @{Name='OS Description';e={$_.caption}}

$OS     = gwmi win32_operatingsystem
$Bios   = gwmi win32_bios
$object = New-Object -TypeName Psobject -Property @{
    ComputerName  = $OS.CSname
    BiosSerial    = $bios.serialnumber
    OSbuild       = $os.Buildnumber
    OSDescription = $os.caption
 }  


#endregion

#======================================================================
# Remoting
#======================================================================
#region 
  
  # Sheet Geavanceerd remote control: 
    Get-Command –noun Pssession
  # connect to remote server
    Enable-PSRemoting
    Enter-PSSession labdc01
    Exit-pssession
  # Remote sessions
    get-pssession
    $session = New-PSSession -computername labdc01 -name labdc01
    Enter-PSSession $session
    exit-pssession
    get-pssession

  invoke-command -ScriptBlock {
    get-service -name ALG | Stop-Service
  } -ComputerName  



#connect to domain controller and import Module
    $RemoteServer  = "labdc01"
    $Module        = "ActiveDirectory"
    $remoteSession = new-pssession -computer $RemoteServer
    Invoke-Command -session $remoteSession -script { Import-Module ActiveDirectory }
    Import-PSSession -session $remoteSession -module $module -prefix d2cit

#one to One Remoting
  Enter-PSSession $session
  gsv
   ps
    start calc
     get-process | where {$_.name -like "calc*"}
     get-process | where {$_.name -like "calc*"} | gm
     get-process | where {$_.name -like "calc*"} | fl *
     get-process | where {$_.name -like "calc*"} | Stop-Process
     get-process | where {$_.name -like "calc*"
  exit-pssession
  get-pssession | remove-pssession

#one to many Remoting
  $session = New-PSSession -computername labdc01 -name "servers Domaincomputers"
  invoke-command {get-eventlog security -newest 10} -session $session
  invoke-command {get-eventlog security -newest 10} -session $session | gm
  invoke-command {get-eventlog security -newest 10} -session $session | group-object pscomputer
  invoke-command {get-eventlog security -newest 10} -session $session | sort pscomputername | format-table -groupby pscomputername
  invoke-command -filepath "c:\demo\invokescript.ps1" -computername labdc01
  invoke-command -filepath "c:\demo\invokescript.ps1" -session $session
  invoke-command {get-service} -session $session |sort pscomputername | FT -groupby pscomputername
  get-pssession | remove

#endregion

#======================================================================
# BackGroundJobs
#======================================================================
#region 

    #Sheet BackgroundJobs:
      Invoke-Command {get-eventlog security –newest 1000} –computer localhost, labdc01
      Invoke-Command {get-eventlog security –newest 1000} –computer localhost -asjob -jobname eventlogs
      Get-Job

    #Sheet Get-Command -noun job:
      dir
      Start-Job -scriptblock {dir}
      start-job -scriptblock {get-eventlog security -computer labdc01}
      receive-job x

    #Sheet Master en Child Jobs (WMI):
      $job = Get-WmiObject -comp localhost, labdc01 win32_bios -asjob 
      Get-Job $job.Name
      get-job $job.Name | select-object -expand childjobs
      (Get-Job $job.Name).ChildJobs
      Get-Job *
      Receive-job $job.Name
      Receive-job $job.Name -keep
      $job2 = Get-WmiObject -comp localhost, labdc01 win32_bios -asjob
      Get-Job $job2.Name
      Receive-job $job2.Name -keep
      $bios = Receive-job $job2.Name
      invoke-command -command { get-process } -computername localhost, labdc01 -asjob -jobname process
      Get-Job -jobname process
      Wait-Job -jobname process
      Receive-Job -keep 15
      Stop-Job 15
      Remove-Job 15
      Remove-Job -jobname process
      get-job | where { -not $_.HasMoreData } | remove-job
      get-job

    #Sheet Scheduled Jobs:
      Register-ScheduledJob -Name DailyProcList `
                            -ScriptBlock { Get-Process } `
                            -Trigger (New-JobTrigger -Daily -At 2am) `
                            -ScheduledJobOption (New-ScheduledJobOption -WakeToRun -RunElevated)
      Get-ScheduledJob

#endregion





