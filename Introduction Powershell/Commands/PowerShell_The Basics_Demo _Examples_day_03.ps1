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
#    Part   : 3
#
#############################################################################################################

#======================================================================
# Variables
#======================================================================
#region
    # Show psdrive and check variable drive
      Get-psdrive
    # set location to variable drive
      Set-Location variable:
    # Show command for variables
      Get-command –noun variable
    # show help
      Get-help new-variable -detail


    # create new variable
      New-variable -name test –value 5
      $test = 5
    # read variable
      Get-variable –name test
      Get-variable –name test -ValueOnly
      (Get-variable –name test).Value
      $test
    # change Variable
      Set-variable –name test –value 10
      Get-variable –name test
      $test = 10
      $test
    # Remove variable
      Remove-Variable -name testvar2

    # Working with variables 
      $x = 1
      $x = $x + 1
      $x = "localhost"
      $x = $x + 1
      $x = 5
      $x = $x + "localhost"
      $x = $x  * 5
      $Services = Get-Service
      $Services[0]
      $Services[1] 
      $Services[-1] 
      $Services = $Services | Where-Object {$_.status -eq "running"} | select -first 10
    # Variable with space in the name
      ${mijn variabele} = 5
      ${mijn variabele} 
    # Long Variable name 
      $ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000 = "test de lange Naam"
      "ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000ditiseenhelelangevariablen000000000000000000"

#endregion

#======================================================================
# Variable operators
#======================================================================
#region 
  
  #Sheet Variabelen - Operators:
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


  "De waarde $computernaam = $computernaam"
  write-host "De computernaam is `n`t $computernaam"

 #Escape Karakter (Back Tick)
  cd \
  cd \demo 
  cd '\program files'  
  cd \program` files 
  $value =  123
  $zin = "de variable $value bevat $value"
  $zin = "De Variable '$value bevat $value“

#endregion

#======================================================================
# Members
#======================================================================
#region 
  
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

 #Verschillende Data Typen
  $Date = get-date
  $date = "03/31/1976"
  $date | Gm
  [datetime]$Date = get-date
  $date.day
  $date.Year
  $date.toshortdatestring()
  $date =$date.addmonths(2)
  $Date
  $String = "Hello"
  $string
  $string |GM
  [string]$String = "Hello"
  $string.length
  $string.tolower()
  $string.replace("l","o")
  $Number= 5
  $Number | gm 
  [int]$Number = 5
  $Number.compareto(2)
  $Number.compareto(5)
  $Number.compareto(10)
  $Number.equals(5)
  $Number.equals(10)
  $number.gettype()

#Sheet Objects in variable:
  $procs = get-process
  start calc
  Get-process
  $procs
  $procs[1]
  calc
  $procs = get-process
  $procs[2]
  $procs[2].kill()
  $cred = get-credential

#endregion

#======================================================================
# Object Collections
#======================================================================
#region 
  
  #Sheet Object Collections:
  Get-service  |where{$_.status –eq “running”}
  Get-service  |where{$_.status –eq “running”} | stop-service –whatif
  Dir . *.mp3 –recurse –force
  Dir . *.mp3 –recurse –force | Del
  Get-Content c:\computers.txt | For-each-object { GMWI win32_operatingsystem -computername $_ }
  Get-Content c:\computers.txt | For-each-object { GMWI win32_operatingsystem  -comp $_  |  For-each-object { $_.reboot() }  }

#endregion





