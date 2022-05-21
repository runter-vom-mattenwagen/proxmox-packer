#! /usr/bin/env bash

dnf install -y cloud-init qemu-guest-agent cloud-utils-growpart gdisk

echo "datasource_list: [ NoCloud, ConfigDrive ]" > /etc/cloud/cloud.cfg.d/99_pve.cfg

echo "Reboot in cloud.cfg eintragen"
cat <<'EOT' >> /etc/cloud/cloud.cfg

package_update: true

power_state:
  delay: "now"
  mode: reboot
  message: Neustart...
  timeout: 30
  condition: True
EOT

rm -f /var/run/utmp
rm -rf /tmp/* /var/tmp/*
unset HISTFILE; rm -rf /home/*/.*history /root/.*history
rm -f /root/*ks
# passwd -d root
# passwd -l root

echo "Disable NetworkManager-wait-online.service"
systemctl disable NetworkManager-wait-online.service

# cleanup current SSH keys so templated VMs get fresh key
rm -f /etc/ssh/ssh_host_*

# Avoid ~200 meg firmware package we don't need
# this cannot be done in the KS file so we do it here
echo "Removing extra firmware packages"
dnf -y remove linux-firmware
dnf -y autoremove

echo "Remove previous kernels that preserved for rollbacks"
dnf -y remove -y $(dnf repoquery --installonly --latest-limit=-1 -q)
dnf -y clean all  --enablerepo=\*;

echo "truncate any logs that have built up during the install"
find /var/log -type f -exec truncate --size=0 {} \;

echo "remove the install log"
rm -f /root/anaconda-ks.cfg /root/original-ks.cfg

echo "Force a new random seed to be generated"
rm -f /var/lib/systemd/random-seed

echo "Wipe netplan machine-id (DUID) so machines get unique ID generated on boot"
truncate -s 0 /etc/machine-id

echo "Clear the history so our install commands aren't there"
rm -f /root/.wget-hsts
export HISTSIZE=0
