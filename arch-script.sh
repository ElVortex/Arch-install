#!/bin/bash
#github-action genshdoc
#

# Find the name of the folder the scripts are in

cd ~

loadkeys br-abnt2

sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 8/' /etc/pacman.conf
sed -i 's/SigLevel    = Required DatabaseOptional/SigLevel = Never/' /etc/pacman.conf
sed -i 's/LocalFileSigLevel/#LocalFileSigLevel/' /etc/pacman.conf

pacman -S --noconfirm --needed gptfdisk btrfs-progs

sgdisk -Z /dev/sda
sgdisk -a 2048 -o /dev/sda
sgdisk -n 1::+300M --typecode=1:ef00 /dev/sda
sgdisk -n 2::-0 --typecode=2:8300 /dev/sda

mkfs.fat -F 32 /dev/sda1
mkfs.btrfs /dev/sda2

mount /dev/sda2 /mnt
cd /mnt

btrfs subvolume create /@
btrfs subvolume create /@home

cd /
umount /mount

mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@ /dev/sda2 /mnt
mkdir /mnt/{boot,home}
mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@home /dev/sda2 /mnt/home

mkdir /mnt/boot/EFI
mount /dev/sda1 /mnt/boot/EFI

pacstrap /mnt base base-devel linux linux-firmware vim nano sudo amd-ucode

genfstab -U /mnt >> /mnt/etc/fstab

cp -R /root/Arch-install /mnt/root/
arch-chroot /mnt /root/Arch-install/setup.sh
