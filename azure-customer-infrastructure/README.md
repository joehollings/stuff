
# Deploy Customer Infrastructure

This workflow deploys all the following resources needed for an Azure PaaS tenant:

* Resource Group
* Customer vNet and required subnets and vnet peering to the hub vNet
* Proximity Placement Groups for Dev, QAS and Prod BPC environments
* AD joined Storage Account for customer file shares and Hana backups
* Recovery Services Vault with daily and weekly backup polices
* 2 Domain Controller and Citrix Cloud Connector Virtual Machines

## Technology Used

* GitHub as code repository and pipeline runner 
* Terraform as Infrastructure as Code to provision Azure resources
* Packer to create golden images

## Steps

1. Create a new branch called feat/<customer_name> and copy template.yml and template folder in terraform and rename to customer name
2. Run afs.ps1 on an admin in the OWSCS domain to create machine account for Azure storage account
3. Update azuredeploy.tf with the full customer number
4. Complete all the xx placeholders in locals.tf
5. Push the completed code to the repo and create a pull request, make sure terrafrom plan is green and is deploying what's expected
6. Once all checks are green merge to main to run packer and terraform apply
7. Once the storage account is deployed create the kerberos password for the machine account in AD
8. Run primarydc.ps1 on DC01 to configure it to be a domain controller and create new customer tree domain
9. Run adconfig.ps1 to configure the new domain
10. Uncomment the dc_cc module and push the completed code to the repo and create a pull request, make sure terrafrom plan is green and is deploying what's expected
11. Once all checks are green merge to main to run terraform apply
12. Run secondarydc.ps1 on DC02 to configure it to be a domain controller in the new customer domain
13. Install the Citrix Cloud Connector software on the two cc01 and cc02. 

## Usage

### Workflow

Replace template in paths: to the name of the customer folder in terraform folder.

```yml
name: Deploy Template
on:
  pull_request:
    paths: 
        - 'terraform/template/**'
  pull_request_target:
    types:
      - closed
    paths: 
        - 'terraform/template/**'


jobs:
  terraform:
    name: Terraform
    uses: ./.github/workflows/terraform.yml
    with:
      TF_DIRECTORY: "./terraform/template"
    secrets: inherit
```

Uncomment the packer code blocks if you wish to update any of the images for the deployment. This is optional.

```yml
  packer_dc_cc:
      name: Build DC CC OS Image
      uses: ./.github/workflows/packer.yml
      with:
        LOCATION: "uk south"
        TEMPLATE: "svr2022"
        IMAGE_NAME: "svr2022"
        RESOURCE_GROUP: "packer-rsg-prod"
      secrets: inherit
```

### afs.ps1

Run the code below on an admin system to create the machine account needed to AD join the storage account, and retrieve the SID needed for the storage account. Just fill in the customer number variable and copy the returned object SID.

```powershell
$CustomerNumber = "10xxx"
$StorageAccountName = $CustomerNumber + "afs01"
$ResourceGroupName = $CustomerNumber + "-rsg-prod"
$OUpath = "OU=AFS,OU=Azure,OU=Servers,OU=OWSCS,DC=OWSCS,DC=local"
$SPN = "cifs/$StorageAccountName.file.core.windows.net"
$Description = "Computer account object for Azure storage account $StorageAccountName."
New-ADComputer -Name $StorageAccountName -SAMAccountName $StorageAccountName -Description $Description -ServicePrincipalNames $SPN -Path $OUpath
$ObjectSID=(Get-ADComputer $StorageAccountName).SID.Value
$ObjectSID
```

After resources are deployed run this next section to create the kerberos storage account key used as the password for the machine accound in AD. 
Reset the password of the machine account in AD to the value retrieved. This completes the domain join process.

```powershell
# connect to azure
Connect-AzAccount

# create kerberos storage account key and retrieve storage account key
New-AzStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -KeyName kerb1
$AccountKey = Get-AzStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -ListKerbKey | where-object{$_.Keyname -contains "kerb1"}
$AccountKey = $AccountKey.Value
$Identity = "$StorageAccountName" + "$"
# set storage account key as password on service account
Set-ADAccountPassword -Identity $Identity -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $AccountKey -Force)
```

### azuredeploy.tf

Complete azuredeploy.tf using the full customer in the tfstate file name. 

```hcl
# Change key to customer number ie 10111.tfstate
terraform {
  backend "azurerm" {
    resource_group_name  = "owscs-rsg-hub"
    storage_account_name = "owscsafs02"
    container_name       = "tfstates"
    key                  = "10xxx.tfstate"
  }
}
```

### locals.tf

Complete the following locals.tf replacing the placeholder xx with required values.

```hcl
locals {
  customer_number               = "xxx"
  customer_name                 = "Customer_Name"
  customer_domain_name          = "${local.customer_name}.local"
  location                      = "UK South"
  key_vault_name                = "kv-owscs-hub"
  key_vault_resource_group_name = "rg-owscs-hub"
  forest_root_domain            = "owscs.local"
  admin_username                = "owscs-admin"
  admin_password_secret_name    = "OWSCS-Admin"
  ad_admin_username_secret_name = "x"
  ad_admin_password_secret_name = "x"
  hub_vnet_name                 = "vnet-hub"
  hub_subnet_name               = "snet-identityservices"
  hana_dev_sid                  = "xx1"
  hana_qas_sid                  = "xx2"
  hana_prod_sid                 = "xx3"

  virtual_networks = {
    prod = {
      address_space               = ["10.11.xx.0/22"]
      network_security_group_name = "nsg-vnet-app-prod"
      subnets = {
        snet-presentation-prod = {
          address_prefixes = ["10.11.xx.0/24"]
        }
        snet-dev-test-prod = {
          address_prefixes = ["10.11.xx.0/24"]
        }
        snet-sap-prod = {
          address_prefixes = ["10.11.xx.0/24"]
        }
        snet-db-prod = {
          address_prefixes = ["10.11.xx.0/24"]
        }
      }
    }
  }

  proximity_placement_groups = {
    dev = {
      name = "10${local.customer_number}-ppg-sap-dev"
    }
    qas = {
      name = "10${local.customer_number}-ppg-sap-qas"
    }
    prod = {
      name = "10${local.customer_number}-ppg-sap-prod"
    }
  }

  storage_accounts = {
    prod = {
      name        = "10${local.customer_number}afs01"
      storage_sid = "S-1-5-21-2079600466-3062766412-2793361815-xxxx"
      shares = {
        shared = {
          quota = "xxx"
        }
        backup = {
          quota = "xxx"
        }
      }
    }
  }
}
```

