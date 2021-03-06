#!/bin/bash

version=stable/mitaka

if [ -d devstack ];
then
  echo "devstack dir is found. Clone the New Sources."
  rm -rf devstack
  git clone -b $version https://git.openstack.org/openstack-dev/devstack
else
  echo "devstack dir is not found. Clone the Sources."
  git clone -b $version https://git.openstack.org/openstack-dev/devstack
fi

if [ -h devstack/local.conf ];
then
   echo "local.conf is found."
else
   ln -s ~/devstack-memo/local.conf devstack/local.conf
   echo "ln -s local.conf is done."
fi

echo "Run the stack.sh? Cancel:(ctrl+c)"
read confstack1
bash devstack/stack.sh