
proxmox_ip="$1"
ssh root@"$proxmox_ip" "bash -s" << "ENDSSH"

terraform_pwd=$(uuidgen)
terraform_pwd=${terraform_pwd:0:28}

sudo pveum user add terraform@pve --password "$terraform_pwd"
sudo pveum role add Terraform -privs "Datastore.Allocate Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify SDN.Use VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt User.Modify"
sudo pveum aclmod / -user terraform@pve -role Terraform

if ! dpkg -s uuid-runtime &>/dev/null; then
  apt install -y uuid-runtime
fi

sudo pveum user token add terraform@pve provider --privsep=0
printf "┌────────────────────────────────────────────────────────────────┐\n"
printf "│ Terraform SSH Password: $terraform_pwd                         |\n                                              
printf "└────────────────────────────────────────────────────────────────┘\n"

printf "IMPORTANT: These credentials will only be viewable once! Record them now!\n"
ENDSSH
