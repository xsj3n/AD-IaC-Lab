resource "ansible_host" "windows_2025_dc" {
  count = 2
  name  = proxmox_virtual_environment_vm.windows_2025_dc[count.index].name

  variables = {
    ansible_host       = local.ip_addresses[count.index].ip
    ansible_host6      = local.ip_addresses[count.index].ip6
    ansible_user       = "Administrator"
    ansible_password   = var.windows_ssh_password
    ansible_shell_type = "powershell"
    domain             = "xs-labs.io"
    netbios            = "xslabs"
    dsrm               = var.dsrm_password
  }
}


resource "null_resource" "ansible_dc_promo_playbook" {
  depends_on = [ansible_host.windows_2025_dc]

  provisioner "local-exec" {
    command = <<EOF
    cd ./configuration;
    ansible-playbook ./playbooks/domain_establishment.yml \
    --extra-vars 'dc_0=${ansible_host.windows_2025_dc[0].name} dc_1=${ansible_host.windows_2025_dc[1].name}';
    EOF
  }
}


