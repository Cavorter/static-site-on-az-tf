output "application_id" {
  value = azuread_application.ad_app.application_id
}

output "service_principal_id" {
  value = azuread_service_principal.ad_sp.object_id
}

output "service_principal_password" {
    sensitive = true
    value = random_string.password.result
}