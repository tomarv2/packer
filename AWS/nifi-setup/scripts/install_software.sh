#!/bin/bash
sudo yum -y update
sudo yum install -y cloud-init \
                    vim \
                    git \
                    java-1.8.0-openjdk \
                    sudo \
                    python \
                    wget \
                    nmap \
                    nc \
                    sudo

sudo wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y ./epel-release-latest-*.noarch.rpm
sudo yum install -y python-pip

# Setup NiFi user
sudo groupadd -g 2000 nifi #|| groupmod -n nifi `getent group 1000 | cut -d: -f1`
sudo mkdir -p /opt/nifi/1.2.0/nifi-1.2.0
sudo adduser -u 2000  -g 2000 --shell /bin/sh --home /opt/nifi/1.2.0/nifi-1.2.0 nifi
sudo echo 'nifi ALL=(ALL)NOPASSWD:ALL' >> /etc/sudoers

# Download, validate, and expand Apache NiFi binary.
sudo curl -fSL https://archive.apache.org/dist/nifi/1.2.0/nifi-1.2.0-bin.tar.gz -o /opt/nifi/1.2.0/nifi-1.2.0-bin.tar.gz \
	&& echo "$(curl https://archive.apache.org/dist/nifi/1.2.0/nifi-1.2.0-bin.tar.gz.sha256) */opt/nifi/1.2.0/nifi-1.2.0-bin.tar.gz" | sha256sum -c -
sudo tar -xvzf /opt/nifi/1.2.0/nifi-1.2.0-bin.tar.gz -C /opt/nifi/1.2.0
sudo rm /opt/nifi/1.2.0/nifi-1.2.0-bin.tar.gz

pip install awscli --upgrade --user

#hostname_id=`cat /etc/hostname|cut -f 3 -d '-'`
#sudo echo $(expr $hostname_id + 1) > /opt/nifi/nifi-1.2.0/conf/state/zookeeper/myid
#su nifi -c '/opt/nifi/1.2.0/nifi-1.2.0/bin/nifi.sh run'