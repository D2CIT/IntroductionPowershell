Function get-continue           {
    <#
     .Synopsis
        get-continue 
     .DESCRIPTION
        get-continue 
     .EXAMPLE 
        get-continue -message  "Would you like to continue (yes /no)" 
     .EXAMPLE 
        get-continue -destroy
    #>

    [cmdletbinding()]

    param( 
        [Parameter(Mandatory=$false)]
        $message = "Would you like to continue (yes /no)" ,
        [switch]$destroy
    )

    Begin 
    {
        if($Destroy)
        {
            Write-host "###############################################" -for Red -BackgroundColor black
            Write-host " LET OP : Je gaat een destroy uitvoeren!!"        -for Red -BackgroundColor black
            Write-host "###############################################" -for Red -BackgroundColor black
        }  #End If  

      $ReadHost = read-host -Prompt $message
    }

    Process
    {
        Switch ($ReadHost) 
        { 
           Destroy 
           {
                Write-verbose "Destroy, Continue"; 
                $Continue = $true
           } 
           Yes 
           {
                if($Destroy)
                {
                    Write-warning "Yes is not the correct imput. You have selected destroy.`n`t`t Typ destroy to continue or no to abort."
                }
                else
                {
                    Write-verbose "Yes, Continue"; $Continue = $true
                }
           } 
           No 
           {
                Write-verbose "No, stop"; 
                $continue = $false
           } 
           Default 
           {
                Write-verbose "Default, stop"; $Continue=$false
           } 
        }#end Switch
    }

    End 
    {
        return $continue
    }
} #EndFunction


get-continue 
