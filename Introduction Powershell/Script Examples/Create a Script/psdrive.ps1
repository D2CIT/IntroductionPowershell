<#
.SYNOPSIS
    
.DESCRIPTION
    
.PARAMETER Drivename
    
.PARAMETER Rootpath
    
.EXAMPLE
    . .\psdrive.ps1 -Drivename M -rootpath "\\localhost\c$"
#>
    [CmdletBinding()]
param
(
    [Parameter(Mandatory=$false,HelpMessage="Enter a drive letter [d-y]")]
    $DriveLetter = "M" ,

    [Parameter(Mandatory=$false,HelpMessage="Path to root, \\localhost\c$ ")]
    $RootPath  = "\\localhost\c$"
)

begin
{

}

process
{

    New-PSDrive -Name $Drivename -PSProvider FileSystem -Root $rootpath -Persist

}

end
{

}
