#!/bin/bash

USER="davlgd"
KEYMAP="fr"
GRUB_TIMEOUT=0
LANG="fr_FR.UTF-8"
CPU_CORES=$(nproc)
HOSTNAME="archvm"

# Set the PS1 variable to distinguish the chrooted environment
source /etc/profile
PS1="(Arch) $PS1"

# Define regional and network settings
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc --utc

echo "${LANG} UTF-8" > /etc/locale.gen
echo "LANG={LANG}" > /etc/locale.conf
echo "KEYMAP=fr" > /etc/vconsole.conf
locale-gen

echo "${HOSTNAME}" > /etc/hostname
echo "127.0.0.1 ${HOSTNAME}.local ${HOSTNAME} localhost" > /etc/hosts
echo "::1 ${HOSTNAME}.local ${HOSTNAME} localhost" >> /etc/hosts

# Configure the DNS resolvers
echo 'nameserver 1.1.1.1
nameserver 9.9.9.9' > /etc/resolv.conf

# Define a new sudo user and set its password 
useradd -m -G wheel -s /bin/bash ${USER}
echo "${USER} ALL=(ALL) ALL" > /etc/sudoers.d/${USER}
chmod 440 /etc/sudoers.d/${USER}
echo
echo "Account created for ${USER}, please define its password:"
passwd ${USER}

# Set the login message
echo '

 █████╗ ██████╗  ██████╗██╗  ██╗    ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗
██╔══██╗██╔══██╗██╔════╝██║  ██║    ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝
███████║██████╔╝██║     ███████║    ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ 
██╔══██║██╔══██╗██║     ██╔══██║    ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ 
██║  ██║██║  ██║╚██████╗██║  ██║    ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗
╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝
                                                         

\S{ANSI_COLOR}\S{PRETTY_NAME}\e[0m - \n.\O, \s \r, \m
Logged Users: \U
\d, \t

' > /etc/issue

# Add some packages
pacman -Syu --noconfirm
pacman -S --noconfirm grub efibootmgr os-prober linux-headers dhcpcd git nano neofetch openssh

# Setup the bootloader, with no timeout
echo "set timeout=${GRUB_TIMEOUT}" >> /etc/grub.d/40_custom 
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Enable network services at boot
systemctl enable sshd
systemctl enable dhcpcd

# It's the end my friend!
exit

echo '
cd / && umount -R /mnt/exherbo
umount -l /mnt/exherbo
reboot'