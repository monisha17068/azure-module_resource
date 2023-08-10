provider "azurerm" {
  features {}
  version=   "=2.46.0" 
  #1.42.0"
  subscription_id = "ea3c6933-c647-4fe7-8281-dde36a250653"
  
  tenant_id       = "35dda2e1-5d95-42f5-8826-497f51dd4dd0"

  client_id       = "06a97084-15d6-4906-bb8f-f8a041db97a7"
   client_secret   = "Zoo8Q~7YyRFLBN0ItE8vUWuOfGrFC0sq~xyYQdwu"
}


resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "avengers123"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
#   account_kind              = var.account_kind
#   access_tier               = var.access_tier
#    min_tls_version           = var.min_tls_version

#     blob_properties {
#     delete_retention_policy {
#       days = var.blob_soft_delete_retention_days
#     }
#     container_delete_retention_policy {
#       days = var.container_soft_delete_retention_days
#     }
#     versioning_enabled       = var.enable_versioning
#     last_access_time_enabled = var.last_access_time_enabled
#     change_feed_enabled      = var.change_feed_enabled
#   }


}

resource "azurerm_storage_container" "example" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "example" {
  name                   = "azureblob"
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.example.name
  type                   = "Block"

}