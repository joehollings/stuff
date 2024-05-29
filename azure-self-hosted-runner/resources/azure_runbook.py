#!/usr/bin/env python3

import os
import automationassets
import random
import uuid
import requests
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.network import NetworkManagementClient
from azure.mgmt.resource import ResourceManagementClient
from azure.identity import DefaultAzureCredential

subscription_id = ""
location = ""
image_rsg_name = ""
image_name = ""
managed_identity_rsg_name = ""
managed_identity_name = ""
runner_prefix = "ghrunner" # change ghrunner to whatever you want, a random 2 digit number gets added to the end
runner_rsg_name = ""
# Get an existing subnet
vnet_rsg_name = "" # name of resource group that contains the vnet, not where to deploy the runner!
virtual_network_name = ""
subnet_name = ""
os_admin_user_name = ""
rsa_key = ""

credential = DefaultAzureCredential()
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

compute_client = ComputeManagementClient(
    credential,
    subscription_id
)
network_client = NetworkManagementClient(
    credential,
    subscription_id
)
resource_client = ResourceManagementClient(
    credential,
    subscription_id
)

image_id = f"/subscriptions/{subscription_id}/resourceGroups/{image_rsg_name}/providers/Microsoft.Compute/images/{image_name}" 
identity_id = f"/subscriptions/{subscription_id}/resourcegroups/{managed_identity_rsg_name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{managed_identity_name}"
subnet=network_client.subnets.get(vnet_rsg_name, virtual_network_name, subnet_name)
resource_name = f"{runner_prefix}{random.randint(10, 99)}" # this adds a random 2 diget number to the end of the string
ssh_key_path = f"/home/{os_admin_user_name}/.ssh/authorized_keys"

# Create NIC
nic_name = f"{resource_name}nic"
print("Creating NIC " + resource_name)
nic = network_client.network_interfaces.begin_create_or_update(
    runner_rsg_name,
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
print("Creating VM " + resource_name)
compute_client.virtual_machines.begin_create_or_update(
    runner_rsg_name,
    resource_name,
    {
        "location": location,
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
            "admin_username": os_admin_user_name,
            "linux_configuration": {
                "disable_password_authentication": True,
                "ssh": {
                    "public_keys": [
                        {
                            "path": ssh_key_path,
                            "key_data": rsa_key
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