# Configure the management resources settings.
locals {
  configure_management_resources = {
    settings = {
      ama = {
        enable_uami                                                         = true # true
        enable_vminsights_dcr                                               = true # true
        enable_change_tracking_dcr                                          = true # true
        enable_mdfc_defender_for_sql_dcr                                    = false
        enable_mdfc_defender_for_sql_query_collection_for_security_research = false
      }
      log_analytics = {
        enabled = true # true
        config = {
          retention_in_days          = var.log_retention_in_days
          enable_monitoring_for_vm   = false
          enable_monitoring_for_vmss = false
          enable_sentinel            = false
          enable_change_tracking     = false
        }
      }
      security_center = {
        enabled = true # true
        config = {
          email_security_contact                                = var.security_alerts_email_address
          enable_defender_for_apis                              = false
          enable_defender_for_app_services                      = false
          enable_defender_for_arm                               = false
          enable_defender_for_containers                        = false
          enable_defender_for_cosmosdbs                         = false
          enable_defender_for_cspm                              = false
          enable_defender_for_dns                               = false
          enable_defender_for_key_vault                         = false
          enable_defender_for_oss_databases                     = false
          enable_defender_for_servers                           = false
          enable_defender_for_servers_vulnerability_assessments = false
          enable_defender_for_sql_servers                       = false
          enable_defender_for_sql_server_vms                    = false
          enable_defender_for_storage                           = false
        }
      }
    }

    location = var.management_resources_location
    tags     = var.management_resources_tags
    advanced = null
  }
}