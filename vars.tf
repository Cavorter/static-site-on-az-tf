variable "prod" {
  type        = bool
  default     = false
  description = "If 'true' will use the Let's Encrypt production server. Otherwise it will use the staging server to help protect from running into api quotas."
}

variable "location" {
  type        = string
  description = "The Azure region all resources will be created in"
}

variable "domain" {
  type        = string
  description = "The domain to configure"
}

variable "pem_file_path" {
  type        = string
  description = "The path to the private key pem file used for CA registration"
}

variable "registration_address" {
  type        = string
  description = "The email address to register with the CA"
}

variable "vault_user" {
  type        = string
  description = "The object id of microsoft login for the account that will be white-listed in the key vault. You can use the Get-AzAdUser command to retrieve this field."
}

variable "a_records" {
  description = "A list of tuples with a name and address field for each a record to create in the DNS zone."
}

variable "cname_records" {
  description = "A list of tuples with a name and cname field for each a record to create in the DNS zone."
}

variable "txt_records" {
  description = "A list of tuples with a name and value field for each a record to create in the DNS zone."
}

locals {
  le_server_prod  = "https://acme-v02.api.letsencrypt.org/directory"
  le_server_stage = "https://acme-staging-v02.api.letsencrypt.org/directory"
  le_server       = var.prod ? local.le_server_prod : local.le_server_stage
}

