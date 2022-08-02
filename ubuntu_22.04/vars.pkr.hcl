variable "ubuntu_image" {
  default = "ubuntu-22.04-live-server-amd64.iso"
}

variable "proxmox_password" {
  default = "terraform"
}

variable "proxmox_username" {
  default = "terraform@pam"
}

variable "template_name" {
  default = "tpl-ul22.04-latest"
}

variable "version" {
    default = ""
}
