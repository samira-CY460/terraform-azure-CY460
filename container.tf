# =============================================
# Création d'un groupe de conteneurs Azure
# =============================================
resource "azurerm_container_group" "container_cr460" {
  name                = "container-cr460-samira"
  location            = azurerm_resource_group.rg_pipeline.location
  resource_group_name = azurerm_resource_group.rg_pipeline.name
  ip_address_type     = "Public"  # Permet un accès externe
  os_type             = "Linux"

  container {
    name   = "nginx-container"
    image  = "nginx:latest"  # Image publique Docker Hub
    cpu    = "0.5"           # 0.5 vCPU (dans la limite gratuite)
    memory = "1.5"           # 1.5 GiB (dans la limite gratuite)

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = {
    Environment = "Dev"
    Project     = "CR460"
    Owner       = "Samira"
  }
}

# =============================================
# Sortie pour Terraform Cloud
# =============================================
output "container_ip" {
  value = azurerm_container_group.container_cr460.ip_address
}
