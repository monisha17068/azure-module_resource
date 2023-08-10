

# provider "azurerm" {
#   features {}
#   version=   "=2.46.0" 
#   #1.42.0"
#   subscription_id = "67c86510-9270-470e-9352-855e37b1ceaf"

  
  
#   tenant_id       = "8087a1f2-a282-469d-845f-f1b65e044f69"

#   client_id       = "4cf35477-bdf7-4737-bb93-bfd0226b43d1"
#    client_secret   ="Dg78Q~sf1uJvoq6tLEumDCyeAJF8pHGESPmAFbw"
#    #secret id- c12c55e8-558c-4cb7-969b-6083a1724340
# }

provider "azurerm" {
  features {}
   #skip_provider_registration = true
  version=   "2.46.0"
  #=2.46.0" 
  #1.42.0"
  subscription_id = "67c86510-9270-470e-9352-855e37b1ceaf"
  
  
  tenant_id       = "8087a1f2-a282-469d-845f-f1b65e044f69"
  #"8087a1f2-a282-469d-845f-f1b65e044f69"

  client_id       ="db16148c-a73f-4d04-903b-c163c2a87881"
  
  #"db16148c-a73f-4d04-903b-c163c2a87881"
   #"4cf35477-bdf7-4737-bb93-bfd0226b43d1"
   client_secret   ="yfX8Q~WdkpgGjfi98QpROdOAV0xq4PXgVeTNAbUu"
   #"xAf8Q~6WJSv4nyrTji95MJOXEjn-d9oi.0V7JbiC"
   #"~Fp8Q~Orf0ajxFX5Y4_NlGcHwIM5RHyEi8nPMcgV"
   #"Dg78Q~sf1uJvoq6tLEumDCyeAJF8pHGESPmAFbw"
   #secret id- c12c55e8-558c-4cb7-969b-6083a1724340
}







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


resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name 
  location = var.location 
}


# Create database firewall rule for VM IP address
resource "azurerm_mysql_firewall_rule" "allowvm" {
  name                = "allowvm"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_mysql_server.mysqlserver.name}"
  start_ip_address    = "${var.vmip}"
  end_ip_address      = "${var.vmip}"
}
