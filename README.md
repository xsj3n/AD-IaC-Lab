# Active Directory Infrastructure as Code Lab
---

This repository contains a Terraform and Ansible project to deploy two domain controllers on Proxmox. It also contains a Nix flake I used to manage my local environment on NixOS.

The `bin/proxmox_terraform_setup.sh` script is also provided to automation the configuration of Proxmox in prepartion of use with Terraform. 

## Requirements

The following are needed to run the deployment:

- Windows 2025 template in Proxmox prepared with sysprep

- Proxmox installation

- Working environment with Terraform, Ansible, and Bash installed

## Proxmox IP Acquisition Issues

In my time working with the `bpg/proxmox` provider for Terraform, I found the QEMU guest agent fails to accurately report a useable IP. It very often reports a link-local address. Due to this, the `bin/get_network_info.sh` script is used to query the Proxmox API and acquire the required network information.


## Proxmox Configuration for Terraform Script

The `proxmox_terraform_setup.sh` script only takes one parameter, the IP of your Proxmox instance. It will prompt you for credentials to perform actions over SSH. Upon completion, the script will output the API token associated with the Terraform@pve user which was created & a generated password for the Terraform@pam user.

## Variables

- api_token

    - Type: string

    - Sensitive: true

    - Purpose: API token for Proxmox
  
- pve_ssh_passwd

    - Type: string

    - Sensitive: true

    - Purpose: Password used for SSH authentication with the Proxmox VE (PVE) server.

- ve_endpoint

    - Type: string

    - Default: "https://192.168.0.86:8006/"

    - Purpose: The URL endpoint for your Proxmox VE instance.

- windows_ssh_password

    - Type: string

    - Sensitive: true

    - Purpose: Password for SSH access to Windows VMs.

- dsrm_password

    - Type: string

    - Sensitive: true

    - Purpose: Directory Services Restore Mode (DSRM) password for Windows Domain Controllers.

- vm_ids

    - Type: list(number)

    - Default: [200, 201]

    - Purpose: List of two VM IDs. Index 0 will be the first VMs ID, index 1 will be the second's ID.

- clone_id

    - Type: number

    - Default: 105

    - Purpose: VM ID of the prepared template of Windows 2025.

- ip_info_relative_path

    - Type: string

    - Default: "./configuration/ip_info.json"

    - Purpose: Relative path to a JSON file containing IP configuration info.

- cpu_cores

    - Type: number

    - Default: 3

    - Purpose: Number of CPU cores assigned to each VM.

- memory

    - Type: number

    - Default: 4096

    - Purpose: Amount of memory (in MB) assigned to each VM.
