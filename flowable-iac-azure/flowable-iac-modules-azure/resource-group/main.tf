/**
  * # Azure - Resource Group
  * 
  * This a Terraform module for creating resource group on Azure.
  * See the documentation below for additional info on using this module.
  */

# Set naming convention for resource group name
resource "azurecaf_name" "rg_name" {
  resource_type = "azurerm_resource_group"
  name          = var.name
  suffixes      = [var.env_suffix]
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = azurecaf_name.rg_name.result
  location = var.location
}
