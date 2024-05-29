RG="owscs-rsg-prod"
IDENTITY="githubrunner"
Image="SUSE:sles-15-sp3-byos:gen2:latest"
License="SLES_BYOS"
Size="Standard_B2s"
Subnet_id="/subscriptions/50ca1b14-e3b0-4ecf-be34-96f334cd7a75/resourceGroups/rg-owscs-hub/providers/Microsoft.Network/virtualNetworks/vnet-hub/subnets/snet-sharedresources"

VM_NAME="azcstestvm01"; az vm create \
    --resource-group $RG \
    --name $VM_NAME \
    --image $Image \
    --license-type $License \
    --size $Size \
    --subnet $Subnet_id \
    --public-ip-address "" \
    --admin-username "owscs-admin" \
    --ssh-key-values "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzCFrCh2WxzL35j5B4pdRJQbvvGKYN4A0ZOIti7YLtyIOis3bEVO+o20oKKOV8O3NNNaBAgwvbkA4NG9BW5rFBoX6KEQjW27FvRMY+lcGYf0qyAW1PN9QOJkhUslcs+NwH39LVU5dQ91Y6GBHTNoIC7JT+v1orRmLHHANAjuFDJR/kRKPp0vcdej+rEYfgdeXOPhlNbsPH7/3JZhxJ2oRqpr+WtRYkgdp79Vb7MF9/l8+MKUYDQy1P2l03KS6ZLrwrPvc/NHj1LRHzEW+yRsx6938JNmYNsoXkPDrTy82Th44mmH+bttv+sZrvsSQPJZNTDqPL+9MMB/oGDmSdLwmr" \
    --assign-identity $(az identity show \
        --resource-group $RG \
        --name $IDENTITY --query id -o tsv)
    
    #--tags cycle=running
    #--image "Canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest" \
    #--image "/subscriptions/50ca1b14-e3b0-4ecf-be34-96f334cd7a75/resourceGroups/packer-rsg-prod/providers/Microsoft.Compute/images/ghrunner" \
    