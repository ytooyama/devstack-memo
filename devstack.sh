#!/bin/bash -x

rm -rf devstack
git clone -b stable/kilo https://git.openstack.org/openstack-dev/devstack

if [ -h devstack/local.conf ];
then
   echo "local.conf is found."
else
   ln -s ~/devstack-memo/local.conf devstack/local.conf
   echo "ln -s is done."
fi

echo "Run the stack.sh? Cancel:(ctrl+c)"
read confstack1
bash devstack/stack.sh

echo "Configure br-ex? Cancel:(ctrl+c)"
read confstack2
sudo ifconfig br-ex 0.0.0.0 && sudo ovs-vsctl add-port br-ex eth0
