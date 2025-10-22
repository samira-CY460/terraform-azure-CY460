# ==============================================================
# Livrable 7 : Déploiement d'un Resource Group dans Azure
# Auteur : Samira
# Cours : CR460 - Réseaux sans fil et appareils mobiles
# ===============================================================

# Création du Resource Group
resource "azurerm_resource_group" "rg_pipeline" {
  name     = "rg-cr460-pipeline-samira"
  location = "Centralus"

  tags = {
    Environment = "Dev"
    Project     = "CR460"
    Owner       = "Samira"
  }
}

# Création du Réseau Virtuel (corrigé avec le nom réel)
resource "azurerm_virtual_network" "vnet_cr460" {
  name                = "vnet-cr460-samira"  # Aligné avec Azure
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_pipeline.location
  resource_group_name = azurerm_resource_group.rg_pipeline.name

  tags = {
    Environment = "Dev"
    Project     = "CR460"
    Owner       = "Samira"
  }
}

# Sortie affichée dans Terraform Cloud
output "resource_group_name" {
  value = azurerm_resource_group.rg_pipeline.name
}

# Configuration du fournisseur
provider "azurerm" {
  features {}
}