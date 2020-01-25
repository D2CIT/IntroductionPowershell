#POwershell Cursus

function check-md5 {
    <#
    .Synopsis
       check-md5
    .DESCRIPTION
       check-md5 
    .EXAMPLE
       check-md5 -filepath c:\powershell\lab01\file.txt
    #>

    [CmdletBinding()]

    param(
        $filepath = "c:\powershell\lab01\file.txt"
    )

    begin {
        
        
        if(!(test-path $filepath)){write-warning "the file $filepath not found" ; break}
        $Hashfile = $filepath + ".hash"
        if(!(test-path $Hashfile)){write-warning "the hashfile $hashfile not found. Could not check the hash." ; break}
        
        $CheckedHash = get-content $Hashfile 
        $Currenthash = (get-filehash $filepath).hash 

    }

    process {
      if ($CheckedHash -like ($currenthash)){
        Write-verbose "Checked succesfull the File Hash. "
        return $true
      }else{
        write-warning "Filehash is changed. Script is changed"
      }#EndIF
    }

    end{
    
    }

}
function new-md5   {
    <#
    .Synopsis
       new-md5
    .DESCRIPTION
       new-md5 
    .EXAMPLE
        new-md5 -filepath c:\powershell\lab01\file.txt
    #>

    [CmdletBinding()]

    param(
        $filepath = "c:\powershell\lab01\file.txt"
    )

    begin {
        
        
        if(!(test-path $filepath)){write-warning "the file $filepath not found" ; break}
        $Hashfile = $filepath + ".hash"   

    }

    process {
          
        $CheckedHash = (get-filehash $filepath).hash    
        $CheckedHash | out-file $Hashfile
        $currenthash = get-content $hashfile

        if ($CheckedHash -like ($currenthash)){
            Write-verbose "Hashfile is created "
            return $true
        }else{
            write-warning "Error creating Hashfile"
            return $false
        }#EndIF
    }

    end{
    
    }
}


# LAB 1
 
  open powershell
  click met de rechtermuis op de tile balk boven en kies voor properties
  ga naar layout en zet bij screen buffersize de 


# Finding commands  FileHASH
  Zoek het commando om de hash van een file te lezen
  get-command get-*hash*
  get-help get-*hash*

# check of een file is changed?
#  - creeer de tekstfile c:\powershell\Lab01\file.txt
  mkdir c:\powershell\lab01
  "Dit is een test" | out-file  c:\powershell\Lab01\file.txt
 
# lees de hash van de file en sla deze op in de variable fileHash
  $Filehash = (get-filehash c:\powershell\Lab01\file.txt).hash
# schrijf de hash weg in het besstand c:\powershell\lab01\file.txt.hash
  $Filehash | out-file c:\powershell\lab01\file.txt.hash

# Check of de file hash van het bestand c:\powershell\Lab01\file.txt gelijk is aan de hash in c:\powershell\lab01\file.txt.hash
  $LastHash    = get-content c:\powershell\lab01\file.txt.hash
  $currenthash = (get-filehash c:\powershell\Lab01\file.txt).hash 


  if ($LastHash -like ($currenthash.hash)){
    Write-host "Checked File Hash" -for Green
  }else{
    write-warning "Filehash is changed. Script is changed"
  }


  # Change File
  "Dit is een append" | out-file  c:\powershell\Lab01\file.txt -append

  #Check Again
  $LastHash    = get-content c:\powershell\lab01\file.txt.hash
  $currenthash = (get-filehash c:\powershell\Lab01\file.txt).hash 


 if ($LastHash -like ($currenthash.hash)){
    Write-host "Checked File Hash" -for Green
  }else{
    write-warning "Filehash is changed. Script is changed"
  }
 ##########################################################
 # With function
 ##########################################################
  $Filepath = "c:\powershell\Lab01\file.txt"
  # Create new md5 hash file
  new-md5 -filepath $Filepath -verbose
  #Check Hash
  check-md5 -filepath $Filepath -verbose
  
  # Change File
  "Dit is een append" | out-file $Filepath -append
  #Check again (should Fail
  check-md5 -filepath $Filepath -verbose
  #Save new hash
  new-md5 -filepath $Filepath -verbose
  #Check hash
  check-md5 -filepath $Filepath -verbose


# Whatif / Confirm
  get-service -name wuauserv | stop-service -whatif
  get-service -name wuauserv | stop-service -confirm

# Close powershell
  exit

