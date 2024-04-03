# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.97.1"
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

resource "azurerm_service_plan" "sp" {
  name                = "azure-streamlit-app-sp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "lwa" {
  name                = "azure-streamlit-app-lwa"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.sp.location
  service_plan_id     = azurerm_service_plan.sp.id

  site_config {
    always_on         = false
    use_32_bit_worker = true
  }
}
