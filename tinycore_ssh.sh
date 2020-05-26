#!/bin/sh

tce-load -wi openssh
cd /usr/local/etc/ssh
sudo cp ssh_config.orig ssh_config
sudo cp sshd_config.orig sshd_config
sudo /usr/local/etc/init.d/openssh start
passwd
sudo netstat anp | grep 22
sudo echo '/usr/local/etc/ssh' >> /opt/.filetool.lst 
sudo echo '/etc/shadow' >> /opt/.filetool.lst
filetool.sh -b
sudo echo '/usr/local/etc/init.d/openssh start &' >> /opt/bootlocal.sh
