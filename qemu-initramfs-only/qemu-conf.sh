#!/bin/bash
IMG=qemu-image.img
DIR=mount-point.dir

function create_image() {
    qemu-img create $IMG 1g
    mkfs.ext4 $IMG
    mkdir $DIR
    sudo mount -o loop $IMG $DIR
    # Using buster here as it is the current debian stable release (4/16/2020)
    sudo debootstrap --arch amd64 buster $DIR
    sudo umount $DIR
    rmdir $DIR
}


echo "Enter kernel version to boot: "
ls /boot/vm*
read -p "Enter kernel version to boot: " kernel_ver
if [ -f qemu-img ]
then
	read -p "Overwrite existing image?(y|n): " reply
	[[ $reply == "y" ]] && create_image
else 
	create_image
fi

kernel="/boot/vmlinuz-${kernel_ver}"
sudo qemu-system-x86_64 -kernel $kernel\
                          -hda qemu-image.img\
                          -append "root=/dev/sda single"\
			  --enable-kvm\
			  -nographic\
			  -append "console=ttyS0 root=/dev/sda single"
