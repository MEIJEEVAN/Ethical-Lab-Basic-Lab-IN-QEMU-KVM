#!/bin/bash
qemu-system-x86_64 \
  -enable-kvm \
  -name Metasploitable2 \
  -cpu host \
  -smp 1 \
  -m 1024 \
  -drive file=$HOME/vm-lab/target/metasploitable.qcow2,format=qcow2 \
  -nic socket,listen=:4567,mac=52:54:00:aa:01:01
