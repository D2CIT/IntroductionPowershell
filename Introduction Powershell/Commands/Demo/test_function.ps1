
function get-dictu {

    <#
    .Synopsis
       get-dictu
    .DESCRIPTION 
       nobody get's ... get-dictu
    .EXAMPLE
       get-dictu -Param1
 
    #>

    [CmdletBinding()]
      
    Param (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]$Param1,

        # Param2 help description
        [int]$timer ,

        [switch]$force
    )

    Begin{
        Write-verbose "Script is gestart"
    }
    Process{
        if($force -eq $true){
            Write-warning "The force!!!!!"
        }
        $x =  1
        write-host " please wait ($Param1): " -NoNewline
    
        do
        {
            write-host " " -BackgroundColor yellow -NoNewline
            sleep 1
            $X++    
        }
        until ($x -gt $timer)
        write-host "" -for yellow
    }
    End{
        Write-verbose "Script is klaar"
    }
}


