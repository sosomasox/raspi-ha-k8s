#!/bin/bash

if [ $(whoami) != "root" ]; then
    echo 'You are not root.'
    echo 'You need to be root authority to execute.'
    exit 1
fi

kubeadm reset -f
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
chmod +x /home/pi/Build_HA_RasPi_K8s_Cluster/scripts/clean_network_if.sh
/home/pi/Build_HA_RasPi_K8s_Cluster/scripts/clean_network_if.sh
rm -rf /home/pi/.kube

echo 
echo 'demolish done.'
echo 'You should reboot your Raspberry Pi.'

exit 0
