terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  project_name = "prime95"
}

resource "azurerm_resource_group" "prime95_rg" {
  name     = "${local.project_name}_rg"
  location = var.region
}

resource "azurerm_virtual_network" "example_vnet" {
  name                = "${local.project_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.prime95_rg.location
  resource_group_name = azurerm_resource_group.prime95_rg.name
}

resource "azurerm_subnet" "azurerm_subnet" {
  name                 = "${local.project_name}-subnet"
  resource_group_name  = azurerm_resource_group.prime95_rg.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "${local.project_name}-nic"
  location            = azurerm_resource_group.prime95_rg.location
  resource_group_name = azurerm_resource_group.prime95_rg.name

  ip_configuration {
    name                          = "${local.project_name}-internal"
    subnet_id                     = azurerm_subnet.azurerm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "prime95_vm" {
  name                  = "${local.project_name}-vm"
  resource_group_name   = azurerm_resource_group.prime95_rg.name
  location              = azurerm_resource_group.prime95_rg.location
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_B1s"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  provisioner "local-exec" {
    command = <<-EOF
      sh -c '
        export PRIME_TAR_PATH=${var.prime_tar_path}
        export MERSENNE_USERNAME=${var.mersenne_username}
        ./install.sh
      '
      EOF
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
