#!/bin/bash -x
echo '################### userdata begins #####################'
touch ~opc/userdata.`date +%s`.start
# echo '########## update yum repos ###############'
sudo cd /etc/yum.repos.d/
sudo wget http://yum.oracle.com/public-yum-ol7.repo
echo '########## install and enable docker  ##############'
sudo yum install docker-engine
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
echo '###################userdata ends #######################'
~                                                                             
