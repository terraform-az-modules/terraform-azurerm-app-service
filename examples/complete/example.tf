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
  label_order                      = ["name", "environment"]
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
  source              = "../.." # Adjust path if needed
  depends_on          = [module.vnet, module.subnet]
  enable              = true
  environment         = "qa"
  label_order         = ["name", "environment", "location"]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  os_type             = "Linux"
  sku_name            = "B1"
  # service_plan_id   = module.app-service-plan.service_plan_id (if using existing plan)

  # Pass new stack object (set only what you want to use)
  linux_app_stack = {
    type                = "dotnet" # change to "node", "java", etc, as needed
    dotnet_version      = "8.0"
    node_version        = null
    java_version        = null
    java_server         = null
    java_server_version = null
    php_version         = null
    python_version      = null
    ruby_version        = null
    go_version          = null
    docker = {
      enabled           = false
      image             = null
      registry_url      = null
      registry_username = null
      registry_password = null
    }
  }

  # VNet and Private Endpoint Integration
  virtual_network_id                     = module.vnet.vnet_id
  private_endpoint_subnet_id             = module.subnet.subnet_ids["sub3"] # Use private endpoint subnet as per new setup
  enable_private_endpoint                = true
  app_service_vnet_integration_subnet_id = module.subnet.subnet_ids["subnet2"] # Delegated subnet for App Service integration

  public_network_access_enabled = true
  authorized_ips                = ["10.0.2.10/24"]
  authorized_subnet_ids         = [module.subnet.subnet_ids["subnet2"]] # Use correct subnet reference
  authorized_service_tags       = ["AppService"]

  # Log Analytics (if you use your own workspace resource directly, update accordingly)
  log_analytics_workspace_id = module.log-analytics.workspace_id

  # Site config
  site_config = {
    container_registry_use_managed_identity = true
  }

  # Application Insights/AppSettings
  app_settings = {
    application_insights_connection_string     = module.linux-web-app.connection_string   # Reference module output
    application_insights_key                   = module.linux-web-app.instrumentation_key # Reference module output
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
  }

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

