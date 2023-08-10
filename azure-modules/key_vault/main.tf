# Create a key vault
resource "azurerm_key_vault" "myKeyVault" {
  name                = "${var.resource_group_name}vault"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  sku_name = "standard"

  tenant_id = "${var.tenant_id}"

  access_policy {
    tenant_id = "${var.tenant_id}"
    object_id = "${var.object_id}"

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get",
    ]
  }

  enabled_for_disk_encryption = true

  tags = {
    environment = "Terraform Demo"
  }
}