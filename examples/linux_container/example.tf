##-----------------------------------------------------------------------------
## Provider
##-----------------------------------------------------------------------------
provider "azurerm" {
  features {}
}

##-----------------------------------------------------------------------------
## Resource Group
##-----------------------------------------------------------------------------
module "resource_group" {
  source      = "terraform-az-modules/resource-group/azure"
  version     = "1.0.0"
  name        = "core"
  environment = "qa"
  label_order = ["environment", "name", "location"]
  location    = "canadacentral"
}

##-----------------------------------------------------------------------------
## Virtual Network
##-----------------------------------------------------------------------------
module "vnet" {
  source              = "terraform-az-modules/vnet/azure"
  version             = "1.0.0"
  name                = "core"
  environment         = "qa"
  label_order         = ["name", "environment", "location"]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_spaces      = ["10.0.0.0/16"]
}

##-----------------------------------------------------------------------------
## Subnets
##-----------------------------------------------------------------------------
module "subnet" {
  source               = "terraform-az-modules/subnet/azure"
  version              = "1.0.0"
  environment          = "qa"
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name
  subnets = [
    {
      name            = "subnet1"
      subnet_prefixes = ["10.0.1.0/24"]
    },
    {
      name            = "subnet2"
      subnet_prefixes = ["10.0.2.0/24"]

      # Delegation
      delegations = [
        {
          name = "Microsoft.Web/serverFarms"
          service_delegations = [
            {
              name    = "Microsoft.Web/serverFarms"
              actions = []
              # Note: In some versions, 'actions' might not be required or is implicit
            }
          ]
        }
      ]
    }
  ]
  enable_route_table = true
  route_tables = [
    {
      name = "pub"
      routes = [
        {
          name           = "rt-test"
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "Internet"
        }
      ]
    }
  ]
}

##-----------------------------------------------------------------------------
## Subnet for Private Endpoint
##-----------------------------------------------------------------------------
module "subnet-ep" {
  source               = "terraform-az-modules/subnet/azure"
  version              = "1.0.0"
  environment          = "qa"
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name

  subnets = [
    {
      name            = "sub3"
      subnet_prefixes = ["10.0.3.0/24"]
    }
  ]
  enable_route_table = false
}

##-----------------------------------------------------------------------------
## Log Analytics
##-----------------------------------------------------------------------------
module "log-analytics" {
  source                           = "clouddrove/log-analytics/azure"
  version                          = "2.0.0"
  name                             = "core"
  environment                      = "qa"
  label_order                      = ["name", "environment"]
  create_log_analytics_workspace   = true
  log_analytics_workspace_sku      = "PerGB2018"
  log_analytics_workspace_id       = module.log-analytics.workspace_id
  resource_group_name              = module.resource_group.resource_group_name
  log_analytics_workspace_location = module.resource_group.resource_group_location
}

##-----------------------------------------------------------------------------
## Private DNS Zone
##-----------------------------------------------------------------------------
module "private-dns-zone" {
  source              = "terraform-az-modules/private-dns/azure"
  version             = "1.0.0"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  label_order         = ["name", "environment", "location"]
  name                = "core"
  environment         = "qa"
  private_dns_config = [
    {
      resource_type = "azure_web_apps"
      vnet_ids      = [module.vnet.vnet_id]
    },
  ]
}

##-----------------------------------------------------------------------------
## Application Insights
##-----------------------------------------------------------------------------
module "application-insights" {
  source                     = "git::https://github.com/terraform-az-modules/terraform-azure-application-insights.git?ref=feat/update"
  name                       = "core"
  environment                = "dev"
  label_order                = ["name", "environment", "location"]
  resource_group_name        = module.resource_group.resource_group_name
  location                   = module.resource_group.resource_group_location
  workspace_id               = module.log-analytics.workspace_id
  log_analytics_workspace_id = module.log-analytics.workspace_id
  web_test_enable            = false
}

##-----------------------------------------------------------------------------
## Linux Web App with Container
##-----------------------------------------------------------------------------
module "linux-web-app" {
  source              = "../.."
  depends_on          = [module.vnet, module.subnet]
  enable              = true
  name                = "core"
  environment         = "qa"
  label_order         = ["name", "environment", "location"]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  os_type             = "Linux"
  linux_sku_name      = "B1"
  linux_app_stack = {
    docker = {
      enabled           = true
      image             = "nginx:latest"
      registry_url      = "testcr10.azurecr.io" # null for public hub; set like "myregistry.azurecr.io" for ACR
      registry_username = "testcr10"
      registry_password = ""
    }
  }
  acr_id = "<acr_id>" # Set your ACR resource ID here
  # VNet and Private Endpoint Integration
  private_endpoint_subnet_id             = module.subnet-ep.subnet_ids["sub3"] # Use private endpoint subnet here
  enable_private_endpoint                = true
  app_service_vnet_integration_subnet_id = module.subnet.subnet_ids["subnet2"]                         # Delegated subnet for App Service integration
  private_dns_zone_ids                   = module.private-dns-zone.private_dns_zone_ids.azure_web_apps # Reference the private DNS zone IDs for web apps
  public_network_access_enabled          = false
  ip_restriction_default_action          = "Allow"
  # Site config
  site_config = {
    container_registry_use_managed_identity = true # Set to true if using managed identity for ACR access
    #Checkov suggested 
    minimum_tls_version      = "1.2"
    remote_debugging_enabled = true
    http2_enabled            = true
    ftps_state               = "FtpsOnly"
  }
  # Application Insights/AppSettings
  app_settings = {
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
  }
  app_insights_id                  = module.application-insights.app_insights_id
  app_insights_instrumentation_key = module.application-insights.instrumentation_key
  app_insights_connection_string   = module.application-insights.connection_string
  # App Service logs
  app_service_logs = {
    detailed_error_messages = false
    failed_request_tracing  = false
    application_logs = {
      file_system_level = "Information"
    }
    http_logs = {
      file_system = {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }
}


