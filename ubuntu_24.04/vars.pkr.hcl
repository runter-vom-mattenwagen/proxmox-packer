variable "proxmox_api_url" {
  type = string
  default = "https://pve-2.fritz.box:8006/api2/json"
}

variable "proxmox_node" {
  type = string
  default = "pve-2"
}

variable "ubuntu_image" {
  default = "ubuntu-24.04-live-server-amd64.iso"
}

variable "proxmox_password" {
  default = "terraform"
}

variable "proxmox_username" {
  default = "terraform-prov@pve"
}

variable "template_name" {
  default = "tpl-ul24.04-latest"
}
