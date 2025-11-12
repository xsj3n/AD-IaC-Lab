provider "proxmox" {
  endpoint  = module.shared_variables.ve_endpoint
  api_token = module.shared_variables.secrets.api_token
  insecure  = true # due to self-signed TLS certificate 
  ssh {
    username = "terraform"
    password = module.shared_variables.secrets.pve_ssh_passwd
  }
}
