terraform {
  required_version = ">= 0.12.3"
}

provider "azurerm" {
  version = "~> 1.31"
}

provider "azuread" {
  version = "~> 0.4"
}

provider "acme" {
  server_url = local.le_server
  version    = "~> 1.3"
}

provider "tls" {
  version = "~> 2.0"
}

provider "local" {
  version = "~> 1.3"
}

module "ad" {
  source = "./modules/ad"
  domain = var.domain
}

module "dns" {
  source               = "./modules/dns"
  domain               = var.domain
  location             = var.location
  service_principal_id = module.ad.service_principal_id
  a_records            = var.a_records
  cname_records        = var.cname_records
  txt_records          = var.txt_records
}

module "ssl" {
  source                     = "./modules/ssl"
  domain                     = var.domain
  location                   = var.location
  pem_file_path              = var.pem_file_path
  registration_address       = var.registration_address
  dns_resource_group         = module.dns.resource_group_name
  vault_user                 = var.vault_user
  application_id             = module.ad.application_id
  service_principal_password = module.ad.service_principal_password
}
