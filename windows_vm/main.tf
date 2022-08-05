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

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    tags = {
    environment = "testing"
    owner       = "${var.prefix}"
  }
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "windows-vm-nsg" {
  name                = "${var.prefix}-windows-vm-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-rdp"
    description                = "allow-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*" 
  }

  security_rule {
    name                       = "allow-http"
    description                = "allow-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "windows-vm-nsg-association" {
  depends_on=[azurerm_network_security_group.windows-vm-nsg]

  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.windows-vm-nsg.id
}

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.prefix}-network"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"

    tags = {
    environment = "testing"
    owner       = "${var.prefix}"
  }
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}


resource "azurerm_windows_virtual_machine" "windowsvm" {
  name                = "${var.prefix}-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DS1_v2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }
  
    source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "SQL-localPS" {
  name                 = "${var.prefix}-localPS"
  depends_on           = [azurerm_windows_virtual_machine.windowsvm]
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  virtual_machine_id   = azurerm_windows_virtual_machine.windowsvm.id
  type_handler_version = "1.9"
  settings = <<SETTINGS
    {
      "commandToExecute":"powershell.exe -encodedCommand ${textencodebase64(file(var.scfile), "UTF-16LE")}"
    }
SETTINGS

  tags = {
    environment = "${var.prefix}-env"
  }
}