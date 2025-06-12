output "windows_2025_dc_ip_addresses" {
  value = jsondecode(data.local_file.ip_info.content)
}

output "widnows_2025_dc_mac_addresses" {
  value = proxmox_virtual_environment_vm.windows_2025_dc[*].mac_addresses
}
