variable "location" {
  type = string
}

variable "synapse_location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "databricks_workspace_name" {
  type = string
}

variable "databricks_sp_name" {
  type = string
}

# variable "data_factory_name" {
#   type = string
# }

variable "synapse_workspace_name" {
  type = string
}

variable "synapse_admin_user" {
  type = string
}

variable "alpha_vantage_api_key" {
  type = string
}

variable "synapse_admin_password" {
  type = string
  sensitive = true
}

variable "key_vault_name" {
  type = string
}

variable "admin_object_id" {
  type = string
}

variable "github_account_name" {
  type = string
}

variable "github_repo_name" {
  type = string
}