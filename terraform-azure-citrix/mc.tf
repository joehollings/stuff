resource "citrix_machine_catalog" "example-azure-mtsession" {
  name                     = "example-azure-mtsession"
  description              = "Example multi-session catalog on Azure hypervisor"
  zone                     = "<zone Id>"
  allocation_type          = "Random"
  session_support          = "MultiSession"
  is_power_managed         = true
  is_remote_pc             = false
  provisioning_type        = "MCS"
  minimum_functional_level = "L7_20"
  provisioning_scheme = {
    hypervisor               = citrix_azure_hypervisor.example-azure-hypervisor.id
    hypervisor_resource_pool = citrix_azure_hypervisor_resource_pool.example-azure-hypervisor-resource-pool.id
    identity_type            = "ActiveDirectory"
    machine_domain_identity = {
      domain                   = "<DomainFQDN>"
      domain_ou                = "<DomainOU>"
      service_account          = "<Admin Username>"
      service_account_password = "<Admin Password>"
    }
    azure_machine_config = {
      storage_type      = "Standard_LRS"
      use_managed_disks = true
      service_offering  = "Standard_D2_v2"
      azure_machine_config = {
        resource_group  = "<Azure resource group name for image vhd>"
        storage_account = "<Azure storage account name for image vhd>"
        container       = "<Azure storage container for image vhd>"
        master_image    = "<Image vhd blob name>"
      }
      writeback_cache = {
        wbc_disk_storage_type          = "pd-standard"
        persist_wbc                    = true
        persist_os_disk                = true
        persist_vm                     = true
        writeback_cache_disk_size_gb   = 127
        writeback_cache_memory_size_mb = 256
        storage_cost_saving            = true
      }
    }
    network_mapping = {
      network_device = "0"
      network        = "<Azure Subnet for machine>"
    }
    availability_zones       = "1,2,..."
    number_of_total_machines = 1
    machine_account_creation_rules = {
      naming_scheme      = "az-multi-##"
      naming_scheme_type = "Numeric"
    }
  }
}

