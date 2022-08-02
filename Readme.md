# Using Packer for creating a Proxmox template

## Preparation

- have a working Proxmox server
- download the installation image from https://rockylinux.org/download resp. https://ubuntu.com/download/server
- upload the iso file to the iso directory of your Proxmox server
- install or download download packer according to: https://www.packer.io/downloads
- clone this Git repo to your Linux box.
- navigate to the directory with the configuration files

Modify the following files to your needs:

### packer.pkr.hcl - main configuration file for creating the template VM

- The parameters are documented on the plugin page: https://www.packer.io/plugins/builders/proxmox/iso
- After the successful creation of the VM, the shell-provisioner starts the setup.sh
- check the values if they meet your needs
- some values are variables which are assigned in...

### vars.pkr.hcl - assingment of variables used in packer.pkr.hcl

- "iso_image" must match the name of your iso file on proxmox
- "proxmox_password"/"proxmox_username": A Proxmox user that can create VMs
- "template_name": How the VM should be named

### Rockylinux: ks.cfg - Kickstart file

- automates the installation process
- Ansible-part contains invalid ssh-key. Add your own :-)
- note that "repo --name=" must match your version of RockyLinux
- content is also result of searching the internet

### Ubuntu: http/user-data

- cloud-init based autoinstall
- Identity must match username/password in packer.pkr.hcl
- Reference: https://ubuntu.com/server/docs/install/autoinstall-reference

### setup.sh - post-configuration

- will be executed after the 1st start of VM within the templating process
- Cloud-init part forces update and restart after creation a VM
- content is stolen from different sources on the internet and the result of my own fiddling


## Build the image

```
~$ packer init .
~$ packer build .
```

## Next steps 

- create a VM from the template by using Terraform or the builtin functionality of Proxmox
- use the login you've set in ks.cfg resp. user-data to enter the new VM

## Resources

A lot of inspiration comes from the home of Rocky Linux: https://docs.rockylinux.org/guides/automation/templates-automation-packer-vsphere/
