#!/bin/bash
#github-action genshdoc
#

# Find the name of the folder the scripts are in

pwd
cd ~
pwd

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

mount -v /dev/sda2 /mnt
cd /mnt
pwd
btrfs subvolume create /@
btrfs subvolume create /@home

cd /
pwd
umount -v /mnt

mount -ov noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@ /dev/sda2 /mnt
mkdir -v /mnt/{boot,home}
mount -ov noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@home /dev/sda2 /mnt/home

mkdir -v /mnt/boot/EFI
mount -v /dev/sda1 /mnt/boot/EFI

pacstrap /mnt base base-devel linux linux-firmware vim nano sudo amd-ucode

genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

cp -Rv /root/Arch-install /mnt/root/Arch-install
arch-chroot /mnt /root/Arch-install/setup.sh
