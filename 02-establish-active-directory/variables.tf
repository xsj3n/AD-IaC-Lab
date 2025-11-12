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

variable "dsrm_password" {
  type      = string
  sensitive = true
}

variable "vm_ids" {
  type    = list(number)
  default = [200, 201]
}

variable "clone_id" {
  type    = number
  default = 105
}

variable "ip_info_relative_path" {
  type    = string
  default = "./configuration/ip_info.json"
}

variable "cpu_cores" {
  type    = number
  default = 3
}

variable "memory" {
  type    = number
  default = 4048
}

locals {
  ip_info_path = abspath(var.ip_info_relative_path)

  ips_unchked = jsondecode(data.local_file.ip_info.content)

  name_prefix = "terraform-windows-2025-"
}

locals {
  ip_addresses = local.ips_unchked.ip_addrs[0].id == var.vm_ids[0] ? local.ips_unchked.ip_addrs : reverse(local.ips_unchked.ip_addrs)
}
