#########################################################
# aanpassen object output
#########################################################
# gwmi is alias of get-wmiobject
  gwmi win32_logicaldisk
  gwmi win32_logicaldisk -filter "drivetype=3"
  gwmi win32_logicaldisk -filter "drivetype=3" | Ft deviceid,size,freespace
  gwmi win32_logicaldisk -filter "drivetype=3" | FT deviceID,@{label="size(mb)";expression={($_.size /1GB)}}, @{label="Freespace(mb)";expression={($_.Freespace /1mb)}}
  gwmi win32_logicaldisk -filter "drivetype=3" | FT `
        deviceID, `
        @{label="size(mb)";expression={($_.size /1GB -as[int])}},`
        @{label="Freespace(mb)";expression={($_.Freespace /1mb) -as[int]}}

#########################################################
# Create a New Object
#########################################################
  $WMI_OS   = get-wmiobject -class win32_operatingsystem
  $WMI_BIOS = get-wmiobject -class win32_bios 


# create a new object with the info from $WMI_OS and $wmi_Bios
  $Object = New-Object -TypeName psobject -Property @{
      SerialNumber_OS   = $WMI_OS.SerialNumber
      buildnumber       = $WMI_OS.BuildNumber
      OSArchitecture    = $WMI_OS.OSArchitecture
      SerialNumber_bios = $WMI_Bios.SerialNumber   
      biosversion       = $wmi_bios.BIOSVersion
  }

# show object 
  $Object | get-member
  $Object
