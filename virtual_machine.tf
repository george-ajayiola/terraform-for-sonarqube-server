resource "azurerm_linux_virtual_machine" "main" {
  name                = "sonar-server"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  network_interface_ids = [azurerm_network_interface.vmnic.id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/devazurekey.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  zone = "3"

}

resource "azurerm_virtual_machine_extension" "script" {
  name                 = "script-extension"
  virtual_machine_id   = azurerm_linux_virtual_machine.main.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
        "fileUris" : ["https://postdeploymentvm.blob.core.windows.net/bashfile/postdeploy.sh?sp=r&st=2024-11-21T10:34:26Z&se=2024-11-30T18:34:26Z&spr=https&sv=2022-11-02&sr=b&sig=3nwgoQkIYFY1fkjY%2FRP6LCBSlvxDLE697mHZMLzEWsA%3D"],
        "commandToExecute": "bash postdeploy.sh"
    }
SETTINGS

  depends_on = [azurerm_linux_virtual_machine.main]
}
