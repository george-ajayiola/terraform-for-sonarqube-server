provider "azurerm" {
  # skip_provider_registration = "true"
  subscription_id = "90a8c53f-45c0-4039-9c08-3a35f1b95e70"
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }

  }
}