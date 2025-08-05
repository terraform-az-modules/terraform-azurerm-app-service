provider "azurerm" {
  features {}
  subscription_id = ""
}

locals {
  name          = "mmt"
  environment   = "dev"
  label_order   = ["name", "environment"]
  location      = "uksouth"
  taggedby      = "terraform"
  projectdomain = "Membership"
  costcenter    = "IT12345"
  owner         = "TBC"
}

module "resource_group" {
  source        = "../../../../resource-group"
  name_postfix  = "clarion-dev-001"
  environment   = local.environment
  location      = local.location
  taggedby      = local.taggedby
  projectdomain = local.projectdomain
  costcenter    = local.costcenter
  owner         = local.owner
}

module "vnet" {
  source                 = "../../../../vnet"
  name_postfix           = "clarion-dev-001"
  environment            = local.environment
  taggedby               = local.taggedby
  owner                  = local.owner
  resource_group_name    = module.resource_group.resource_group_name
  location               = module.resource_group.resource_group_location
  address_spaces         = ["10.0.0.0/16"]
  enable_ddos_pp         = false
  enable_network_watcher = false # To be set true when network security group flow logs are to be tracked and network watcher with specific name is to be deployed.
}

module "subnets" {
  source               = "../../../../subnet"
  environment          = local.environment
  taggedby             = local.taggedby
  owner                = local.owner
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name

  # Define all subnets in one place
  vnet_subnets = [
    {
      name               = "subnet-1"
      cidr               = "10.0.1.0/24"
      enable_route_table = true
      service_endpoints  = []
      delegations        = []
      custom_routes = [
        {
          name           = "InternetRoute"
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "Internet"
          next_hop_ip    = null
        }
      ]
    },
    {
      name               = "subnet-2"
      cidr               = "10.0.2.0/24"
      enable_route_table = false
      service_endpoints  = []
      delegations = [
        {
          name = "delegation"
          service_delegations = [
            {
              name    = "Microsoft.Web/serverFarms"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
          ]
        }
      ]
      custom_routes = []
    }
  ]
}

resource "azurerm_log_analytics_workspace" "log-analytics" {
  name                = "acctest-01"
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


module "app-service-plan" {
  source              = "../../../../app-service-plan"
  kind                = "Linux"
  linux_sku_name      = "B1"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  taggedby            = local.taggedby
  owner               = local.owner
  projectdomain       = local.projectdomain
  costcenter          = local.costcenter
  name_postfix        = "clarion-dev-001"
}



module "linux-web-app" {
  depends_on          = [module.vnet, module.subnets]
  source              = "../../.."
  enable              = true
  name_postfix        = "clarion-dev-002"
  environment         = local.environment
  label_order         = local.label_order
  taggedby            = local.taggedby
  projectdomain       = local.projectdomain
  costcenter          = local.costcenter
  owner               = local.owner
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  os_type             = "Linux"
  sku_name            = "B1"
  service_plan_id     = module.app-service-plan.service_plan_id

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

