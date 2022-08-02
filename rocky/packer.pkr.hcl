source "proxmox" "autogenerated_1" {
  boot_command = ["<tab> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"]
  boot_wait    = "10s"
  disks {
    disk_size         = "6G"
    format            = "raw"
    storage_pool      = "local-lvm"
    storage_pool_type = "lvm-thin"
    type              = "scsi"
  }
  http_directory           = "."
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
  proxmox_url             = "https://pve.home.local:8006/api2/json"
  scsi_controller         = "virtio-scsi-single"
  ssh_password            = "Packer"
  ssh_timeout             = "25m"
  ssh_username            = "root"
  template_description    = "From ${var.rocky_image}\nCreated {{ isotime \"2006-01-02T15:04:05Z\"}}"
  template_name           = "${var.template_name}"
  unmount_iso             = true
  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"
}

build {
  sources = ["source.proxmox.autogenerated_1"]

  provisioner "shell" {
    script = "./setup.sh"

  }
}
