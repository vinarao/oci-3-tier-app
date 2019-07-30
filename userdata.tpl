#!/bin/bash -x
echo '################### userdata begins #####################'
touch ~opc/userdata.`date +%s`.start
echo "start" > /tmp/log
# echo '########## update yum repos ###############'
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
echo '########## install and enable docker  ##############'
sudo yum -y install docker-ce
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
echo '###################userdata ends #######################'
