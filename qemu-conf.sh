#!/bin/bash

# BOOT QEMU VM WITH ANY DEBIAN RELEASE
# https://www.collabora.com/news-and-blog/blog/2017/01/16/setting-up-qemu-kvm-for-kernel-development/

# QEMU setup script to include a rootfs
IMG=qemu-image.img
DIR=mount-point.dir
qemu-img create $IMG 1g
mkfs.ext2 $IMG
mkdir $DIR
sudo mount -o loop $IMG $DIR
# Using buster here as it is the current debian stable release (4/16/2020)
sudo debootstrap --arch amd64 buster $DIR
sudo umount $DIR
rmdir $DIR
