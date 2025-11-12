resource "proxmox_virtual_environment_vm" "windows_2025_dc" {
  count       = 2
  name        = "terraform-windows-2025-${count.index}"
  description = "Terraform managed domain controllers"
  node_name   = "pve0"

  vm_id = var.vm_ids[count.index]
  bios  = "ovmf"

  clone {
    vm_id = var.clone_id
    full  = false
  }

  cpu {
    cores = var.cpu_cores
    type  = "host"
  }

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = true
  }
  # if agent is not enabled, the VM may not be able to shutdown properly, and may need to be forced off
  stop_on_destroy = true


  memory {
    dedicated = var.memory
    floating  = var.memory # set equal to dedicated to enable ballooning
  }

  network_device {
    bridge   = "vmbr0"
    model    = "virtio"
    enabled  = true
    firewall = true
  }

  provisioner "local-exec" {
    command = "./bin/get_network_info.sh ${var.api_token} ${count.index + 200} ${local.ip_info_path}"
  }

}

# Copy the JSON file produced by the script so Terraform can considered a managed resource
resource "local_file" "ip_info_file" {
  filename   = local.ip_info_path
  source     = local.ip_info_path
  depends_on = [proxmox_virtual_environment_vm.windows_2025_dc]

  lifecycle {
    ignore_changes = all
  }
}


# Exposes the contents of the ip_info file to the rest of terraform
data "local_file" "ip_info" {
  filename = local_file.ip_info_file.filename
}

# Removes the IP information file once the deployment is done
resource "null_resource" "remove_ip_file" {
  depends_on = [null_resource.ansible_dc_promo_playbook]

  provisioner "local-exec" {
    command = "rm -f ${local.ip_info_path}"
  }
}

