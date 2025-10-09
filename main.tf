# ==============================================================
# Livrable 7 : Déploiement d'un Resource Group dans Azure
# Auteur : Samira
# Cours : CR460 - Réseaux sans fil et appareils mobiles
# ===============================================================

# Création du Resource Group
resource "azurerm_resource_group" "rg_pipeline" {
  name     = "rg-cr460-pipeline-samira"
  location = "eastus"  # Tu peux changer la région si besoin (ex: canadacentral)

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
