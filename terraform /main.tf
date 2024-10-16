terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "~> 3.0.2"
        }
        port = {
            source  = "port-labs/port-labs"
            version = "~> 2.0.3"
        }
    }

    required_version = ">= 2.0.3"
}

provider "azurerm" {

    features {}
}

provider "port" {
    client_id = var.port_client_id
    secret    = var.port_client_secret
    base_url  = var.base_url
}

resource "azurerm_storage_account" "storage_account" {
    name                = var.storage_account_name
    resource_group_name = var.resource_group_name

    location                 = var.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
}

resource "port_entity" "azure_storage_account" {
    count      = length(azurerm_storage_account.storage_account) > 0 ? 1 : 0
    identifier = var.storage_account_name
    title      = var.storage_account_name
    blueprint  = "azureStorage"
    run_id     = var.port_run_id
    properties = {
        string_props = {
        "storage_name"     = var.storage_account_name,
        "storage_location" = var.location,
        "endpoint"         = azurerm_storage_account.storage_account.primary_web_endpoint
        }
    }

    depends_on = [azurerm_storage_account.storage_account]
}
