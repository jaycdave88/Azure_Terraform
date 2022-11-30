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

resource "azurerm_kubernetes_cluster" "control_plane" {
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  network_profile {
  network_plugin = "azure"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "testing"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "linux_node_pool" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.control_plane.id
  name       = "linux"
  node_count = 1
  vm_size    = "Standard_D2_v2"
}

resource "azurerm_kubernetes_cluster_node_pool" "win_node_pool" {
  #if true add windows node pool to cluster
  count = var.enable_win_node_pool ? 1 : 0

  kubernetes_cluster_id = azurerm_kubernetes_cluster.control_plane.id
  node_count            = 1
  name                  = "win"
  os_type               = "Windows"
  vm_size               = "Standard_DS2_v2"
}
