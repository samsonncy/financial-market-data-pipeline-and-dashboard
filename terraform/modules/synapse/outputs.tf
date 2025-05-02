output "managed_identity_principal_id" {
  value = azurerm_synapse_workspace.main.identity[0].principal_id
}