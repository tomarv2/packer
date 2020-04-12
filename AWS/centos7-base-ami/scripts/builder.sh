#!/bin/bash

### Global Configuration ###

#sudo bash -c "echo 'preserve_hostname: true' >> /etc/cloud/cloud.cfg"
sudo bash -c "setenforce 0; sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config"
sudo bash -c "echo 'prepend domain-name-servers 10.10.8.17;' >> /etc/dhcp/dhclient.conf"
sudo bash -c "echo 'prepend domain-search \"demo.com\";' >> /etc/dhcp/dhclient.conf"

### Add public key for root@master.aur ###
sudo bash -c "mkdir -p /root/.ssh; chmod 700 /root/.ssh;"
sudo bash -c "echo 'ssh-rsa AAAA== root@master.demo.com' > /root/.ssh/authorized_keys"

### Disable IPv6 ###
sudo bash -c "sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/d' /etc/default/grub"
sudo bash -c "echo 'GRUB_CMDLINE_LINUX_DEFAULT=\"ipv6.disable=1\"' >> /etc/default/grub"
sudo bash -c "grub2-mkconfig -o /boot/grub2/grub.cfg"

### Setup repos and install softwares ###
sudo bash -c "cat >/etc/yum.repos.d/salt-latest.repo <<'EOF'
[saltstack-repo]
name=SaltStack repo for Red Hat Enterprise Linux \$releasever
baseurl=https://repo.saltstack.com/yum/redhat/\$releasever/\$basearch/latest
enabled=1
gpgcheck=0
EOF
"

sudo yum update -y
sudo yum -y update
sudo yum install -y epel-release
sudo yum install -y net-tools \
  cloud-init \
  vim \
  git \
  unzip \
  python \
  wget \
  rsync \
  nmap \
  nc \
  python-pip \
  salt-minion \
  awscli

### Salt ###
sudo bash -c "cat > /etc/salt/minion << 'EOF'
hash_type: sha256
log_level: warning
master: 10.100.198.20
EOF
"
sudo bash -c "cat > /etc/salt/grains << 'EOF'
env: aws.test
EOF
"
sudo systemctl enable salt-minion

### Cleanup ###
sudo yum clean all
sudo rm -rf /var/cache/yum
sudo rm -rf /tmp/*
sudo bash -c "find /var/log -type f -exec bash -c '>{}' \;"
