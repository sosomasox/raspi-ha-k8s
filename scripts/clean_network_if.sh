#!/bin/bash

if [ $(whoami) != "root" ]; then
    echo 'You are not root.'
    echo 'You need to be root authority to execute.'
    exit 1
fi

ip link del flannel.1
ip link del cni0

echo 'done clean network interface.'

exit 0
