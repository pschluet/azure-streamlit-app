# azure-streamlit-app
A simple Streamlit app deployed to Azure via Terraform

## Setup
1. Install [terraform](https://www.terraform.io/)
1. Install [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
1. Setup [Azure credentials](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#authenticate-using-the-azure-cli)
1. Create a resource group, blob storage account, and blob container in the Azure console, and fill in their names in `backend "azurerm"` (populate the following properties: `resource_group_name`, `storage_account_name`, and `container_name`) in [main.tf](./main.tf)
1. Update the `app_name` `default` in [variables.tf](./infra/variables.tf) to be the name of your app (this must be unique across all of Azure)

## Deploy from Local
Instructions for deploying from your local machine:
1. Rename `set-env.sh.example` to `set-env.sh`
1. Populate `set-env.sh` with your Azure credentials
1. Run the following commands
```
source set-env.sh
terraform apply
```

When the `terraform apply` command finishes, you will see the following:
```
Outputs:

web_app_url = "..."
```
Your Streamlit app is deployed at this URL.