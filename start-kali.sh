#!/bin/bash

KALI_DISK="$HOME/vm-lab/kali/kali.qcow2"

echo "Select network mode:"
echo "1) Offline (Metasploitable / isolated lab)"
echo "2) Online (Internet access)"
read -p "Enter choice [1 or 2]: " choice

case $choice in
  1)
    echo "Starting Kali in OFFLINE mode (socket networking)"
    qemu-system-x86_64 \
      -enable-kvm \
      -name KaliLinux \
      -cpu host \
      -smp 2 \
      -m 2048 \
      -drive file="$KALI_DISK",format=qcow2 \
      -nic socket,connect=127.0.0.1:4567,mac=52:54:00:12:34:02
    ;;
  2)
    echo "Starting Kali in ONLINE mode (NAT internet)"
    qemu-system-x86_64 \
      -enable-kvm \
      -name KaliLinux \
      -cpu host \
      -smp 2 \
      -m 2048 \
      -drive file="$KALI_DISK",format=qcow2 \
      -netdev user,id=net0 \
      -device virtio-net-pci,netdev=net0
    ;;
  *)
    echo "Invalid choice. Use 1 or 2."
    exit 1
    ;;
esac

