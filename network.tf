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
  allocation_method   = "Dynamic"
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
  size                = "Standard_B1s"   # petite VM pour test
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic_cr460.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")  # Clé SSH générée
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

# Sortie du nom de la VM pour Terraform Cloud
output "vm_name" {
  value = azurerm_linux_virtual_machine.vm_cr460.name
}
