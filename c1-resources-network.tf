resource "azurerm_virtual_network" "virtual_network_1" {
  depends_on          = [azurerm_resource_group.imp_rg]
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.imp_rg.name
  address_space       = var.address_space
  location            = azurerm_resource_group.imp_rg.location

  tags = {
    "created_by"  = "jayanth"
    "environment" = "development"
  }
}

resource "azurerm_subnet" "subnet-01" {
  # count                = length(var.subnets)
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.imp_rg.name
  virtual_network_name = azurerm_virtual_network.virtual_network_1.name
  # address_prefixes     = ["10.0.${count.index + 1}.0/24"]
  address_prefixes = var.subnet_address
}

resource "azurerm_network_interface" "ansible_network_interf" {
  depends_on = [azurerm_public_ip.public_ip]
  # count               = var.count_nic
  name                = "ansible-nic"
  location            = azurerm_resource_group.imp_rg.location
  resource_group_name = azurerm_resource_group.imp_rg.name

  ip_configuration {
    name                          = "public-ip"
    subnet_id                     = azurerm_subnet.subnet-01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}


resource "azurerm_public_ip" "public_ip" {
  # count               = var.count_nic
  name                = "public-ip"
  resource_group_name = azurerm_resource_group.imp_rg.name
  location            = azurerm_resource_group.imp_rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "development"
  }
}

resource "azurerm_storage_account" "imp_sc" {
  name                     = "imp2proj"
  resource_group_name      = azurerm_resource_group.imp_rg.name
  location                 = azurerm_resource_group.imp_rg.location
  account_tier             = element(split("_", var.boot_diagnostics_sa_type), 0)
  account_replication_type = element(split("_", var.boot_diagnostics_sa_type), 1)
}

