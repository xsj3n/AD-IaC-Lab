resource "proxmox_virtual_environment_container" "core_switch_container" {
  depends_on   = [proxmox_virtual_environment_network_linux_bridge.core_switch_bridge]
  node_name    = local.pve_node_name
  unprivileged = true

  clone {
    datastore_id = "data0"
    node_name    = local.pve_node_name
    vm_id        = 101
  }

  memory {
    dedicated = 256
    swap      = 256
  }

  disk {
    datastore_id = "data0"
    size         = 1
  }

  network_interface {
    name   = "eth-cfg"
    bridge = "vmbr0"
  }

  # Uplink for egress/ingress 
  network_interface {
    name   = "eth-uplink"
    bridge = "vmbr0"
  }

  # Downlink(s) for distribtion switches 
  network_interface {
    name   = "eth-downlink"
    bridge = proxmox_virtual_environment_network_linux_bridge.core_switch_bridge.name
  }

  # ========================================



  initialization {
    hostname = "core-sw0"

    # vmbr0 IP
    ip_config {
      ipv4 {
        address = local.core_cfg_ipv4
      }
    }

  }


}

