resource "azurerm_storage_account" "main" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true  # Hierarchical namespace (ADLS Gen2)
}

resource "azurerm_storage_data_lake_gen2_filesystem" "datalake" {
  name               = "financial-data"
  storage_account_id = azurerm_storage_account.main.id
}

# Bronze layer (raw data)
resource "azurerm_storage_data_lake_gen2_path" "bronze" {
  path               = "bronze"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.datalake.name
  storage_account_id = azurerm_storage_account.main.id
  resource           = "directory"
}

# Silver layer (cleansed data)
resource "azurerm_storage_data_lake_gen2_path" "silver" {
  path               = "silver"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.datalake.name
  storage_account_id = azurerm_storage_account.main.id
  resource           = "directory"
}

# Gold layer (aggregated/business-ready data)
resource "azurerm_storage_data_lake_gen2_path" "gold" {
  path               = "gold"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.datalake.name
  storage_account_id = azurerm_storage_account.main.id
  resource           = "directory"
}