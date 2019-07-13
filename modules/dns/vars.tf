variable "domain" {
  type        = "string"
  description = "The domain to configure"
}

variable "location" {
  type        = "string"
  description = "The Azure region the resource will be created in"
}

variable "service_principal_id" {
  type        = "string"
  description = "The service principal to assign to the dns editor role"
}

variable "a_records" {}

variable "cname_records" {}

variable "txt_records" {}

locals {
  root           = split(".", var.domain)[0]
  ttl            = 3600
  dns_role_scope = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.dns_rg.name}/providers/Microsoft.Network/dnsZones/${azurerm_dns_zone.dns_zone.name}"
}
