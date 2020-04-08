#!/bin/bash

if [ $(whoami) != "root" ]; then
    echo 'You are not root.'
    echo 'You need to be root authority to execute.'
    exit 1
fi

if [ $# -lt 1 ]; then
    echo "Usage: $0 ANOTHER_CONTROL_PLANE_NODES_IP_ADDRESS..."
    exit 1
fi

kubeadm reset -f
kubeadm init --config=/home/pi/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml

rm -rf /home/pi/.kube
sudo -u pi mkdir -p /home/pi/.kube
cp -i /etc/kubernetes/admin.conf /home/pi/.kube/config
chown pi:pi /home/pi/.kube/config

sleep 60
sudo -u pi kubectl apply -f /home/pi/Build_RasPi_Kubernetes_Cluster/cni/kube-flannel_v0.12.0-arm.yaml
sleep 30

chmod +x /home/pi/Build_HA_RasPi_K8s_Cluster/scripts/set_certs.sh
/home/pi/Build_HA_RasPi_K8s_Cluster/scripts/set_certs.sh $@

echo 'done init.'

exit 0
