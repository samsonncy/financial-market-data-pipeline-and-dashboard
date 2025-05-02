data "azurerm_client_config" "current" {}

module "resource_group" {
  source = "./modules/resource_group"
  name = var.resource_group_name
  location = var.location
}

module "storage" {
  source = "./modules/storage_account"
  name = var.storage_account_name
  resource_group_name = module.resource_group.name
  location = var.location
}

module "databricks" {
  source = "./modules/databricks"
  name = var.databricks_workspace_name
  resource_group_name = module.resource_group.name
  location = var.location
}

# module "data_factory" {
#   source = "./modules/data_factory"
#   name   = var.data_factory_name
#   resource_group_name = module.resource_group.name
#   location = var.location
# }

module "synapse" {
  source = "./modules/synapse"
  name   = var.synapse_workspace_name
  location = var.synapse_location
  resource_group_name = module.resource_group.name
  filesystem_id = module.storage.filesystem_id
  admin_user = var.synapse_admin_user
  admin_password = var.synapse_admin_password
  github_account_name = var.github_account_name
  github_repo_name = var.github_repo_name
}

module "key_vault" {
  source = "./modules/key_vault"
  name = var.key_vault_name
  location = var.location
  resource_group_name = module.resource_group.name
  
  secrets = {
    "fmdp-alpha-vantage-api-key" = var.alpha_vantage_api_key
    "fmdp-synapse-admin-password" = var.synapse_admin_password
    "fmdp-databricks-sp-client-id" = module.databricks_sp.client_id
    "fmdp-databricks-sp-client-secret" = module.databricks_sp.client_secret
    "tenant-id" = data.azurerm_client_config.current.tenant_id
  }
}

resource "azurerm_role_assignment" "admin_kv_access" {
  principal_id         = var.admin_object_id
  role_definition_name = "Key Vault Administrator"
  scope                = module.key_vault.key_vault_id
}

resource "azurerm_role_assignment" "synapse_kv_access" {
  scope = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id = module.synapse.managed_identity_principal_id
}

resource "azurerm_role_assignment" "synapse_storage_access" {
  scope                = module.storage.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.synapse.managed_identity_principal_id
}

# resource "azurerm_role_assignment" "adf_kv_access" {
#   scope = module.key_vault.key_vault_id
#   role_definition_name = "Key Vault Secrets User"
#   principal_id = module.data_factory.principal_id
# }

module "databricks_sp" {
  source = "./modules/service_principal"
  sp_display_name = var.databricks_sp_name
  rotate_password_days = 365
  assignments = [
    {
      role  = "Storage Blob Data Contributor"
      scope = module.storage.storage_account_id
    },
    {
      role = "Key Vault Secrets User"
      scope = module.key_vault.key_vault_id
    }
  ]
}