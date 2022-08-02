#! /usr/bin/env bash

echo "datasource_list: [ NoCloud, ConfigDrive ]" > /etc/cloud/cloud.cfg.d/99_pve.cfg

cat <<'EOT' >> /etc/cloud/cloud.cfg

package_update: true

power_state:
  delay: "now"
  mode: reboot
  message: Reboot...
  timeout: 30
  condition: True
EOT

rm -rf /tmp/* /var/tmp/* 
rm -f  /var/run/utmp

rm -f /etc/ssh/ssh_host_*

find /var/log -type f -exec truncate --size=0 {} \;
rm -f /var/lib/systemd/random-seed
unset HISTFILE; rm -rf /home/*/.*history /root/.*history
