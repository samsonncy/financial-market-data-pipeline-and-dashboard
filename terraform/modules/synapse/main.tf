resource "azurerm_synapse_workspace" "main" {
  name                                = var.name
  resource_group_name                 = var.resource_group_name
  location                            = var.location
  storage_data_lake_gen2_filesystem_id = var.filesystem_id
  sql_administrator_login             = var.admin_user
  sql_administrator_login_password    = var.admin_password
  
  identity {
    type = "SystemAssigned"
  }

  github_repo {
    account_name    = var.github_account_name
    repository_name = var.github_repo_name
    branch_name     = "dev_synapase"
    root_folder     = "/synapase"
    git_url         = "https://github.com"
  }

  lifecycle {
    ignore_changes = [
      github_repo
    ]
  }
}

resource "azurerm_synapse_firewall_rule" "allow_all" {
  name                 = "AllowAll"
  synapse_workspace_id = azurerm_synapse_workspace.main.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "255.255.255.255"
}