provider "random" {
  version = "~> 2.1"
}

resource "azuread_application" "ad_app" {
  name     = var.domain
  homepage = "https://${var.domain}"
}

resource "azuread_service_principal" "ad_sp" {
  application_id = azuread_application.ad_app.application_id
}

resource "random_string" "password" {
  length  = 30
  special = true
}

resource "azuread_service_principal_password" "ad_sp_pwd" {
  service_principal_id = azuread_service_principal.ad_sp.id
  value                = random_string.password.result
  end_date_relative    = "1h"
}
