#!/bin/bash

# Script to setup Arch Linux in a simple virtual machine

# Wipe the disk
# Define the partition layout
# - EFI partition of 512M, type EFI System
# - Root partition with the remaining space, type Linux filesystem

# Set the target device, show usage if more than one argument or --help is given
DISK="/dev/sda"

if [ $# -gt 1 ] || [[ $1 == "--help" ]]; then
echo "Arch Setup - Arch Linux Installation Script"
echo "Usage:"
echo "  ./init.sh <device>    - Installs Arch Linux on the specified device."
echo "  ./init.sh             - Installs Arch Linux on /dev/sda by default."
echo ""
echo "Options:"
echo "  <device>    - The target device for Arch Linux installation."
echo "                Example: ./init.sh /dev/nvme0n1"
echo ""
echo "Description:"
echo "  Arch Setup is a simple script to automate the installation of Arch Linux."
echo "  It can be run with a specific target device or without any arguments,"
echo "  in which case it will use /dev/sda as the default installation target."
echo ""
echo "  WARNING: This script will format the target device and install Arch Linux."
echo "           Make sure to back up any important data on the device before proceeding."
echo ""
echo "For more information on Arch Linux installation, visit:"
echo "https://github.com/davlgd/arch-setup"
exit
elif [ $# -eq 1 && -b $1 ]; then
    DISK=$1
fi

wipefs -a ${DISK}

echo "label: gpt"   | sfdisk -W always ${DISK}
echo ", 512M, U"    | sfdisk -W always -a ${DISK}
echo ","            | sfdisk -W always -a ${DISK}

# Create the filesystems
# - FAT32 for the EFI partition
# - ext4 for the root partition
# - Label the partitions
mkfs.fat -F 32 ${DISK}1 -n EFI
fatlabel ${DISK}1 EFI
mkfs.ext4 ${DISK}2 -L Arch
e2label ${DISK}2 Arch

# Create the mountpoint and mount them
mkdir /mnt/arch/
mount /dev/disk/by-label/Arch /mnt/arch
mkdir /mnt/arch/boot/
mount /dev/disk/by-label/EFI /mnt/arch/boot

# Set date/time and sync the repositories
timedatectl set-ntp true
pacman -Sy --noconfirm

# Install the base system
pacstrap /mnt/arch base base-devel linux linux-firmware

# Generate the fstab file
genfstab -U /mnt/arch >> /mnt/arch/etc/fstab

# Copy the script to the new system
cp chrooted.sh /mnt/arch/

# chroot into the new system and then reboot
arch-chroot /mnt/arch /bin/bash chrooted.sh