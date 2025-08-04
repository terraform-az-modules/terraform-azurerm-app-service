##-----------------------------------------------------------------------------
## Data
##-----------------------------------------------------------------------------
data "azurerm_client_config" "main" {}

data "azurerm_application_insights" "app_insights" {
  count = var.application_insights_enabled && var.application_insights_id != null ? 1 : 0

  name                = split("/", var.application_insights_id)[8]
  resource_group_name = split("/", var.application_insights_id)[4]
}

data "azurerm_private_endpoint_connection" "private-ip" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = azurerm_private_endpoint.pep[0].name
  resource_group_name = var.resource_group_name
}