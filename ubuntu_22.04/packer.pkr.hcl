source "proxmox" "ubuntu" {

  boot_wait    = "7s"

  boot_command        = [
                         "c<wait>",
                         "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ",
                         "<enter><wait><wait>",
                         "initrd /casper/initrd<enter><wait><wait>",
                         "boot<enter>"
                        ]

  disks {
    disk_size         = "6G"
    format            = "raw"
    storage_pool      = "local-lvm"
    storage_pool_type = "lvm-thin"
    type              = "scsi"
  }
  http_directory           = "http"
  insecure_skip_tls_verify = true
  iso_file                 = "local:iso/${var.iso_image}"
  memory                   = "1024"
  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }
  node                    = "pve"
  os                      = "l26"
  username                = "${var.proxmox_username}"
  password                = "${var.proxmox_password}"
  proxmox_url             = "https://pve.fritz.box:8006/api2/json"
  scsi_controller         = "virtio-scsi-single"
  ssh_password            = "ubuntu"
  ssh_username            = "ubuntu"
  ssh_timeout             = "25m"
  template_description    = "From ${var.ubuntu_image}\nCreated {{ isotime \"2006-01-02T15:04:05Z\"}}"
  template_name           = "${var.template_name}"
  unmount_iso             = true
  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"
}

build {
  sources = ["source.proxmox.ubuntu"]

  provisioner "shell" {
     execute_command = "echo 'ubuntu' | sudo -S env {{ .Vars }} {{ .Path }}"
     scripts         = [
       "setup.sh"
     ]
  }
}
