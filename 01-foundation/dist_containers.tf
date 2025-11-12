resource "proxmox_virtual_environment_container" "distribution_switch_containers" {
  depends_on   = [proxmox_virtual_environment_network_linux_bridge.distribution_switch_bridges]
  count        = 2
  node_name    = local.pve_node_name
  unprivileged = true

  clone {
    datastore_id = "data0"
    node_name    = local.pve_node_name
    vm_id        = 101
  }

  memory {
    dedicated = 128
    swap      = 128
  }

  disk {
    datastore_id = "data0"
    size         = 1
  }

  network_interface {
    name   = "eth-cfg"
    bridge = "vmbr0"
  }

  network_interface {
    name   = "eth-downlink"
    bridge = proxmox_virtual_environment_network_linux_bridge.distribution_switch_bridges[count.index].name
  }

  network_interface {
    name   = "eth-uplink"
    bridge = proxmox_virtual_environment_network_linux_bridge.core_switch_bridge.name
  }



  initialization {
    hostname = "dist-sw${count.index}"

    ip_config {
      ipv4 {
        address = local.dist_cfg_ipv4s[count.index]
      }
    }
  }


}
