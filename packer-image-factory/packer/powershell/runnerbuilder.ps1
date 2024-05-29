# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process | Out-Null
$AzureContext = (Connect-AzAccount -Identity).context
# set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext
$Random = Get-Random -Maximum 99
$TokenSet = @{
    U = [Char[]]'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    L = [Char[]]'abcdefghijklmnopqrstuvwxyz'
    N = [Char[]]'0123456789'
    S = [Char[]]'!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~'
}
$Upper = Get-Random -Count 5 -InputObject $TokenSet.U
$Lower = Get-Random -Count 5 -InputObject $TokenSet.L
$Number = Get-Random -Count 5 -InputObject $TokenSet.N
$Special = Get-Random -Count 5 -InputObject $TokenSet.S
$StringSet = $Upper + $Lower + $Number + $Special
$Password = (Get-Random -Count 15 -InputObject $StringSet) -join ''
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ("owscs-admin", $SecurePassword)
$RSG = "owscs-rsg-runners"
$VMname = "azcsghrunner" + $Random
$NICname = $VMname + "-nic01"
$location = "uksouth"
$ImageID = "/subscriptions/50ca1b14-e3b0-4ecf-be34-96f334cd7a75/resourceGroups/packer-rsg-prod/providers/Microsoft.Compute/images/ghrunner"
$SSHkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzCFrCh2WxzL35j5B4pdRJQbvvGKYN4A0ZOIti7YLtyIOis3bEVO+o20oKKOV8O3NNNaBAgwvbkA4NG9BW5rFBoX6KEQjW27FvRMY+lcGYf0qyAW1PN9QOJkhUslcs+NwH39LVU5dQ91Y6GBHTNoIC7JT+v1orRmLHHANAjuFDJR/kRKPp0vcdej+rEYfgdeXOPhlNbsPH7/3JZhxJ2oRqpr+WtRYkgdp79Vb7MF9/l8+MKUYDQy1P2l03KS6ZLrwrPvc/NHj1LRHzEW+yRsx6938JNmYNsoXkPDrTy82Th44mmH+bttv+sZrvsSQPJZNTDqPL+9MMB/oGDmSdLwmr"
Write-Output $VMname
$Vnet = $(Get-AzVirtualNetwork -ResourceGroupName rg-owscs-hub -Name vnet-hub)
$NIC = New-AzNetworkInterface -Name $NICname -ResourceGroupName $RSG -Location $location -SubnetId $Vnet.Subnets[1].Id
$VirtualMachine = New-AzVMConfig -VMName $VMname -VMSize Standard_B2s
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Linux -ComputerName $VMname -Credential $Credential -DisablePasswordAuthentication -PatchMode "AutomaticByPlatform"
$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -Id $ImageID
$VirtualMachine = Add-AzVMSshPublicKey -VM $VirtualMachine -KeyData $SSHkey -Path "/home/owscs-admin/.ssh/authorized_keys"
New-AzVM -ResourceGroupName $RSG -Location $location -VM $VirtualMachine - -OSDiskDeleteOption Delete -NetworkInterfaceDeleteOption Delete