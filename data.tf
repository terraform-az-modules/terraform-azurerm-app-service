##-----------------------------------------------------------------------------
## Data
##-----------------------------------------------------------------------------
data "azurerm_client_config" "main" {}

data "azurerm_private_endpoint_connection" "private-ip" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = azurerm_private_endpoint.pep[0].name
  resource_group_name = var.resource_group_name
}