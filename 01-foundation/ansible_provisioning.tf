resource "ansible_host" "alpine_core_vm" {
  name = proxmox_virtual_environment_container.core_switch_container.initialization[0].hostname

  variables = {
    ansible_host      = trimsuffix(local.core_cfg_ipv4, "/24")
    ansible_user      = "root"
    ansible_password  = "tester"
    core_vlan_mgmt_ip = local.vlan_m_core0_ipv4
    core_vlan_20_ip   = local.vlan_20_core0_ipv4
    core_vlan_40_ip   = local.vlan_40_core0_ipv4
    core_vlan_60_ip   = local.vlan_60_core0_ipv4
    core_vlan_80_ip   = local.vlan_80_core0_ipv4
    vlan20_id         = local.access_vlans[0]
    vlan40_id         = local.access_vlans[1]
    vlan60_id         = local.access_vlans[2]
    vlan80_id         = local.access_vlans[3]
  }

  groups = ["core_switches"]
}

resource "ansible_host" "alpine_distr_vms" {
  count = 2
  name  = proxmox_virtual_environment_container.distribution_switch_containers[count.index].initialization[0].hostname

  variables = {
    ansible_host       = trimsuffix(local.dist_cfg_ipv4s[count.index], "/24")
    ansible_user       = "root"
    ansible_password   = "tester"
    distr_vlan_mgmt_ip = local.vlan_m_dists_ipv4[count.index]
    vlan0_id           = count.index == 0 ? local.access_vlans[0] : local.access_vlans[2]
    vlan1_id           = count.index == 0 ? local.access_vlans[1] : local.access_vlans[3]
  }

  groups = ["distribution_switches"]
}

resource "ansible_host" "alpine_access_vms" {
  count = 4
  name  = proxmox_virtual_environment_container.access_switch_containers[count.index].initialization[0].hostname

  variables = {
    ansible_host        = trimsuffix(local.access_cfg_ipv4s[count.index], "/24")
    ansible_user        = "root"
    ansible_password    = "tester"
    access_vlan_mgmt_ip = local.vlan_m_accss_ipv4[count.index]
    access_port_vlan    = local.access_vlans[count.index]
    mgmt_vlan_id        = local.vlan_m_id
  }

  groups = ["access_switches"]
}


resource "null_resource" "ansible_network_infra_playbook" {
  depends_on = [ansible_host.alpine_access_vms, ansible_host.alpine_core_vm, ansible_host.alpine_distr_vms]

  provisioner "local-exec" {
    command = <<EOF
    sleep 1m
    cd ./configuration
    ansible-playbook ./playbooks/network_infra_config.yml
    EOF
  }
}
