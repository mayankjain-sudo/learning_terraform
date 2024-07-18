
# Configure the provider
provider "azurerm" {
    version = "=1.28.0"
}

# Create a new resource group
resource "azurerm_resource_group" "rg" {
    name     = "myTFResourceGroup"
    location = "South India"

    tags     =  {
        environment = "Test TF RG Creation"
    }
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "myTFVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "South India"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    tags		= {
	Name = "Test TF VN Creation"
    }
}
# Create subnet
resource "azurerm_subnet" "subnet" {
    name                 = "myTFSubnet"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix       = "10.0.1.0/24"
}

# Create public IP
resource "azurerm_public_ip" "publicip" {
    name                         = "myTFPublicIP"
    location                     = "South India"
    resource_group_name          = "${azurerm_resource_group.rg.name}"
    allocation_method		 = "Dynamic"
    tags			 = { 
    	Name = "Test TF Public IP Creation"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
    name                = "myTFNSG"
    location            = "South India"
    resource_group_name = "${azurerm_resource_group.rg.name}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    tags		= {
	Name = "Test TF NSG for VM"
    }
}


# Create network interface
resource "azurerm_network_interface" "nic" {
    name                      = "myNIC"
    location                  = "South India"
    resource_group_name       = "${azurerm_resource_group.rg.name}"
    network_security_group_id = "${azurerm_network_security_group.nsg.id}"

    ip_configuration {
        name                          = "myNICConfg"
        subnet_id                     = "${azurerm_subnet.subnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.publicip.id}"
    }
    tags		     = { 
    	Name = "Test TF Network Interface"
    }
}

# Create a Linux virtual machine
resource "azurerm_virtual_machine" "vm" {
    name                  = "myTFVM"
    location              = "South India"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.nic.id}"]
    vm_size               = "Standard_B1s"

    storage_os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "myTFVM"
        admin_username = "mayank"
        admin_password = "testyou" # Not recommended
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }
    tags		= {
	Name = "Test TF VM Creation"
    }

}
