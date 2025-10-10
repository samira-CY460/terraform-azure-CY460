# Création du Subnet dans le réseau virtuel existant
resource "azurerm_subnet" "subnet_cr460" {
  name                 = "subnet-cr460"
  resource_group_name  = azurerm_resource_group.rg_pipeline.name
  virtual_network_name = azurerm_virtual_network.vnet_cr460.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Création d'une IP publique pour la VM
resource "azurerm_public_ip" "pip_cr460" {
  name                = "pip-cr460-samira"
  resource_group_name = azurerm_resource_group.rg_pipeline.name
  location            = azurerm_resource_group.rg_pipeline.location
  allocation_method   = "Static"    # <- Changement ici
  sku                 = "Standard"
}

# Création de la Network Interface (NIC) pour la VM
resource "azurerm_network_interface" "nic_cr460" {
  name                = "nic-cr460-samira"
  location            = azurerm_resource_group.rg_pipeline.location
  resource_group_name = azurerm_resource_group.rg_pipeline.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet_cr460.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_cr460.id
  }
}

# Création d'une VM Linux
resource "azurerm_linux_virtual_machine" "vm_cr460" {
  name                = "vm-cr460-samira"
  resource_group_name = azurerm_resource_group.rg_pipeline.name
  location            = azurerm_resource_group.rg_pipeline.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic_cr460.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHPtzi364Jm5Alp9nN+yffnV69Yk5h7LD/LGy24ob1l0O40CheAFNcVdW3yw+Y8TV2VsLdfQDgOPadVuIdG/flyOxwMnkeJGJjlmW0oQrqZz3+QU9W4mc+0wRzNLXnxEsvHhM2Xh1bLVcu95yO1WP+1Aoy5Gpk7ZgmPWZYBXXGOZu58ZJ/4D8sPWYcNiEQpMBvRcKusipj1m1iB7DyqoRM7Cu2op7O04qcBChfDLmNLwrvN8vrw5gek63D59eyabOx6kdarqJwN7cuvmTLsuRRsSb3yngxGCK0WZk+efQewjePq3R+aZ8RHFurNJfhEgphJbnYouEL+6z4GKwf0Zp+bfQwuN/8ArjfCNvNaBEbF6X8mApLJYopytp+JpmxVsUSuwldw4UbeFxb6kEb+yWJrNNMxsMB5uZuUCY0flhphFBeVVHZOf47r8v9CHsGXIilvyn5WNVqyfW2UlxdbQ5vB6xlPbj5oUkzLs20LR4cbnpnaXjwRGYPQxzS4nV/lwP6pAkHGanEbOOiDyebhIvUDKBYp7PL4RsxeQOW1NNYRbota/BNBXlwbTVQNPxGmrORyK2ICrHZ04s2WD8PlpDEmuUnY6NRDfH8JBrofb5U+oigva8zEHi97tnuhsAP4WzcdpnZeWHyRKC4N8naRiH0i5Avu/L3hd732HPhKRrZEQ== samira@exemple.com"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "osdisk-vm-cr460"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
    Environment = "Dev"
    Project     = "CR460"
    Owner       = "Samira"
  }
}

# Sortie pour Terraform Cloud
output "vm_name" {
  value = azurerm_linux_virtual_machine.vm_cr460.name
}
