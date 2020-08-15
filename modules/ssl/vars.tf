variable "domain" {
  type = string
  description = "The domain to configure."
}

variable "registration_address" {
  type = string
  description = "The email address to use for registration with the CA"
}

variable "location" {
  type = string
  description = "The Azure region the resource will be created in"
}

variable "pem_file_path" {
  type = string
  description = "The location of the private key pem file for use with CA registration"
}

variable "dns_resource_group" {
  type = string
  description = "The resource group where the DNS zone resides for Acme challenge configuration"
}

variable "vault_user" {
  type = string
  description = "The microsoft login for the account that will be white-listed in the key vault."
}

variable "application_id" {
  type = string
  description = "The id for the service principal to be used for the ACME DNS Challenge sequence"
}

variable "service_principal_password" {
  type = string
  description = "the password for the service principal to be used for the ACME DNS Challenge sequence"
}

locals {
  root = split( "." , var.domain )[0]
}
