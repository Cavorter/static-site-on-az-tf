resource "azurerm_resource_group" "vault_rg" {
  name     = "${local.root}-vault-rg"
  location = var.location
}

resource "azurerm_key_vault" "vault_vlt" {
  name                = "${local.root}-vault-vlt"
  location            = azurerm_resource_group.vault_rg.location
  resource_group_name = azurerm_resource_group.vault_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.vault_user

    certificate_permissions = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "setissuers",
      "update",
    ]

    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]

    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set",
    ]
  }
}

resource "acme_registration" "reg" {
  account_key_pem = data.local_file.acme_key.content
  email_address   = var.registration_address
}

resource "acme_certificate" "certificate" {
  account_key_pem    = acme_registration.reg.account_key_pem
  common_name        = "*.${var.domain}"
  min_days_remaining = 60

  dns_challenge {
    provider = "azure"
    config = {
      AZURE_RESOURCE_GROUP  = var.dns_resource_group
      AZURE_TENANT_ID       = data.azurerm_client_config.current.tenant_id
      AZURE_SUBSCRIPTION_ID = data.azurerm_client_config.current.subscription_id
      AZURE_CLIENT_ID       = var.application_id
      AZURE_CLIENT_SECRET   = var.service_principal_password
    }
  }
}

resource "azurerm_key_vault_certificate" "ssl-cert" {
  name         = "${local.root}-ssl-cert"
  key_vault_id = azurerm_key_vault.vault_vlt.id

  certificate {
    contents = acme_certificate.certificate.certificate_p12
  }

  certificate_policy {
    issuer_parameters {
      name = "Unknown"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}
