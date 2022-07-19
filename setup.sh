#!/bin/bash
#github-action genshdoc
#

sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 8/' /etc/pacman.conf
sed -i 's/SigLevel    = Required DatabaseOptional/SigLevel = Never/' /etc/pacman.conf
sed -i 's/LocalFileSigLevel/#LocalFileSigLevel/' /etc/pacman.conf

sed -i 's/MODULES=()/MODULES=(btrfs)'
mkinitcpio -p linux

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc

sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo KEYPMAP=br-abnt > /etc/vconsole.conf
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo VortexOS > /etc/hostname

echo root:Linux | chpasswd

pacman -S --noconfirm --needed grub efibootmgr networkmanager dialog mtools dosfstools reflector base-devel linux-headers xdg-user-dirs xdg-utils bluez cups alsa-utils pavucontrol bash-completion rsync acpi vde2 os-prober

grub-install --target=x86_64-efi --efi-directory=/boot/EFI --removable
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager

useradd -m -G wheel vortex
echo vortex:Linux | chpasswd

sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
