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

if [ -f $HOME/raspi-ha-k8s/rlb/config/keepalived.conf ]; then
    mv -f $HOME/raspi-ha-k8s/rlb/config/keepalived.conf $HOME/raspi-ha-k8s/rlb/config/keepalived.conf.bk
fi

VIRTUAL_IP_ADDRESS=$1

echo "vrrp_script chk_haproxy {"                    >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "    script   \"systemctl is-active haproxy\"" >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "    interval 1"                               >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "    rise     2"                               >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "    fall     3"                               >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "}"                                            >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo ""                                             >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "vrrp_instance HA-CLUSTER {"                   >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "    state BACKUP"                             >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "    nopreempt"                                >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "    interface eth0"                           >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "    virtual_router_id 1"                      >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "    priority 100"                             >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "    advert_int 1"                             >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "    virtual_ipaddress {"                      >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "        ${VIRTUAL_IP_ADDRESS}"                >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "    }"                                        >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "    track_script {"                           >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "        chk_haproxy"                          >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "    }"                                        >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf
echo "}"                                            >> $HOME/raspi-ha-k8s/rlb/config/keepalived.conf

echo 'make keepalived.conf done.'

exit 0
