#create virtual machine
resource "azurerm_linux_virtual_machine" "myterraformvm" {
  name                = "${var.resource_group_name}vm"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  size                = "Standard_DS1_v2"
  admin_username          =   "adminuser" 
  admin_password          =   "Password123!" 
  network_interface_ids = ["${var.vnetwork_interface_id}",
  ]

 /*admin_ssh_key {
    username   = "adminuser"
    public_key = file("/.ssh/id_rsa.pub")
  }*/

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

   source_image_reference   { 
     publisher   =   "MicrosoftWindowsServer" 
     offer       =   "WindowsServer" 
     sku         =   "2019-Datacenter" 
     version     =   "latest" 
   } 

    boot_diagnostics {
        #enabled = "true"
        #storage_uri = "${var.blob_storage_url}"
    }

}