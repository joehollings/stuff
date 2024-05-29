#!/usr/bin/env python3

import os
import azure.mgmt.resource
import automationassets
import random
import uuid
from azure.mgmt.authorization import AuthorizationManagementClient
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.network import NetworkManagementClient
from azure.mgmt.resource import ResourceManagementClient
from azure.identity import DefaultAzureCredential

SUBSCRIPTION_ID="50ca1b14-e3b0-4ecf-be34-96f334cd7a75"

credential = DefaultAzureCredential()

import os
import requests
# printing environment variables
endpoint = os.getenv('IDENTITY_ENDPOINT')+"?resource=https://management.azure.com/"
identityHeader = os.getenv('IDENTITY_HEADER')
payload={}
headers = {
'X-IDENTITY-HEADER' : identityHeader,
'Metadata' : True
}
response = requests.get(endpoint, headers)
print(response.text)

auth_client = AuthorizationManagementClient(
    credential,
    SUBSCRIPTION_ID                                                                                                                                  
)
compute_client = ComputeManagementClient(
    credential,
    SUBSCRIPTION_ID
)
network_client = NetworkManagementClient(
    credential,
    SUBSCRIPTION_ID
)
resource_client = ResourceManagementClient(
    credential,
    SUBSCRIPTION_ID
)

image_id = "/subscriptions/50ca1b14-e3b0-4ecf-be34-96f334cd7a75/resourceGroups/owscs-rsg-runners/providers/Microsoft.Compute/images/ghrunner"
location = "uksouth"
resource_name = f"azcsghrunner{random.randint(10, 99)}"
identity_id = "/subscriptions/50ca1b14-e3b0-4ecf-be34-96f334cd7a75/resourcegroups/owscs-rsg-prod/providers/Microsoft.ManagedIdentity/userAssignedIdentities/githubrunner"

# Get subnet
resource_group_name = "rg-owscs-hub"
location = "uk south"
virtual_network_name = "vnet-hub"
subnet_name = "snet-sharedresources"
subnet=network_client.subnets.get(resource_group_name, virtual_network_name, subnet_name)
resource_group_name = "owscs-rsg-runners"

# Create NIC
nic_name = f"{resource_name}nic"
print("Creating NIC " + resource_name)
nic = network_client.network_interfaces.begin_create_or_update(
    resource_group_name,
    nic_name,
    {
        "location": location,
        "ip_configurations": [
            {
                "name": f"{resource_name}ipconfig",
                "subnet": {
                    "id": subnet.id
                }
            }
        ]
    }
).result()

# Create VM
resource_group_name = "owscs-rsg-runners"
print("Creating VM " + resource_name)
compute_client.virtual_machines.begin_create_or_update(
    resource_group_name,
    resource_name,
    {
        "location": "uksouth",
        "storage_profile": {
            "image_reference": {
                "id": image_id,      
            },
            "deleteOption": "Delete"
        },
        "hardware_profile": {
            "vm_size": "Standard_B2s"
        },
        "os_profile": {
            "computer_name": resource_name,
            "admin_username": "owscs-admin",
            "linux_configuration": {
                "disable_password_authentication": True,
                "ssh": {
                    "public_keys": [
                        {
                            "path": "/home/owscs-admin/.ssh/authorized_keys",
                            "key_data": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzCFrCh2WxzL35j5B4pdRJQbvvGKYN4A0ZOIti7YLtyIOis3bEVO+o20oKKOV8O3NNNaBAgwvbkA4NG9BW5rFBoX6KEQjW27FvRMY+lcGYf0qyAW1PN9QOJkhUslcs+NwH39LVU5dQ91Y6GBHTNoIC7JT+v1orRmLHHANAjuFDJR/kRKPp0vcdej+rEYfgdeXOPhlNbsPH7/3JZhxJ2oRqpr+WtRYkgdp79Vb7MF9/l8+MKUYDQy1P2l03KS6ZLrwrPvc/NHj1LRHzEW+yRsx6938JNmYNsoXkPDrTy82Th44mmH+bttv+sZrvsSQPJZNTDqPL+9MMB/oGDmSdLwmr"
                        }
                    ]
                }
            }
        },
        "network_profile": {
            "network_interfaces": [
                {
                    "id": nic.id,
                    "deleteOption": "Delete"
                    
                }
            ]
        },
        "identity": {
            "type": "UserAssigned",
            "user_assigned_identities": {
                identity_id: {}
            }
        },
        "tags": {
            "cycle": "delete"
        }
    }
)