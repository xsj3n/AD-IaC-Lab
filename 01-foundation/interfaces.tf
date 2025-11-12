resource "proxmox_virtual_environment_network_linux_bridge" "core_switch_bridge" {
  node_name  = local.pve_node_name
  name       = "vmbrcore"
  vlan_aware = true
  comment    = "Downlink to distribution switches"


}

resource "proxmox_virtual_environment_network_linux_bridge" "distribution_switch_bridges" {
  count      = 2
  depends_on = [proxmox_virtual_environment_network_linux_bridge.core_switch_bridge]
  node_name  = local.pve_node_name
  name       = "vmbrdist${count.index}"
  vlan_aware = true
  comment    = "Downlink to access switches"


}

resource "proxmox_virtual_environment_network_linux_bridge" "access_switch_bridges" {
  count      = 4
  depends_on = [proxmox_virtual_environment_network_linux_bridge.distribution_switch_bridges]
  node_name  = local.pve_node_name
  name       = "vmbracc${count.index}"
  vlan_aware = true
  comment    = "Downlink connected to access ports"

}

