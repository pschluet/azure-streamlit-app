# azure-streamlit-app
A simple Streamlit app deployed to Azure via Terraform

## Setup
1. Install [terraform](https://www.terraform.io/)
1. Install [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
1. Setup [Azure credentials](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#authenticate-using-the-azure-cli)
1. Create a resource group, blob storage account, and blob container in the Azure console, and fill in their names in `backend "azurerm"` (populate the following properties: `resource_group_name`, `storage_account_name`, and `container_name`) in [main.tf](./main.tf)
