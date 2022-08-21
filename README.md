## cloud-cv
Cloud-CV Repo - Taking on the challenge from https://cloudresumechallenge.dev/docs/extensions/terraform-getting-started/

Also following https://cloudresumechallenge.dev/docs/the-challenge/azure/ 

For this challenge, my CV will be deployed online as an Azure Storage static website.

## Install Azure CLI (if needed)
https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli

## Install Terraform on Windows
```
# setup
$installPath = "C:\Program Files"
$version = "1.2.7"
$folderName = "terraform_$($version)_windows_amd64"
$fileName = "$folderName.zip"
$terraformPath = Join-Path $installPath $folderName

# download
mkdir $terraformPath
cd $terraformPath

$downloadPath = "https://releases.hashicorp.com/terraform/$($version)/terraform_$($version)_windows_amd64.zip"

iwr -Uri $downloadPath -outfile $fileName

# extract
Expand-Archive -Path .\$fileName -DestinationPath .\
rm .\$fileName -Force

# from here, you should use the UI to modify the path environment variable to add the following folder
$terraformPath

#
# Example of using setx, but doing this is dangerous. 
# It truncates to 1024 chracters, so if your path is longer - you could lose some folders!
# $env:Path

# add path to terraform
# $newEnvPath = "$env:Path;$terraformPath"

# $newEnvPath

# set new path
# setx /M PATH "%PATH%;$terraformPath"
#

# verify install, need to restart cmd window for this to work
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