packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "ubuntu" {

  proxmox_url               = "${var.proxmox_api_url}"
  username                  = "${var.proxmox_username}"
  password                  = "${var.proxmox_password}"

  node                      = "${var.proxmox_node}"
  template_description      = "From ${var.ubuntu_image}\nCreated {{ isotime \"2006-01-02T15:04:05Z\"}}"
  template_name             = "${var.template_name}"
  tags                      = "ubuntu;template"
  os                        = "l26"

  iso_file                  = "local:iso/${var.ubuntu_image}"
  unmount_iso               = true
  qemu_agent                = true

  scsi_controller           = "virtio-scsi-pci"
  disks {
    disk_size               = "6G"
    format                  = "raw"
    storage_pool            = "local-lvm"
    type                    = "scsi"
  }

  network_adapters {
    model                   = "virtio"
    bridge                  = "vmbr0"
  }

  memory                    = "2048"

  cloud_init                = true
  cloud_init_storage_pool   = "local-lvm"

  boot_command = [
    "<esc><wait>",
    "e<wait>",
    "<down><down><down><end>",
    "<bs><bs><bs><bs><wait>",
    "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
    "<f10><wait>"
  ]
  boot_wait                 = "6s"

  http_directory            = "http"
  insecure_skip_tls_verify  = true

  ssh_username              = "ubuntu"
  ssh_password              = "ubuntu"
  ssh_timeout               = "30m"
}

build {

  name    = "ubuntu"
  sources = ["proxmox-iso.ubuntu"]

  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo rm -f /etc/netplan/00-installer-config.yaml",
      "sudo sync"
    ]
  }

  provisioner "file" {
    source      = "files/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }

  provisioner "shell" {
    inline = ["sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg"]
  }

}
