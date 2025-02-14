locals {
  archetype_config_overrides = {
    connectivity = {
      enforcement_mode = {
        Enable-DDoS-VNET = false # Will be enable per customer
      }
    }
    landing-zones = {
      enforcement_mode = {
        Audit-AppGW-WAF         = false
        Deny-IP-forwarding      = false
        Deny-MgmtPorts-Internet = false
        Deny-Priv-Esc-AKS       = false
        Deny-Privileged-AKS     = false
        Deny-Storage-http       = false
        Deny-Subnet-Without-Nsg = false # This needs to be set to false to deploy subnets
        Deploy-AKS-Policy       = false
        Deploy-AzSqlDb-Auditing = false
        Deploy-SQL-Threat       = false
        Deploy-VM-Backup        = false # This is disabled as our code manages the backup vaults
        Enable-DDoS-VNET        = false
        Enforce-AKS-HTTPS       = false
        Enforce-GR-KeyVault     = false
        Enforce-TLS-SSL         = false
      }
    }
    platform = {
      enforcement_mode = {
        DenyAction-DeleteUAMIAMA = false # This needs to be false to roll back, turn on for production deployment
      }
    }
    identity = {
      enforcement_mode = {
        Deny-Subnet-Without-Nsg = false # This needs to be set to false to deploy subnets
        Deploy-VM-Backup        = false # This is disabled as our code manages the backup vaults
      }
    }
  }
}
