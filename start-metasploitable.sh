#!/bin/bash

TARGET_DISK="$HOME/vm-lab/target/metasploitable.qcow2"

if [ ! -f "$TARGET_DISK" ]; then
  echo "❌ Metasploitable disk not found at $TARGET_DISK"
  exit 1
fi

echo "▶ Starting Metasploitable2 (isolated lab network)"

qemu-system-x86_64 \
  -enable-kvm \
  -name Metasploitable2 \
  -cpu host \
  -smp 1 \
  -m 1024 \
  -drive file="$TARGET_DISK",format=qcow2 \
  -netdev socket,id=labnet,listen=:4567 \
  -device e1000,netdev=labnet,mac=52:54:00:aa:01:01 \
  -display default
