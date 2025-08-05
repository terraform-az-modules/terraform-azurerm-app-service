provider "azurerm" {
  features {}
  subscription_id = ""
}

module "resource_group" {
  source      = "terraform-az-modules/resource-group/azure"
  version     = "1.0.0"
  name        = "core"
  environment = "qa"
  label_order = ["environment", "name", "location"]
  location    = "canadacentral"
}

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

module "subnet" {
  source      = "terraform-az-modules/subnet/azure"
  version     = "1.0.0"
  environment = "qa"
  # label_order          = ["environment", "name", "location"]
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name

  subnets = [
    {
      name            = "subnet1"
      subnet_prefixes = ["10.0.1.0/24"]

      # Example of service endpoints, if used
      # service_endpoints = ["Microsoft.Storage"]
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
              name    = "Microsoft.Network/virtualNetworks/subnets/action"
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

module "subnet-ep" {
  source      = "terraform-az-modules/subnet/azure"
  version     = "1.0.0"
  environment = "qa"
  # label_order          = ["environment", "name", "location"]
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


module "log-analytics" {
  source                           = "clouddrove/log-analytics/azure"
  version                          = "2.0.0"
  name                             = "core"
  environment                      = "qa"
  label_order                      = ["name", "environment", "location"]
  create_log_analytics_workspace   = true
  log_analytics_workspace_sku      = "PerGB2018"
  log_analytics_workspace_id       = module.log-analytics.workspace_id
  resource_group_name              = module.resource_group.resource_group_name
  log_analytics_workspace_location = module.resource_group.resource_group_location
}

module "private-dns-zone" {
  source              = "git::https://github.com/terraform-az-modules/terraform-azure-private-dns.git?ref=feat/beta"
  resource_group_name = module.resource_group.resource_group_name
  private_dns_config = [
    {
      resource_type = "azure_web_apps"
      vnet_ids      = [module.vnet.vnet_id]
    },
  ]
}


module "linux-web-app" {
  depends_on          = [module.vnet, module.subnets]
  source              = "../.."
  enable              = true
  environment         = "qa"
  label_order         = ["name", "environment", "location"]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  os_type             = "Linux"
  sku_name            = "B1"
  service_plan_id     = module.app-service-plan.service_plan_id
  # windows_app_stack = 
  # linux_app_stack = 

  ##----------------------------------------------------------------------------- 
  ## To Deploy Container
  ##-----------------------------------------------------------------------------
  use_docker               = false
  docker_image_name        = "nginx:latest"
  docker_registry_url      = "<registryname>.azurecr.io"
  docker_registry_username = "<registryname>"
  docker_registry_password = "<docker_registry_password>"
  acr_id                   = "<acr_id>"

  ##----------------------------------------------------------------------------- 
  ## Node application
  ##-----------------------------------------------------------------------------
  use_node     = false
  node_version = "20-lts"

  ##----------------------------------------------------------------------------- 
  ## Dot net application
  ##-----------------------------------------------------------------------------
  use_dotnet     = true
  dotnet_version = "8.0"

  ##----------------------------------------------------------------------------- 
  ## Java application
  ##-----------------------------------------------------------------------------
  use_java            = false
  java_version        = "17"
  java_server         = "JAVA"
  java_server_version = "17"

  ##----------------------------------------------------------------------------- 
  ## python application
  ##-----------------------------------------------------------------------------

  use_python     = false
  python_version = "3.12"

  ##----------------------------------------------------------------------------- 
  ## php application
  ##-----------------------------------------------------------------------------

  use_php     = false
  php_version = "8.2"

  ##----------------------------------------------------------------------------- 
  ## Ruby application
  ##-----------------------------------------------------------------------------

  use_ruby     = false
  ruby_version = "2.7"

  ##----------------------------------------------------------------------------- 
  ## Go application
  ##-----------------------------------------------------------------------------

  use_go     = false
  go_version = "1.19"

  # Enable from specific ip addresses and virtual networks
  public_network_access_enabled = true
  authorized_ips                = ["10.0.2.10/24"]
  authorized_subnet_ids         = [module.subnets.vnet_subnets["subnet-2"]]
  authorized_service_tags       = ["AppService"]

  site_config = {
    container_registry_use_managed_identity = true
  }

  # To enable app insights 
  app_settings = {
    application_insights_connection_string     = "${module.linux-web-app.connection_string}"
    application_insights_key                   = "${module.linux-web-app.instrumentation_key}"
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
  }

  ##----------------------------------------------------------------------------- 
  ## App service logs 
  ##----------------------------------------------------------------------------- 
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
  ##----------------------------------------------------------------------------- 
  ## log analytics
  ##-----------------------------------------------------------------------------
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log-analytics.workspace_id

  ##----------------------------------------------------------------------------- 
  ## Vnet integration and private endpoint
  ##-----------------------------------------------------------------------------
  virtual_network_id                     = module.vnet.vnet_id
  private_endpoint_subnet_id             = module.subnets.vnet_subnets["subnet-1"] # Normal subnet for private endpoint
  enable_private_endpoint                = true
  app_service_vnet_integration_subnet_id = module.subnets.vnet_subnets["subnet-2"] # Delegated subnet id for App Service VNet integration

}

