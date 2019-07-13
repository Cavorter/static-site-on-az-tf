resource "azurerm_resource_group" "dns_rg" {
  name     = "${local.root}-dns-rg"
  location = var.location
}

resource "azurerm_dns_zone" "dns_zone" {
  name                = var.domain
  resource_group_name = azurerm_resource_group.dns_rg.name
}

resource "azurerm_dns_a_record" "dns_a_record" {
  name                = var.a_records[count.index].name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.dns_rg.name
  ttl                 = local.ttl
  records             = var.a_records[count.index].address
  count               = length(var.a_records)
}

resource "azurerm_dns_cname_record" "dns_cname_record" {
  name                = var.cname_records[count.index].name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.dns_rg.name
  ttl                 = local.ttl
  record              = var.cname_records[count.index].cname
  count               = length(var.cname_records)
}

resource "azurerm_dns_txt_record" "dns_txt_record" {
  name                = var.txt_records[count.index].name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.dns_rg.name
  ttl                 = local.ttl
  count               = length(var.txt_records)
  record {
    value = var.txt_records[count.index].value
  }
}

resource "azurerm_dns_mx_record" "dns_mx_record" {
  name                = "@"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.dns_rg.name
  ttl                 = local.ttl

  record {
    preference = 1
    exchange   = "aspmx.l.google.com"
  }
  record {
    preference = 5
    exchange   = "alt1.aspmx.l.google.com"
  }
  record {
    preference = 5
    exchange   = "alt2.aspmx.l.google.com"
  }
  record {
    preference = 10
    exchange   = "aspmx2.googlemail.com"
  }
  record {
    preference = 10
    exchange   = "aspmx3.googlemail.com"
  }
  record {
    preference = 10
    exchange   = "aspmx4.googlemail.com"
  }
  record {
    preference = 10
    exchange   = "aspmx5.googlemail.com"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_definition" "dns_role" {
  name  = "${local.root}-dns-editor"
  scope = local.dns_role_scope

  permissions {
    actions = ["*"]
  }
  assignable_scopes = [
    local.dns_role_scope
  ]
}

resource "azurerm_role_assignment" "sp_role" {
  role_definition_id = azurerm_role_definition.dns_role.id
  scope        = local.dns_role_scope
  principal_id = var.service_principal_id
}
