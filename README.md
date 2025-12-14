# Ethical-Lab-Basic-Lab-IN-QEMU-KVM

Hi! guys this is about setting up a minimal lab to learn ethical hacking via Kali Linux and Metasploitable Vms
1) Creating QEMU + KVM setup

   
2) Installing and Running Kali and Metasploitable vms

sample folder structure:
vm-lab/
├── isos/
│   ├── ubuntu.iso
│   └── other.iso files...
├── kali/
│   └── kali.qcow2
├── target/
│   └── target.qcow2
└── shared/

Download the Kali Virtual Machine Image (QEMU version)

Get the official pre-built QEMU image from Kali (”.qcow2” format).
Filename looks like: kali-linux-2025.3-qemu-amd64.qcow2

This one boots instantly. No installer. No ISO.
Put the file in the folder u use.

Step 1 — Download Metasploitable 2
Get the VM ZIP from Rapid7 (official):
https://sourceforge.net/projects/metasploitable/files/Metasploitable2/
Download Metasploitable2-Linux.zip from it.

Step 2 — Extract the Disk
Extract it:
unzip ~/Downloads/Metasploitable2-Linux.zip -d ~/vm-lab/target/

Inside the folder, you’ll see: Metasploitable2-Linux.vmdk
Delete the rest except vmdk one.

This VMDK works directly in QEMU — no conversion needed.

Optional (recommended): convert VMDK → QCOW2
QCOW2 saves disk space and supports snapshots.
Run:

qemu-img convert -f vmdk ~/vm-lab/target/Metasploitable2-Linux.vmdk -O qcow2 ~/vm-lab/target/metasploitable.qcow

After conversion:

rm ~/vm-lab/target/Metasploitable2-Linux.vmdk

Now your folder has: metasploitable.qcow2

while running kali and Metasploitable ensure the file name and path to the file is given correctly..

Running normally both (we are running both seperately here..)
kali:
qemu-system-x86_64 \
  -enable-kvm \
  -name "Kali" \
  -cpu host \
  -smp 2 \
  -m 4096 \
  -drive file=~/vm-lab/kali/kali.qcow2,format=qcow2 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -device e1000,netdev=net0

Login: kali  password:kali

Metasploitable:
qemu-system-x86_64 \
  -enable-kvm \
  -name "Metasploitable2" \
  -cpu host \
  -m 1024 \
  -drive file=~/vm-lab/target/metasploitable.qcow2,format=qcow2 \
  -nic user,hostfwd=tcp::2223-:22 \
  -display default

Inside Metasploitable:
username: msfadmin
password: msfadmin


Just watch any tutorial in YouTube to setup kali after running the virtual machine.
and try to update and stuff and explore .. in both vms.
Right now there is no connection between both vms.
use the scripts attached to run both vms with connection to properly use them.

before that follow the next step..
3) Make the IPs permanent inside the VMs to connect

In Metasploitable:
Edit its network config:
sudo nano /etc/network/interfaces

Add:
auto eth0
iface eth0 inet static
    address 10.0.0.1
    netmask 255.255.255.0

-->Save and reboot.

In Kali:
Edit its network config:
sudo nano /etc/network/interfaces.d/eth0

Add:
auto eth0
iface eth0 inet static
    address 10.0.0.2
    netmask 255.255.255.0

-->Save and reboot.

After this, eth0 comes up with the same IP automatically every boot.
use $ ip a to check.

4) Scripts to make it easy to use

download the .sh file and use chmod +x msf.sh start-kali.sh
chmod +x msf.sh start-metasploitable.sh to make it executable.

while using metasploitable use kali without internet...
otherwise use kali with internet.
