$ScriptName = "Howden.ps1"
$ScriptPath = "\\NCLMGTNAS01\Scripts\BoxStarter Scripts"
$PackageName = "Howden"

New-PackageFromScript "$ScriptPath\$ScriptName" $PackageName

Invoke-BoxStarterBuild $PackageName