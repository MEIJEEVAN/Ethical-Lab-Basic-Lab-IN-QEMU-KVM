#!/bin/bash

KALI_DISK="$HOME/vm-lab/kali/kali.qcow2"

if [ ! -f "$KALI_DISK" ]; then
  echo "❌ Kali disk not found at $KALI_DISK"
  exit 1
fi

echo "Select network mode:"
echo "1) Offline (Isolated lab with Metasploitable)"
echo "2) Online (Internet access via NAT)"
read -rp "Enter choice [1 or 2]: " choice

case "$choice" in
  1)
    echo "▶ Starting Kali in OFFLINE mode (isolated socket network)"
    qemu-system-x86_64 \
      -enable-kvm \
      -name KaliLinux \
      -cpu host \
      -smp 2 \
      -m 4096 \
      -drive file="$KALI_DISK",format=qcow2 \
      -netdev socket,id=labnet,connect=127.0.0.1:4567 \
      -device e1000,netdev=labnet,mac=52:54:00:aa:01:02 \
      -display default
    ;;
  2)
    echo "▶ Starting Kali in ONLINE mode (NAT internet)"
    qemu-system-x86_64 \
      -enable-kvm \
      -name KaliLinux \
      -cpu host \
      -smp 2 \
      -m 4096 \
      -drive file="$KALI_DISK",format=qcow2 \
      -netdev user,id=net0 \
      -device virtio-net-pci,netdev=net0 \
      -display default
    ;;
  *)
    echo "❌ Invalid choice. Use 1 or 2."
    exit 1
    ;;
esac

