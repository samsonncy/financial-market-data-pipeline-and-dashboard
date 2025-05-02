output "client_id" {
  value = azuread_application_registration.main.client_id
}

output "client_secret" {
  value     = azuread_application_password.secret.value
  sensitive = true
}

output "object_id" {
  value = azuread_application_registration.main.object_id
}