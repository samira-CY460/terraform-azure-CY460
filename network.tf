# Bloc Subnet (Déjà validé à l'étape 8, laissé ici pour le contexte)
resource "azurerm_subnet" "subnet_cr460" {
  name                 = "subnet-cr460"
  resource_group_name  = azurerm_resource_group.rg_pipeline.name
  virtual_network_name = azurerm_virtual_network.vnet_cr460.name
  address_prefixes     = ["10.0.1.0/24"]
}

# ---------------------------------------------
# LIVRABLE 9 : IP Publique, NIC et VM
# ---------------------------------------------

# IP publique (votre code)
resource "azurerm_public_ip" "pip_cr460" {
  name                = "pip-cr460-samira"
  resource_group_name = azurerm_resource_group.rg_pipeline.name
  location            = azurerm_resource_group.rg_pipeline.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interface (votre code)
resource "azurerm_network_interface" "nic_cr460" {
  name                = "nic-cr460-samira"
  location            = azurerm_resource_group.rg_pipeline.location
  resource_group_name = azurerm_resource_group.rg_pipeline.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet_cr460.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_cr460.id
  }
}

# VM Linux (votre code)
resource "azurerm_linux_virtual_machine" "vm_cr460" {
  name                = "vm-cr460-samira"
  resource_group_name = azurerm_resource_group.rg_pipeline.name
  location            = azurerm_resource_group.rg_pipeline.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic_cr460.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  # Clé SSH (votre code)
  admin_ssh_key {
    username   = "azureuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHPtzi364Jm5Alp9nN+yffnV69Yk5h7LD/LGy24ob1l0O40CheAFNcVdW3yw+Y8TV2VsLdfQDgOPadVuIdG/flyOxwMnkeJGJjlmW0oQrqZz3+QU9W4mc+0wRzNLXnxEsvHhM2Xh1bLVcu95yO1WP+1Aoy5Gpk7ZgmPWZYBXXGOZu58ZJ/4D8sPWYcNiEQpMBvRcKusipj1m1iB7DyqoRM7Cu2op7O04qcBChfDLmNLwrvN8vrw5gek63D59eyabOx6kdarqJwN7cuvmTLsuRRsSb3yngxGCK0WZk+efQewjePq3R+aZ8RHFurNJfhEgphJbnYouEL+6z4GKwf0Zp+bfQwuN/8ArjfCNvNaBEbF6X8mApLJYopytp+JpmxVsUSuwldw4UbeFxb6kEb+yWJrNNMxsMB5uZuUCY0flhphFBeVVHZOf47r8v9CHsGXIilvyn5WNVqyfW2UlxdbQ5vB6xlPbj5oUkzLs20LR4cbnpnaXjwRGYPQxzS4nV/lwP6pAkHGanEbOOiDyebhIvUDKBYp7PL4RsxeQOW1NNYRbota/BNBXlwbTVQNPxGmrORyK2ICrHZ04s2WD8PlpDEmuUnY6NRDfH8JBrofb5U+oigva8zEHi97tnuhsAP4WzcdpnZeWHyRKC4N_"
  }
}

# ---------------------------------------------
# LIVRABLE 10 : NSG et Extension Docker
# ---------------------------------------------

# Groupe de Sécurité Réseau (NSG) - Pour l'accès réseau
resource "azurerm_network_security_group" "nsg_cr460" {
  name                = "nsg-cr460-web"
  location            = azurerm_resource_group.rg_pipeline.location
  resource_group_name = azurerm_resource_group.rg_pipeline.name
}

# Règle NSG : Autoriser SSH (Port 22) et HTTP (Port 80)
resource "azurerm_network_security_rule" "ssh_rule" {
  name                        = "Allow-SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg_pipeline.name
  network_security_group_name = azurerm_network_security_group.nsg_cr460.name
}

resource "azurerm_network_security_rule" "http_rule" {
  name                        = "Allow-HTTP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg_pipeline.name
  network_security_group_name = azurerm_network_security_group.nsg_cr460.name
}

# Association : Lier le NSG à la Carte Réseau (NIC)
resource "azurerm_network_interface_security_group_association" "nic_nsg_association" {
  network_interface_id      = azurerm_network_interface.nic_cr460.id
  network_security_group_id = azurerm_network_security_group.nsg_cr460.id
}

# Extension VM pour installer Docker et déployer Nginx
resource "azurerm_virtual_machine_extension" "docker_install" {
  name                 = "docker-install-script"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm_cr460.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "script": "sudo apt-get update -y && sudo apt-get install -y docker.io && sudo systemctl start docker && sudo systemctl enable docker && sudo docker run -d -p 80:80 --name myweb nginx"
    }
  SETTINGS
}

# Output final
output "public_ip_address" {
  value = azurerm_public_ip.pip_cr460.ip_address
}