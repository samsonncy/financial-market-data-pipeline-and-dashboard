output "filesystem_id" {
  value = azurerm_storage_data_lake_gen2_filesystem.datalake.id
}

output "storage_account_id" {
  value = azurerm_storage_account.main.id
}