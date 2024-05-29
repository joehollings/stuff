#!/bin/bash

set -e

VM_NAME="${VM_NAME:-$(hostname)}"
NIC_NAME="${VM_NAME}nic"

echo "Handling completed cycle for $VM_NAME (resource group $RESOURCE_GROUP)"

az login --identity > /dev/null 2>&1

CYCLE_TAG=$(az vm show \
    --resource-group "$RESOURCE_GROUP" \
    --name "$VM_NAME" \
    --query "tags.cycle" -o tsv)
echo "Cycle tag: $CYCLE_TAG"

case "$CYCLE_TAG" in
    running)
        echo "Keeping the VM running"
        ;;
    delete)
        echo "Deleting the VM"

        az resource update \
        --resource-group "$RESOURCE_GROUP" \
        --name "$VM_NAME" \
        --resource-type virtualMachines \
        --namespace Microsoft.Compute \
        --set properties.storageProfile.osDisk.deleteOption=delete
    
        az vm delete \
            --resource-group "$RESOURCE_GROUP" \
            --name "$VM_NAME" \
            --yes --no-wait
        ;;
    *)
        echo "Unknown or empty, deallocating VM"
        az vm deallocate \
            --resource-group "$RESOURCE_GROUP" \
            --name "$VM_NAME" \
            --no-wait
        ;;
esac