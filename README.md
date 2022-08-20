## cloud-cv
Cloud-CV Repo - Taking on the challenge from https://cloudresumechallenge.dev/docs/extensions/terraform-getting-started/

Also following https://cloudresumechallenge.dev/docs/the-challenge/azure/ 

For this challenge, my CV will be deployed online as an Azure Storage static website.

## Install Terraform on Windows
```
$installPath = "C:\Program Files"
$version = "1.2.7"
$filename = "terraform_$version_windows_amd64.zip"

mkdir $installPath
cd $installPath

$downloadPath = https://releases.hashicorp.com/terraform/$version/terraform_$version_windows_amd64.zip

iwr -Uri $downloadPath -outfile $filename

Expand-Archive -Path .\$filename -DestinationPath .\
rm .\$filename -Force

setx PATH "$env:path;$installPath" -m

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

terraform version
```
## Install VS Code Extension

https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform

## Write the Terraform provider configuration, I'm using Azure

https://www.terraform.io/language/providers/configuration

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

```
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
```

## Login to Azure CLI

``` az login ```

# List locations

``` az account list-locations -o table ```

## Terraform commands

# Setup
Use the following command to initialize your working directory with Terraform to download and set up the provider(s).

``` terraform init ```

# Validate
Check that your configuration is valid

``` terraform validate ```

# Plan
Show changes required by the current configuration

``` terraform plan ```

# Apply / Destroy
Create or update infrastructure 

``` terraform apply ```

Destroy previously created infrastructure

``` terraform destroy ```

## Building the content

``` Compress-Archive -Path cv-source -DestinationPath cloud-cv.zip ```

## Browsing the content (No dns yet)

https://sacloudcv.z35.web.core.windows.net/