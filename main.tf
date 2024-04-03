# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-backends"
    storage_account_name = "terraformbackendspauls"
    container_name       = "terraform-backends"
    key                  = "azure-streamlit-app.tfstate"
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "azure-streamlit-app"
  location = "eastus"
}
