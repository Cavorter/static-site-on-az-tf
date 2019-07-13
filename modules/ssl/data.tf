data "azurerm_client_config" "current" {}

data "local_file" "acme_key" {
  filename = var.pem_file_path
}