# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.38.0"
  subscription_id = "xxxxxxxxxxxxxxxxxx"
}

variable "prefix" {
  default = "mjtf"
}

#This will create RG 
resource "azurerm_resource_group" "newmain" {
  name     = "${var.prefix}-LoadBalancerRG"
  location = "West US"
}

#This will create a static PIP for LB
resource "azurerm_public_ip" "newmain" {
  name                = "${var.prefix}-PublicIPForLB"
  location            = "West US"
  resource_group_name = "${azurerm_resource_group.newmain.name}"
  allocation_method   = "Static"
}

#This will create LB with Frontend IP configuration
resource "azurerm_lb" "newmain" {
  name                = "${var.prefix}-TestLoadBalancer"
  location            = "West US"
  resource_group_name = "${azurerm_resource_group.newmain.name}"

  frontend_ip_configuration {
    name                 = "${var.prefix}-PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.newmain.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "newmain" {
  resource_group_name = "${azurerm_resource_group.newmain.name}"
  loadbalancer_id     = "${azurerm_lb.newmain.id}"
  name                = "${var.prefix}-BackEndAddressPool"
}

resource "azurerm_lb_rule" "newmain" {
  resource_group_name            = "${azurerm_resource_group.newmain.name}"
  loadbalancer_id                = "${azurerm_lb.newmain.id}"
  name                           = "${var.prefix}-LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "${var.prefix}-PublicIPAddress"
}

resource "azurerm_lb_probe" "newmain" {
  resource_group_name = "${azurerm_resource_group.newmain.name}"
  loadbalancer_id     = "${azurerm_lb.newmain.id}"
  name                = "ssh-running-probe"
  port                = 22
}
