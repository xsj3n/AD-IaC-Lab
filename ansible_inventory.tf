resource "ansible_host" "windows_2025_dc" {
  count = 2
  name  = "${local.name_prefix}${count.index}"

  variables = {
    ansible_host       = local.json_ip_addresses.ip_addrs[count.index].ip
    ansible_user       = "Administrator"
    ansible_password   = var.windows_ssh_password
    ansible_connection = "ssh"
    ansible_port       = 22
    ansible_shell_type = "powershell"
  }
}
