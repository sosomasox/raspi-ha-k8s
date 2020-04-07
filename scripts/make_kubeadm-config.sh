#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 ENDPOINT_ADDRESS ENDPOINT_PORT"
    exit 1
fi

ENDPOINT_ADDR=$1
ENDPOINT_PORT=$2

if [ -f $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml ]; then
    mv -f $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml.bk
fi

echo "apiVersion: kubeadm.k8s.io/v1beta1"                          >  $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "kind: ClusterConfiguration"                                  >> $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "kubernetesVersion: v1.13.5"                                  >> $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "apiServer:"                                                  >> $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "  certSANs:"                                                 >> $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "  - \"192.168.3.240\""                                       >> $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "controlPlaneEndpoint: \"${ENDPOINT_ADDR}:${ENDPOINT_PORT}\"" >> $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "networking:"                                                 >> $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml
echo "  podSubnet: 10.244.0.0/16"                                  >> $HOME/Build_HA_RasPi_K8s_Cluster/manifests/kubeadm-config.yaml

echo "Done."

exit 0
