function get-LogicalDiskInfo
{
    <#
    .SYNOPSIS
    Get-DiskInventory retrieves logical disk information from one or
    more computers.
    .DESCRIPTION
    Get-DiskInventory uses WMI to retrieve the Win32_LogicalDisk
    instances from one or more computers. It displays each disk's
    drive letter, free space, total size, and percentage of free
    space.
    .PARAMETER computername
    The computer name, or names, to query. Default: Localhost.
    .PARAMETER drivetype
    The drive type to query. See Win32_LogicalDisk documentation
    for values. 3 is a fixed disk, and is the default.
    .EXAMPLE
    Get-DiskInventory -computername SERVER-R2 -drivetype 3
    Description
    -----------
    This command gets the diskinventory of server02-R2 with drivetype 3
    .EXAMPLE
    Get-DiskInventory -computername SERVER-R2,Computer01 -drivetype 3
    Description
    -----------
    This command gets the diskinventory of
    .EXAMPLE
    Get-DiskInventory -computername (Get-content C:\computers.txt)
    Description
    -----------
    This command gets the diskinventory of
    .EXAMPLE
    Get-DiskInventory -host Localhost
    Description
    -----------
    This command gets the diskinventory of
    .EXAMPLE
    Get-DiskInventory -computername SERVER-R2 -drivetype 3 -verbose
    Description
    -----------
    This command gets the diskinventory 
    #>
    [CmdletBinding()]

    param
    (
        [Parameter(Mandatory=$True,HelpMessage="Enter a computer name to query",Position=0)]
        [Alias("hostname")]
        [string[]]$computername ,
        
        [ValidateSet("2", "3")]  
        [int]$drivetype = 3
    )

    Begin
    {
        Write-Verbose "Script started $((get-date).ToShortTimeString())"
    }#begin

    Process
    {
        $result = if($computername -eq $null)
                    {
                        write-host "Error 40 : $($error[0])" -ForegroundColor red
                    }
                    else
                    {
                    Get-WmiObject -class win32_logicaldisk -filter "drivetype=$drivetype" -computername $computername |
                            Sort-Object pscomputername | 
                            Select-Object -Property pscomputername,deviceid,
                            @{name='Freespace(GB)';expression={$_.Freespace /1GB -as [int]}},
                            @{name='size(GB)';expression={$_.size /1gb -as [int]}},
                            @{name='Free(%)';expression={$_.Freespace /$_.size * 100 -as [INT]}}
                    }#EndIF
    }#process

    End
    {
        Write-verbose "Script finished $((get-date).ToShortTimeString())"

        $result
    }#end

}# End function


get-LogicalDiskInfo -computername localhost -drivetype 3 -Verbose