resource "azurerm_container_registry" "example" {
  name                     = "imp2cr"
  resource_group_name      = azurerm_resource_group.imp_rg.name
  location                 = azurerm_resource_group.imp_rg.location
  sku                      = "Basic"
  admin_enabled            = true
#   georeplication_locations = ["East US", "West US"]
}

