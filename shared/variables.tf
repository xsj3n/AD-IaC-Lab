output "pve_nodes" {
  value = toset(["pve0"])
}

output "ve_endpoint" {
  value = "https://192.168.0.86:8006"
}

output "ve_ip" {
  value = "192.168.0.86"
}

output "secrets" {
  value = jsondecode(file("${path.module}/secrets_all.json"))
}
