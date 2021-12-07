resource "azurerm_network_interface" "main" {
  name     = "${var.prefix}-NetInterface"
  location = "${var.location}"
  resource_group_name  = "${var.resource_group}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${var.network_subnet_id_test}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${var.public_ip_address_id}"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = "${var.resource_group}-vm"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  #size                = "Standard_DS1_v2"
  size                = "Standard_B1s"
  admin_username      = "testadmin"
  network_interface_ids = [azurerm_network_interface.main.id]
  admin_ssh_key {
    username   = "testadmin"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
