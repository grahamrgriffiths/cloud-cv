# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rgcloudcv" {
  name     = "rg-cloud-cv" // Azure resource group name
  location = "UK West" // Azure location az account list-locations -o table

  tags = {
    environment = "Test"
    contact     = "Graham Griffiths"
  }
}

/*
// Example of using NSG and VNET, more complex setup
# Create a  network security group within the resource group
resource "azurerm_network_security_group" "nsgcloudcv" {
  name                = "nsg-cloud-csv"
  location            = azurerm_resource_group.rgcloudcv.location
  resource_group_name = azurerm_resource_group.rgcloudcv.name
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnetcloudcv" {
  name                = "vnet-cloud-cv"
  resource_group_name = azurerm_resource_group.rgcloudcv.name
  location            = azurerm_resource_group.rgcloudcv.location
  address_space       = ["10.0.0.0/16"]

  # Keep the front end on a separate network to the data store
  subnet {
    name           = "subnet-frontend"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet-datastore"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.nsgcloudcv.id
  }

  tags = {
    environment = "Test"
  }
}
*/

# Create a storage account within the resource group
resource "azurerm_storage_account" "sacloudcv" {
  name                     = "sacloudcv"
  resource_group_name      = azurerm_resource_group.rgcloudcv.name
  location                 = azurerm_resource_group.rgcloudcv.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document = "cv.html"
  }
}

resource "azurerm_storage_container" "sccloudcv" {
  name                  = "sc-cloud-cv"
  storage_account_name  = azurerm_storage_account.sacloudcv.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "sbcloudcv" {
  name                   = "cloud-cv.zip"
  storage_account_name   = azurerm_storage_account.sacloudcv.name
  storage_container_name = azurerm_storage_container.sccloudcv.name
  type                   = "Block"
  source                 = "cloud-cv.zip"
}

resource "azurerm_storage_blob" "sbcloudcvhtml" {
  name                   = "cv.html"
  storage_account_name   = azurerm_storage_account.sacloudcv.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = ".\\cv-source\\cv.html"
  content_type           = "text/html"
}

resource "azurerm_storage_blob" "sbcloudcvcss" {
  name                   = "styles.css"
  storage_account_name   = azurerm_storage_account.sacloudcv.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = ".\\cv-source\\styles.css"
  content_type           = "text/css"
}