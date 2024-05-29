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

def get_automation_runas_credential(runas_connection):
    from OpenSSL import crypto
    import binascii
    from msrestazure import azure_active_directory
    import adal

    # Get the Azure Automation RunAs service principal certificate
    cert = automationassets.get_automation_certificate("AzureRunAsCertificate")
    pks12_cert = crypto.load_pkcs12(cert)
    pem_pkey = crypto.dump_privatekey(crypto.FILETYPE_PEM,pks12_cert.get_privatekey())

    # Get run as connection information for the Azure Automation service principal
    application_id = runas_connection["ApplicationId"]
    thumbprint = runas_connection["CertificateThumbprint"]
    tenant_id = runas_connection["TenantId"]

    # Authenticate with service principal certificate
    resource ="https://management.core.windows.net/"
    authority_url = ("https://login.microsoftonline.com/"+tenant_id)
    context = adal.AuthenticationContext(authority_url)
    return azure_active_directory.AdalAuthentication(
    lambda: context.acquire_token_with_client_certificate(
            resource,
            application_id,
            pem_pkey,
            thumbprint)
    )

# Authenticate to Azure using the Azure Automation RunAs service principal
runas_connection = automationassets.get_automation_connection("AzureRunAsConnection")
credential = get_automation_runas_credential(runas_connection)
image_id = "/subscriptions/50ca1b14-e3b0-4ecf-be34-96f334cd7a75/resourceGroups/owscs-rsg-runners/providers/Microsoft.Compute/images/ghrunner"
subscription_id = runas_connection["SubscriptionId"]
location = "uksouth"
resource_name = f"azcsghrunner{random.randint(10, 99)}"
identity_id = "/subscriptions/50ca1b14-e3b0-4ecf-be34-96f334cd7a75/resourcegroups/owscs-rsg-prod/providers/Microsoft.ManagedIdentity/userAssignedIdentities/githubrunner"


auth_client = AuthorizationManagementClient(
    credential,
    subscription_id=subscription_id                                                                                                                                    
)
compute_client = ComputeManagementClient(
    credential,
    subscription_id=subscription_id
)
network_client = NetworkManagementClient(
    credential,
    subscription_id=subscription_id
)
resource_client = ResourceManagementClient(
    credential,
    subscription_id=subscription_id
)

# Get subnet
network_client = NetworkManagementClient(credential, subscription_id)
resource_group_name = "rg-owscs-hub"
location = "uk south"
virtual_network_name = "vnet-hub"
subnet_name = "snet-sharedresources"
subnet=network_client.subnets.get(resource_group_name, virtual_network_name, subnet_name)
resource_group_name = "owscs-rsg-runners"

# Create NIC
nic_name = f"{resource_name}nic"
print("Creating NIC")
nic = network_client.network_interfaces.create_or_update(
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
print("Creating VM")
compute_client.virtual_machines.create_or_update(
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