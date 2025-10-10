# Création d'un Storage Account dans le Resource Group existant
resource "azurerm_storage_account" "sa_cr460" {
  name                     = "stcr460samira"
  resource_group_name      = azurerm_resource_group.rg_pipeline.name
  location                 = azurerm_resource_group.rg_pipeline.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = "Dev"
    Project     = "CR460"
    Owner       = "Samira"
  }
}

# Sortie pour Terraform Cloud
output "storage_account_name" {
  value = azurerm_storage_account.sa_cr460.name
}
