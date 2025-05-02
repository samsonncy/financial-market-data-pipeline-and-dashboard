resource "azuread_application_registration" "main" {
  display_name = var.sp_display_name
}

resource "azuread_service_principal" "main" {
  client_id = azuread_application_registration.main.client_id
}

resource "time_rotating" "password_rotation" {
  rotation_days = var.rotate_password_days
}

resource "azuread_application_password" "secret" {
  application_id = azuread_application_registration.main.id
  display_name   = "${var.sp_display_name}-secret"

  rotate_when_changed = {
    rotation = time_rotating.password_rotation.id
  }
}

resource "azurerm_role_assignment" "main" {
  for_each = { for idx, v in var.assignments : idx => v }

  principal_id = azuread_service_principal.main.object_id
  role_definition_name = each.value.role
  scope = each.value.scope

  depends_on = [azuread_service_principal.main]
}
