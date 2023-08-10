
# Create MySQL Server resource
resource "azurerm_mysql_server" "mysqlserver" {
  name                = "autologic${var.uid}mysqlserver"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  
  sku_name = "GP_Gen5_2"
  #sku {
    #name = "MYSQLB50"
   # capacity = 50
   # tier = "Basic"
  #}

  administrator_login = "${var.dblogin}"
  administrator_login_password = "${var.dbpassword}"
  version = "5.7"
  storage_mb = "5120"
  ssl_enforcement_enabled = true
}

# Create MySQL Database resource
resource "azurerm_mysql_database" "mysqldatabase" {
  name                = "${var.resource_group_name}mysqldb"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_mysql_server.mysqlserver.name}"
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

# Create database firewall rule for VM IP address
resource "azurerm_mysql_firewall_rule" "allowvm" {
  name                = "allowvm"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_mysql_server.mysqlserver.name}"
  start_ip_address    = "${var.vmip}"
  end_ip_address      = "${var.vmip}"
}
