terraform {
  required_providers {
    proxmox = {
      version = "0.82.1"
      source  = "bpg/proxmox"
    }
    ansible = {
      version = "~> 1.3.0"
      source  = "ansible/ansible"
    }
    null = {
      version = "~> 3.2.4"
      source  = "hashicorp/null"
    }
    local = {
      version = "~> 2.5.3"
      source  = "hashicorp/local"
    }
  }
}
