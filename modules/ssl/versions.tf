terraform {
  required_providers {
    acme = {
      source = "terraform-providers/acme"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    local = {
      source = "hashicorp/local"
    }
  }
  required_version = ">= 0.13"
}
