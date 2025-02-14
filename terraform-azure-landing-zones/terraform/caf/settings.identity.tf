# Configure the identity resources settings.
locals {
  configure_identity_resources = {
    settings = {
      identity = {
        enabled = true
        config = {
          enable_deny_public_ip             = false
          enable_deny_rdp_from_internet     = false
          enable_deny_subnet_without_nsg    = false
          enable_deploy_azure_backup_on_vms = false
        }
      }
    }
  }
}