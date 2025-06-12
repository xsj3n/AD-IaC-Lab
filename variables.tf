variable "api_token" {
  type      = string
  sensitive = true
}
variable "pve_ssh_passwd" {
  type      = string
  sensitive = true
}
variable "ve_endpoint" {
  type    = string
  default = "https://192.168.0.86:8006/"
}


variable "windows_ssh_password" {
  type      = string
  sensitive = true
}

locals {
  json_ip_addresses = jsondecode(data.local_file.ip_info.content)
}

locals {
  name_prefix = "terraform-windows-2025-"
}
