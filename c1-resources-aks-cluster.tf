resource "azurerm_kubernetes_cluster" "assignment" {
  name                = "assignment-aks"
  location            = azurerm_resource_group.imp_rg.location
  resource_group_name = azurerm_resource_group.imp_rg.name
  dns_prefix          = "assignmentaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2s_v3"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}
