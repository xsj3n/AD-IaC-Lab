locals {
  pve_node_name = tolist(module.shared_variables.pve_nodes)[0]

  core_cfg_ipv4    = "192.168.0.245/24"
  dist_cfg_ipv4s   = ["192.168.0.246/24", "192.168.0.247/24"]
  access_cfg_ipv4s = ["192.168.0.248/24", "192.168.0.249/24", "192.168.0.250/24", "192.168.0.251/24"]


  vlan_m_id         = 10
  vlan_m_core0_ipv4 = "192.168.10.1/24"
  vlan_m_dists_ipv4 = ["192.168.10.2/24", "192.168.10.3/24"]
  vlan_m_accss_ipv4 = ["192.168.10.4/24", "192.168.10.5/24", "192.168.10.6/24", "192.168.10.7/24"]

  access_vlans       = [20, 40, 60, 80]
  vlan_20_core0_ipv4 = "192.168.20.1/24"
  vlan_40_core0_ipv4 = "192.168.40.1/24"
  vlan_60_core0_ipv4 = "192.168.60.1/24"
  vlan_80_core0_ipv4 = "192.168.80.1/24"
}

