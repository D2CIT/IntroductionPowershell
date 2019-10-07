
#aanpassen object output
  gwmi win32_logicaldisk
  gwmi win32_logicaldisk -filter "drivetype=3"
  gwmi win32_logicaldisk -filter "drivetype=3" | Ft deviceid,size,freespace
  gwmi win32_logicaldisk -filter "drivetype=3" | FT deviceID,@{label="size(mb)";expression={($_.size /1GB)}}, @{label="Freespace(mb)";expression={($_.Freespace /1mb)}}
  gwmi win32_logicaldisk -filter "drivetype=3" | FT `
        deviceID, `
        @{label="size(mb)";expression={($_.size /1GB -as[int])}},`
        @{label="Freespace(mb)";expression={($_.Freespace /1mb) -as[int]}}


# Create a New Object
$WMI_OS   = get-wmiobject -class win32_operatingsystem
$wmi_Bios = get-wmiobject -class win32_bios 

$WMI_OS | select *
$WMI_bios | gm

$test = New-Object -TypeName psobject -Property @{
    SerialNumber_OS   = $WMI_OS.SerialNumber
    buildnumber       = $WMI_OS.BuildNumber
    OSArchitecture    = $WMI_OS.OSArchitecture
    SerialNumber_bios = $WMI_Bios.SerialNumber   
    biosversion       = $wmi_bios.BIOSVersion
}


$test | gm
