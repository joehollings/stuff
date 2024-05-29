$Cloud = Get-SCCloud -Name "MGMT"
Get-SCVirtualMachine -Cloud $Cloud | ft ComputerName, CPUCount, DynamicMemoryMaximumMB, MemoryAssignedMB, Location, TotalSize | Out-File -FilePath C:\MGMT.csv