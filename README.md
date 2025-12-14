# Ethical Hacking Basic Lab using QEMU + KVM

**Kali Linux (Attacker) + Metasploitable2 (Target)**

This repository explains how to set up a **minimal, fast, and safe ethical hacking lab** using **QEMU + KVM**.

No VirtualBox.
No VMware.
No bloated GUI hypervisors.

This lab is designed for **learning ethical hacking fundamentals** in an **isolated environment**.

---

## Lab Overview

* **Attacker VM**: Kali Linux
* **Target VM**: Metasploitable2
* **Hypervisor**: QEMU + KVM

The lab supports **two Kali networking modes**:

1. **Offline (Isolated Lab)**
   → Used for attacking Metasploitable
   → No internet access

2. **Online (NAT Internet)**
   → Used only for updates and tool installation
   → Metasploitable is NOT running

⚠️ **Metasploitable never gets internet access.**

---

## ⚠️ Legal & Safety Warning

* Metasploitable2 is **intentionally vulnerable**
* **Never expose it to the internet**
* **Never bridge it to your LAN**
* Use this lab **only for learning and ethical purposes**

If you don’t understand isolation, **do not improvise**.

---

## Lab Architecture

```
Kali Linux (Attacker)
        |
        |  (isolated socket network)
        |
Metasploitable2 (Target)
```

* **Offline mode** → socket networking (isolated)
* **Online mode** → user-mode NAT (Kali only)

---

## Requirements

* Linux environment (dual-boot or standalone)
* CPU with virtualization support (Intel VT-x / AMD-V)
* KVM enabled [Check the images in the code section]
* QEMU installed [Check the images in the code section]

Check KVM support:

```bash
lsmod | grep kvm
```

---

## Folder Structure

```
vm-lab/
├── kali/
│   └── kali.qcow2
├── target/
│   └── metasploitable.qcow2
├── scripts/
│   ├── start-kali.sh
│   └── start-metasploitable.sh
└── shared/
```

---

## Download Kali Linux (QEMU Image)

Download the **official prebuilt QEMU image** (`.qcow2`):

* Example filename:

  ```
  kali-linux-2025.3-qemu-amd64.qcow2
  ```

Download from:

```
https://www.kali.org/get-kali/#kali-virtual-machines
```

* No installer
* No ISO
* Boots instantly

Place it here:

```
vm-lab/kali/kali.qcow2
```

Kali login:

```
username: kali
password: kali
```

---

## Step 1 — Download Metasploitable2

Official Rapid7 source:

```
https://sourceforge.net/projects/metasploitable/files/Metasploitable2/
```

Download:

```
Metasploitable2-Linux.zip
```

---

## Step 2 — Extract the Disk

```bash
unzip ~/Downloads/Metasploitable2-Linux.zip -d ~/vm-lab/target/
```

Inside the folder, keep only:

```
Metasploitable2-Linux.vmdk
```

Delete everything else.

> The VMDK works directly in QEMU, but conversion is recommended.

---

## Step 3 — Convert VMDK to QCOW2 (Recommended)

QCOW2:

* Saves disk space
* Supports snapshots
* Better QEMU integration

Convert:

```bash
qemu-img convert -f vmdk \
~/vm-lab/target/Metasploitable2-Linux.vmdk \
-O qcow2 \
~/vm-lab/target/metasploitable.qcow2
```

Remove the original file:

```bash
rm ~/vm-lab/target/Metasploitable2-Linux.vmdk
```

Final file:

```
vm-lab/target/metasploitable.qcow2
```

Metasploitable login:

```
username: msfadmin
password: msfadmin
```

---

## Running VMs Individually (Standalone)

These commands run the VMs **separately**, without connecting them.

### Kali (with Internet)

```bash
qemu-system-x86_64 \
  -enable-kvm \
  -name Kali \
  -cpu host \
  -smp 2 \
  -m 4096 \
  -drive file=~/vm-lab/kali/kali.qcow2,format=qcow2 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -device e1000,netdev=net0
```

---

### Metasploitable (Standalone)

```bash
qemu-system-x86_64 \
  -enable-kvm \
  -name Metasploitable2 \
  -cpu host \
  -m 1024 \
  -drive file=~/vm-lab/target/metasploitable.qcow2,format=qcow2 \
  -nic user,hostfwd=tcp::2223-:22 \
  -display default
```

At this stage:

* Both VMs work
* **No connection between them**

---

## Static IP Configuration (For Isolated Lab)

This is required **only** when running the lab in **offline / isolated mode** using scripts.

---

### Metasploitable2

Edit:

```bash
sudo nano /etc/network/interfaces
```

Add:

```ini
auto eth0
iface eth0 inet static
    address 10.0.0.1
    netmask 255.255.255.0
```

Save and reboot.

---

### Kali Linux
Method 1:

Kali uses **NetworkManager**.

Configure static IP using `nmcli`:

```bash
nmcli con show
```

Then:

```bash
nmcli con mod "Wired connection 1" ipv4.method manual \
ipv4.addresses 10.0.0.2/24

nmcli con up "Wired connection 1"
```

Verify:

```bash
ip a
```
Method 2:
Edit:

```bash
sudo nano /etc/network/interfaces
```

Add:
```bash
auto eth0
iface eth0 inet static
    address 10.0.0.2
    netmask 255.255.255.0
```

Save and reboot.
---

## Startup Scripts (Recommended)

Use the provided scripts to run the **isolated lab correctly**.

Make them executable:

```bash
chmod +x scripts/start-kali.sh
chmod +x scripts/start-metasploitable.sh
```

* Start **Metasploitable first**
* Start **Kali → choose Offline mode**

---

## Usage Rules (Important)

* Use **offline mode** when attacking Metasploitable
* Use **online mode** only for updates
* Never run Metasploitable with internet access
* Do not bridge these VMs to your LAN

---

## Final Notes

This setup is:

* Lightweight
* Fast
* Safe
* Scriptable
* Beginner-friendly **if followed exactly**

If something doesn’t work, don't jump to exploits — **fix your Linux and networking basics first**.

That's how real learning happens.
