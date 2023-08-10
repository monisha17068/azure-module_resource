# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                = "autologic${var.uid}storage"
    resource_group_name = "${var.resource_group_name}"
    location            = "${var.location}"
    #account_type        = "Standard_LRS"
    # required by new version of azurerm
    account_tier          = "Standard"
    account_replication_type = "GRS"
    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_storage_container" "mystoragecontainer" {
  name                  = "vhds"
  #resource_group_name   = "${var.resource_group_name}"
  storage_account_name  = "${azurerm_storage_account.mystorageaccount.name}"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "mystorageblob" {
  name = "sample.vhd"

  #resource_group_name    = "${var.resource_group_name}"
  storage_account_name   = "${azurerm_storage_account.mystorageaccount.name}"
  storage_container_name = "${azurerm_storage_container.mystoragecontainer.name}"

  type = "Page"
  size = 5120
}


