# __My Random QEMU (x86_64) Kernel Dev Booting Stuffs__  
&nbsp;
&nbsp;
## __BOOT QEMU VM WITH ANY DEBIAN DISTRO RELEASE ROOTFS__  
_Takes long time due to download of image_  
(https://www.collabora.com/news-and-blog/blog/2017/01/16/setting-up-qemu-kvm-for-kernel-development/)  

### QEMU setup script to include a release debian rootfs  
```
#!/bin/sh  
IMG=qemu-image.img  
DIR=mount-point.dir  
qemu-img create $IMG 1g  
mkfs.ext4 $IMG  
mkdir $DIR  
sudo mount -o loop $IMG $DIR  
#Using buster here as it is the current debian stable release (4/16/2020)  
sudo debootstrap --arch amd64 buster $DIR  
sudo umount $DIR  
rmdir $DIR  

# This will boot to single-user mode and allow change of root password "su -"
sudo qemu-system-x86_64 -kernel /boot/vmlinuz-`uname -r`\  
                          -hda qemu-image.img\  
                          -append "root=/dev/sda2 single console=ttyS0"\  
			  -nographic\  
			  --enable-kvm   
```  
  
### Boot QEMU with dev kernel into an initramfs busybox prompt: NO ROOTFS  
```
export WORKSPACE="/home/saw/workspace/kernel-dev/qemu-initramfs-only/my_initramfs"  
sudo mkdir --parents $WORKSPACE/initramfs/{bin,dev,etc,lib,lib64,mnt/root,proc,root,sbin,sys}  
sudo cp --archive /dev/{null,console,tty,sda1} $WORKSPACE/initramfs/dev/  
#NOTE: Busybox must be STATIC! ...'ldd /bin/busybox' to verify it is static  
sudo cp /bin/busybox /usr/src/initramfs/bin/  
ldd /usr/src/initramfs/bin/busybox   
sudo vi $WORKSPACE/initramfs/init  

#init contents:  
#!/bin/busybox sh  
sudo chmod +x /usr/src/initramfs/init  
cd <workspace>/initramfs/  
sudo find . -print0 | cpio --null --create --verbose --format=newc | gzip --best > /tmp/custom-initramfs.cpio.gz; sudo cp /tmp/custom-initramfs.cpio.gz /boot/custom-initramfs.cpio.gz  
ls -lrt /boot  
sudo qemu-system-x86_64 -kernel /boot/vmlinuz-5.2.21 -initrd /boot/custom-initramfs.cpio.gz -nographic -append "root=/dev/sda2 console=ttyS0" --enable-kvm  
```
&nbsp;
&nbsp;
#TODO:  Boot QEMU with handmade rootfs built using Buildroot.  
(https://gist.github.com/chrisdone/02e165a0004be33734ac2334f215380e)  
#TODO:  Boot QEMU with handmade rootfs built using Yacto.  

