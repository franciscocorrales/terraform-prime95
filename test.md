
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

    azurermpreview = {
      source  = "hashicorp/azurerm-preview"
      version = "~>3.0" 
    }