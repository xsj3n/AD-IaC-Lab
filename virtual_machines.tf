resource "proxmox_virtual_environment_vm" "windows_2025_dc" {
  count       = 2
  name        = "terraform-windows-2025-${count.index}"
  description = "Terraform managed domain controllers"
  node_name   = "phv"

  vm_id = count.index + 200
  bios  = "ovmf"

  clone {
    vm_id = 105
    full  = false
  }

  cpu {
    cores = 3
    type  = "host"
  }

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = true
  }
  # if agent is not enabled, the VM may not be able to shutdown properly, and may need to be forced off
  stop_on_destroy = true


  memory {
    dedicated = 4048
    floating  = 4048 # set equal to dedicated to enable ballooning
  }

  network_device {
    bridge   = "vmbr0"
    model    = "virtio"
    enabled  = true
    firewall = true
  }

  initialization {
    datastore_id = "local-zfs"
  }


  provisioner "local-exec" {
    command = "./bin/get_network_info.sh ${var.api_token} ${count.index + 200}"
  }

}

# we read the contents of file produced by the get_network_info script so
# terraform can manage it, less cleanup
resource "local_file" "ip_info" {
  filename   = "./configuration/ipinfo_managed.cfg"
  source     = "./configuration/ipinfo.cfg"
  depends_on = [proxmox_virtual_environment_vm.windows_2025_dc]

  provisioner "local-exec" {
    command = "rm ./configuration/ipinfo.cfg"
  }
}

# exposes the contents of the ip_info file to the rest of terraform 
data "local_file" "ip_info" {
  filename = local_file.ip_info.filename
}
