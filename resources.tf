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

# Supprimé pour éviter le doublon avec main.tf
# resource "azurerm_virtual_network" "vnet_cr460" {
#   name                = "vnet-cr460-samira"
#   location            = azurerm_resource_group.rg_pipeline.location
#   resource_group_name = azurerm_resource_group.rg_pipeline.name
#   address_space       = ["10.0.0.0/16"]
#
#   tags = {
#     Environment = "Dev"
#     Project     = "CR460"
#     Owner       = "Samira"
#   }
# }
#
# # Sortie du nom du réseau virtuel
# output "virtual_network_name" {
#   value = azurerm_virtual_network.vnet_cr460.name
# }