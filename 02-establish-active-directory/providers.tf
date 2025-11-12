provider "proxmox" {
  endpoint  = var.ve_endpoint
  api_token = var.api_token
  insecure  = true
  ssh {
    username = "terraform"
    password = var.pve_ssh_passwd
  }
}


