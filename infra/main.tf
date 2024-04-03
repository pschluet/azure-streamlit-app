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

// This archive_file block creates a ZIP archive of the streamlit app
data "archive_file" "app" {
  type        = "zip"
  source_dir  = "../streamlit"
  output_path = var.streamlit_archive_output_path
}

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
  name                = var.app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.sp.location
  service_plan_id     = azurerm_service_plan.sp.id
  https_only          = true

  site_config {
    always_on         = false
    use_32_bit_worker = true
    app_command_line  = "python -m streamlit run app.py  --server.port 8000 --server.address 0.0.0.0"
    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = 1
  }
}

// This local block defines a command for publishing code to the Azure Web App (Linux).
locals {
  publish_code_command_linux = "az webapp deployment source config-zip --resource-group ${azurerm_linux_web_app.lwa.resource_group_name} --name ${azurerm_linux_web_app.lwa.name} --src ${var.streamlit_archive_output_path}"
}

// This null_resource block publishes code to the Azure Web App (Linux) using the local-exec provisioner.
resource "null_resource" "app" {
  provisioner "local-exec" {
    command = local.publish_code_command_linux
  }
  depends_on = [local.publish_code_command_linux]
  triggers = {
    input_json           = filemd5(var.streamlit_archive_output_path)
    publish_code_command = local.publish_code_command_linux
  }
}

output "web_app_url" {
  value = "https://${azurerm_linux_web_app.lwa.default_hostname}"
}
