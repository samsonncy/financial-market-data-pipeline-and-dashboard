variable "sp_display_name" {
  type = string
}

variable "assignments" {
  type = list(object({
    role = string
    scope = string
  }))
  default = []
}

variable "rotate_password_days" {
  type    = number
  default = 365
}