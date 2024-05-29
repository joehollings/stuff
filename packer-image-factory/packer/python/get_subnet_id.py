from azure.identity import AzureCliCredential
from azure.mgmt.network import NetworkManagementClient
credential = AzureCliCredential()
subscription_id = "948d4068-xxxx-xxxx-xxxx-e00a844e059b"
network_client = NetworkManagementClient(credential, subscription_id)
resource_group_name = "rg-owscs-hub"
location = "uk south"
virtual_network_name = "vnet-hub"
subnet_name = "snet-sharedresources"
Subnet=network_client.subnets.get(resource_group_name, virtual_network_name, subnet_name)
print(Subnet.id)