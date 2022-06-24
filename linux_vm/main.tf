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

resource "azurerm_ssh_public_key" "ssh" {
  name                = "${var.prefix}-sshkey"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  public_key          = file("${var.pemfile}")
}

# resource "azurerm_network_security_group" "nsg" { 
#   name                = "${var.prefix}-nsg"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   security_rule {  
#     name                       = "RDP"  
#     priority                   = 100  
#     direction                  = "Inbound"  
#     access                     = "Allow"  
#     protocol                   = "Tcp"  
#     source_port_range          = "*"  
#     destination_port_range     = "3389"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"  
#   }
#     tags = {
#     environment = "testing"
#     owner       = "${var.prefix}"
#   }
# }  

# resource "azurerm_subnet_network_security_group_association" "nsg_association" {
#     subnet_id                   = azurerm_subnet.internal.id
#     network_security_group_id   = azurerm_network_security_group.nsg.id

#     depends_on = [
#         azurerm_network_security_group.nsg
#     ]
# }

# resource "azurerm_virtual_machine" "main" {
#   name                  = "${var.prefix}-vm"
#   location              = azurerm_resource_group.rg.location
#   resource_group_name   = azurerm_resource_group.rg.name
#   network_interface_ids = [azurerm_network_interface.main.id]
#   vm_size               = "Standard_DS1_v2"

#   # Uncomment this line to delete the OS disk automatically when deleting the VM
#   delete_os_disk_on_termination = true

#   # Uncomment this line to delete the data disks automatically when deleting the VM
#   delete_data_disks_on_termination = true

#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }
#   storage_os_disk {
#     name              = "myosdisk1"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }
#   os_profile {
#     computer_name  = "${var.prefix}-hostname"
#     admin_username = var.admin_username
#     admin_password = var.admin_password
#   }
#   os_profile_linux_config {
#     disable_password_authentication = false
#   }
#   tags = {
#     environment = "testing"
#     owner       = "${var.prefix}"
#   }
# }

resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                = "${var.prefix}-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DS1_v2"
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = azurerm_ssh_public_key.ssh.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }
  
    source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "vmext" {
  name                 = "${var.prefix}-vmext"
  virtual_machine_id   = azurerm_linux_virtual_machine.linuxvm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
         "script": "${base64encode(file(var.scfile))}"
    }
SETTINGS

  tags = {
    environment = "testing"
    owner       = "${var.prefix}"
  }
}