resource "azurerm_resource_group" "main" {
  name     = "MJTERRA"
  location = "East US"
}

resource "azurerm_managed_disk" "source" {
  name                 = "admin_disk1_os"
  location             = "${azurerm_resource_group.main.location}"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Copy"
  source_resource_id   = "YOUR_RESOURCE_ID"
}
