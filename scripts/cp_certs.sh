#!/bin/bash

if [ $(whoami) != "root" ]; then
    echo 'You are not root.'
    echo 'You need to be root authority to execute.'
    exit 1
fi

mkdir -p /etc/kubernetes/pki/etcd
cp -f /home/pi/raspi-ha-k8s/certs/ca.crt             /etc/kubernetes/pki/
cp -f /home/pi/raspi-ha-k8s/certs/ca.key             /etc/kubernetes/pki/
cp -f /home/pi/raspi-ha-k8s/certs/sa.pub             /etc/kubernetes/pki/
cp -f /home/pi/raspi-ha-k8s/certs/sa.key             /etc/kubernetes/pki/
cp -f /home/pi/raspi-ha-k8s/certs/front-proxy-ca.crt /etc/kubernetes/pki/
cp -f /home/pi/raspi-ha-k8s/certs/front-proxy-ca.key /etc/kubernetes/pki/
cp -f /home/pi/raspi-ha-k8s/certs/etcd-ca.crt        /etc/kubernetes/pki/etcd/ca.crt
cp -f /home/pi/raspi-ha-k8s/certs/etcd-ca.key        /etc/kubernetes/pki/etcd/ca.key
cp -f /home/pi/raspi-ha-k8s/certs/admin.conf         /etc/kubernetes/admin.conf
chown -R root:root /etc/kubernetes/

echo 'cp certs done.'

exit 0
