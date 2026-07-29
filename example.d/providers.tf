terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "< 6.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "your-subscription-id"
}