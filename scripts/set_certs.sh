#!/bin/bash

if [ $(whoami) != "root" ]; then
    echo 'You are not root.'
    echo 'You need to be root authority to execute.'
    exit 1
fi

if [ $# -lt 1 ]; then
    echo "Usage: $0 CONTROL_PLANE_NODES_IP_ADDRESS..."
    exit 1
fi

USER=pi

cp -f /etc/kubernetes/pki/ca.crt             /home/pi/raspi-ha-k8s/certs/ca.crt
cp -f /etc/kubernetes/pki/ca.key             /home/pi/raspi-ha-k8s/certs/ca.key
cp -f /etc/kubernetes/pki/sa.key             /home/pi/raspi-ha-k8s/certs/sa.key
cp -f /etc/kubernetes/pki/sa.pub             /home/pi/raspi-ha-k8s/certs/sa.pub
cp -f /etc/kubernetes/pki/front-proxy-ca.crt /home/pi/raspi-ha-k8s/certs/front-proxy-ca.crt
cp -f /etc/kubernetes/pki/front-proxy-ca.key /home/pi/raspi-ha-k8s/certs/front-proxy-ca.key
cp -f /etc/kubernetes/pki/etcd/ca.crt        /home/pi/raspi-ha-k8s/certs/etcd-ca.crt
cp -f /etc/kubernetes/pki/etcd/ca.key        /home/pi/raspi-ha-k8s/certs/etcd-ca.key
cp -f /etc/kubernetes/admin.conf             /home/pi/raspi-ha-k8s/certs/admin.conf

chown pi:pi /home/pi/raspi-ha-k8s/certs/ca.crt
chown pi:pi /home/pi/raspi-ha-k8s/certs/ca.key
chown pi:pi /home/pi/raspi-ha-k8s/certs/sa.key
chown pi:pi /home/pi/raspi-ha-k8s/certs/sa.pub
chown pi:pi /home/pi/raspi-ha-k8s/certs/front-proxy-ca.crt
chown pi:pi /home/pi/raspi-ha-k8s/certs/front-proxy-ca.key
chown pi:pi /home/pi/raspi-ha-k8s/certs/etcd-ca.crt
chown pi:pi /home/pi/raspi-ha-k8s/certs/etcd-ca.key
chown pi:pi /home/pi/raspi-ha-k8s/certs/admin.conf

for host in $@; do
    sudo -u pi scp /home/pi/raspi-ha-k8s/certs/ca.crt             "${USER}"@$host:raspi-ha-k8s/certs/
    sudo -u pi scp /home/pi/raspi-ha-k8s/certs/ca.key             "${USER}"@$host:raspi-ha-k8s/certs/
    sudo -u pi scp /home/pi/raspi-ha-k8s/certs/sa.key             "${USER}"@$host:raspi-ha-k8s/certs/
    sudo -u pi scp /home/pi/raspi-ha-k8s/certs/sa.pub             "${USER}"@$host:raspi-ha-k8s/certs/
    sudo -u pi scp /home/pi/raspi-ha-k8s/certs/front-proxy-ca.crt "${USER}"@$host:raspi-ha-k8s/certs/
    sudo -u pi scp /home/pi/raspi-ha-k8s/certs/front-proxy-ca.key "${USER}"@$host:raspi-ha-k8s/certs/
    sudo -u pi scp /home/pi/raspi-ha-k8s/certs/etcd-ca.crt        "${USER}"@$host:raspi-ha-k8s/certs/
    sudo -u pi scp /home/pi/raspi-ha-k8s/certs/etcd-ca.key        "${USER}"@$host:raspi-ha-k8s/certs/
    sudo -u pi scp /home/pi/raspi-ha-k8s/certs/admin.conf         "${USER}"@$host:raspi-ha-k8s/certs/
    sudo -u pi ssh -t "${USER}"@$host "chmod +x raspi-ha-k8s/scripts/cp_certs.sh"
    sudo -u pi ssh -t "${USER}"@$host "sudo raspi-ha-k8s/scripts/cp_certs.sh"

done

echo 'set certs done.'

exit 0
