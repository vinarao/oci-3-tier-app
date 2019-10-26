#!/bin/bash -x
echo '################### userdata begins #####################'
touch ~opc/userdata.`date +%s`.start
echo "start" > /tmp/log
# echo '########## update yum repos ###############'
sudo yum -y install nc
sudo firewall-cmd --zone=public --permanent --add-port=3306/tcp 
sudo firewall-cmd --reload
echo '###################userdata ends #######################'
