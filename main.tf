terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0" 
    }
    azurermpreview = {
      source  = "hashicorp/azurerm-preview"
      version = "~>3.0" 
    }
  }
}

resource "azurerm_resource_group" "prime95_rg" {
  name     = "prime95-project-rg"
  location = "westus" # Choose a Free Tier supported location 
}

resource "azurerm_preview_costmanagement_budget" "example_budget" {
  name                 = "example-resource-group-budget"
  scope                = azurerm_resource_group.example.id
  amount               = 5 # Your desired budget limit 
  time_grain            = "Monthly"
  time_period {
    start_date     = "2024-04-07T00:00:00Z" 
  }

  notification {
    threshold = 90 
    threshold_type = "Actual"
    contact_emails = var.contact_emails
  }
}

resource "azurerm_virtual_network" "example_vnet" {
  name                = "prime95-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.prime95_rg.location 
  resource_group_name = azurerm_resource_group.prime95_rg.name
}

resource "azurerm_subnet" "azurerm_subnet" {
  name                 = "prime95-subnet"
  resource_group_name  = azurerm_resource_group.prime95_rg.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.1.0/24"] 
}

 resource "azurerm_network_interface" "nic" {
  name                  = "prime95-nic"
  location              = azurerm_resource_group.prime95_rg.location
  resource_group_name   = azurerm_resource_group.prime95_rg.name

  ip_configuration {
    name                          = "prime95-internal"
    subnet_id                     = azurerm_subnet.azurerm_subnet.id 
    private_ip_address_allocation = "Dynamic" 
  }
}

resource "azurerm_linux_virtual_machine" "prime95_vm" {
  name                  = "prime95-vm"
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