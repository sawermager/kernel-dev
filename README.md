# kernel-dev
Linux Kernel Development Work

See ./qemu-conf.sh for booting qemu vm with random dev kernel + debian rootfs/disk-image.


Option 1: Work from an initramfs instead of persistent rootfs
 - mkinitramfs -o ramdisk.img
 -  qemu-system-x86_64 -kernel /boot/vmlinuz-`uname -r` -initrd /boot/initrd.img-`uname -r` -nographic -append "console=ttyS0" -m 1024 --enbale-kvm -cpu host

NOTE: Working with small tests (in-place of init but named init) is easier/faster from initramfs than 
      using a rootfs. If needing any dynamic libraries, likely easier to use a rootfs.














Option 2: Create a rootfs (or share one with host)



