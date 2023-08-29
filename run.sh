#!/bin/sh

HERE=$(dirname $(readlink -f "${0}"))

if [ -z "${ANDROID_DATA_DIR}" ]; then
    ANDROID_DATA_DIR=$HERE
fi

echo "ANDROID_DATA_DIR=${ANDROID_DATA_DIR}"
sys=$ANDROID_DATA_DIR/os.img
initrd=$ANDROID_DATA_DIR/initrd.img
kernel=$ANDROID_DATA_DIR/kernel
data=$ANDROID_DATA_DIR/data.qcow2

$HERE/qemu-system-x86_64-x86_64.AppImage \
-enable-kvm \
-M q35 \
-m 8G \
-smp 6 \
-cpu host \
-device AC97 \
-net nic,model=virtio-net-pci \
-net user,hostfwd=tcp::4444-:5555 \
-machine vmport=off \
-usb \
-device usb-tablet \
-device usb-kbd \
-device virtio-vga-gl \
-device qemu-xhci,id=xhci \
-display gtk,grab-on-hover=on,gl=on,full-screen=on \
-audiodev id=pa,driver=pa \
-drive index=0,if=virtio,id=system,file=${sys},format=raw,readonly=on \
-drive index=1,if=virtio,id=data,file=${data},format=qcow2 \
-initrd ${initrd} \
-kernel ${kernel} \
-append "root=/dev/ram0 DATA=/dev/vdb1 SRC=/android SETUPWIZARD=0"