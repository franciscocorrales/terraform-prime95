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
  name                  = "${local.project_name}-nic"
  location              = azurerm_resource_group.prime95_rg.location
  resource_group_name   = azurerm_resource_group.prime95_rg.name

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

  # Script to install and run Prime95 
  custom_data = base64encode(<<EOF
    #!/bin/bash
    # Update and install dependencies
    # sudo apt-get update && sudo apt-get install -y any_dependencies_Prime95_needs

    # Download Prime95 (assuming a Linux version is available)
    curl https://www.mersenne.org/download/software/v30/30.19/p95v3019b13.linux64.tar.gz --output prime95.tar.gz

    # Unpack
    tar -xvzf prime95.tar.gz

    # Execute Prime95 (adjust the path and execution options as needed)
    ./mprime -m

    # TODO login to Prime95 with user
    # var.mersenne_username
    # TODO settings and configs

    EOF
    )
}