#!/bin/bash

if [ $(whoami) != "pi" ]; then
    echo 'You are not pi user.'
    echo 'You need to be pi user authority to execute.'
    exit 1
fi

if [ $# -ne 2 ]; then
    echo "Usage: $0 ENDPOINT_ADDRESS ENDPOINT_PORT"
    exit 1
fi

ENDPOINT_ADDR=$1
ENDPOINT_PORT=$2

if [ -f /home/pi/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml ]; then
    mv -f /home/pi/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml /home/pi/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml.bk
fi

echo "apiVersion: kubeadm.k8s.io/v1beta1"                          >> /home/pi/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "kind: ClusterConfiguration"                                  >> /home/pi/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "kubernetesVersion: v1.13.5"                                  >> /home/pi/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "apiServer:"                                                  >> /home/pi/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "  certSANs:"                                                 >> /home/pi/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "  - \"${ENDPOINT_ADDR}\""                                    >> /home/pi/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "controlPlaneEndpoint: \"${ENDPOINT_ADDR}:${ENDPOINT_PORT}\"" >> /home/pi/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "networking:"                                                 >> /home/pi/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "  podSubnet: 10.244.0.0/16"                                  >> /home/pi/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml

echo "done make kubeadm-config."

exit 0
