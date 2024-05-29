# configure data drive and page file drive
Get-Disk | Where-Object OperationalStatus -EQ "offline" | Set-Disk -IsOffline $false
Get-Disk | Where-Object Size -LT "100000000000" | Initialize-Disk -PartitionStyle GPT -PassThru -Confirm:$false | New-Partition -DriveLetter P -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel "Page" -Confirm:$false
Get-Disk | Where-Object PartitionStyle -EQ RAW  | Initialize-Disk -PartitionStyle GPT -PassThru -Confirm:$false | New-Partition -DriveLetter S -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel "Data" -Confirm:$false
Set-Volume -DriveLetter C -NewFileSystemLabel "System"

# configure page file
Set-WmiInstance -Class Win32_PageFileSetting -Arguments @{name="P:\pagefile.sys"; InitialSize = 0; MaximumSize = 0} -EnableAllPrivileges | Out-Null
$pagefileset = Get-WmiObject win32_pagefilesetting | Where-Object{$_.caption -like 'P:*'}
$pagefileset.InitialSize = 51200
$pagefileset.MaximumSize = 51200
$pagefileset.Put()

# set system location to UK
Set-Culture en-GB
Set-WinSystemLocale -SystemLocale en-GB
Set-WinUILanguageOverride -Language en-GB
Set-WinUserLanguageList en-GB -Force
Set-WinHomeLocation -GeoId 0xF2

#Paste domainjoin.ps1 below: