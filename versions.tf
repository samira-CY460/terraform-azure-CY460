terraform {
  cloud {
    organization = "samira-CY460_org"
    workspaces {
      name = "terraform-azure-CY460"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

