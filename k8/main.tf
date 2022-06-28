variable "prefix" {
  default = "gfse"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-resources"
  location = var.location

    tags = {
    environment = "testing"
    owner       = "${var.prefix}"
  }
}

resource "azurerm_virtual_network" "network" {
  name                = "${var.prefix}-network"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "${var.prefix}-subnet"
  virtual_network_name = azurerm_virtual_network.network.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = ["10.1.0.0/22"]
}

resource "azurerm_kubernetes_cluster" "aks_cluster" { 
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "testing"
  }
}