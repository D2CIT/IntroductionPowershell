Function get-PowerShellService {

    Param (
        #Parameter 1
        [Parameter(Mandatory=$true,Position=0)]
        [string]$Servicename ,
         #Parameter 3
        [Parameter(Mandatory=$true,Position=1)]
        [ValidateSet("stopped", "running")]
        [string]$Status,
        #Parameter 3
        [Parameter(Mandatory=$false)]        
        [string[]]$computername = "localhost"
    )

    Begin{
       Write-host "Collecting Info " -ForegroundColor yellow
    }

    Process {
        Foreach($computer in $computername){
            Try{
                test-connection $computer -Count 1 -ErrorAction Stop | out-null
                get-service -computername $computer | 
                    where {$_.name -like "$Servicename" -and $_.status -like "$status"} | 
                        sort-object machinename | 
                            select-object  machinename,servicename,displayname,status
            }Catch{
                Write-host " [Error] : $computer is niet bereikbaar." -for Red
            }#endIf
        }#end Forech
    }#end process


} #end function

get-PowerShellService -Servicename * -Status running -computername localhost
