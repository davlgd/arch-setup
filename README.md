# Arch VM Installer

This repository contains scripts for installing Arch Linux in a (x86_64) virtual machine environment with EFI support.

## Description

The project is composed of two main scripts:

1. `init.sh`: Initializes the disk, downloads, and extracts Arch Linux base. It sets up disk partitioning, configures DNS and chroot.
2. `chrooted.sh`: Once in the chroot environment, this script configures the system, including setting the language, time zone, installs the Linux kernel and setup to boot loader.

## Prerequisites

- A virtual machine or an environment where you can execute bash scripts.
- An internet connection to download the necessary files.
- An [Arch ISO](https://archlinux.org/download/):
  - When you're in the shell as `root`, load your keyboard preferences (e.g. `loadkeys fr`)
  - Change the root password (`passwd`)
  - Show network configuration of the VM (`ip a`)
  - Connect from another machine if needed

To use `git` in an Arch Linux ISO you'll need to:
```
pacman -Sy
pacman -S git glibc
git clone <This repository URL>
```
Sometimes, the airootfs of the Live CD is not enough (`df -h` to check). You can wipe the storage device where you'll install Arch Linux and reboot (`wipefs -a /dev/device-name`). You can also use another Arch based Live CD, like [System Rescue](https://www.system-rescue.org/Download/). 
## Usage

1. **Preparation:**
   - Git clone to download the `init.sh` and `chrooted.sh` scripts to your working environment.
   - Go to the folder containing the scripts.
   - Ensure the scripts are executable (`chmod +x`).

2. **Executing the `./init.sh` script:**
   - This script will prepare your virtual hard disk and download Arch Linux.
   - Modify the variables in the script as needed (e.g., disk configuration).

3. **Chroot and Setup:**
   - After running `init.sh`, it will chroot into the Arch Linux environment.
   - `chrooted.sh` will configure the system, including kernel installation.

## Configuration

- The `chrooted.sh` script includes configuration options like hostname and locale.
- You can adjust these settings as needed before running the script.

## Support

For any questions or issues regarding these scripts, feel free to open an issue in this repository.