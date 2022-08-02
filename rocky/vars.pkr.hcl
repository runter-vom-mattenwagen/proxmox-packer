variable "iso_image" {
    default = "Rocky-8.6-x86_64-minimal.iso"
}

variable "proxmox_password" {
  default = "packer"
}

variable "proxmox_username" {
  default = "packer@pam"
}

variable "template_name" {
  default = "tpl-rl8-latest"
}

variable "version" {
    default = ""
}
