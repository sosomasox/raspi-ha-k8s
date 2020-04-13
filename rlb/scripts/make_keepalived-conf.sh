#!/bin/bash

if [ $(whoami) != "pi" ]; then
    echo 'You are not pi user.'
    echo 'You need to be pi user authority to execute.'
    exit 1
fi

if [ $# -ne 1 ]; then
    echo "Usage: $0 VIRTUAL_IP_ADDRESS"
    exit 1
fi

if [ -f $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf ]; then
    mv -f $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf.bk
fi

VIRTUAL_IP_ADDRESS=$1

echo "vrrp_script chk_haproxy {"                    >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "    script   \"systemctl is-active haproxy\"" >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "    interval 1"                               >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "    rise     2"                               >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "    fall     3"                               >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "}"                                            >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo ""                                             >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "vrrp_instance HA-CLUSTER {"                   >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "    state BACKUP"                             >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "    nopreempt"                                >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "    interface eth0"                           >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "    virtual_router_id 1"                      >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "    priority 100"                             >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "    advert_int 1"                             >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "    virtual_ipaddress {"                      >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "        ${VIRTUAL_IP_ADDRESS}"                >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "    }"                                        >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "    track_script {"                           >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "        chk_haproxy"                          >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "    }"                                        >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf
echo "}"                                            >> $HOME/Build_HA_RasPi_K8s_Cluster/rlb/config/keepalived.conf

echo 'make keepalived.conf done.'

exit 0
