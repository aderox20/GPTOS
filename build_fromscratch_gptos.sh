#!/bin/bash

set -e

echo "Starting GPTOS ISO Build Script"

GPTOS="$HOME/GPTOS"
ROOTFS="$GPTOS/rootfs"
ISO="$GPTOS/iso"
KERNEL="$GPTOS/kernel/vmlinuz"

mkdir -p $ROOTFS/bin $ROOTFS/dev $ROOTFS/proc $ROOTFS/sys $ROOTFS/tmp
mkdir -p $ISO/boot/grub

echo "Downloading BusyBox..."
wget -O $ROOTFS/bin/busybox https://busybox.net/downloads/binaries/1.35.0-x86_64-linux-musl/busybox
chmod +x $ROOTFS/bin/busybox
ln -sf /bin/busybox $ROOTFS/bin/sh

echo "Downloading Coreutils..."
# Adjust version or mirror if needed
COREUTILS_URL="https://ftp.gnu.org/gnu/coreutils/coreutils-9.3.tar.xz"
wget -O $GPTOS/coreutils-9.3.tar.xz $COREUTILS_URL
mkdir -p $GPTOS/coreutils-build
tar -xf $GPTOS/coreutils-9.3.tar.xz -C $GPTOS/coreutils-build --strip-components=1
cd $GPTOS/coreutils-build
./configure --prefix=$ROOTFS
make -j$(nproc) install
cd $GPTOS

echo "Creating device nodes..."
sudo mknod -m 622 $ROOTFS/dev/console c 5 1 || true
sudo mknod -m 666 $ROOTFS/dev/null c 1 3 || true
sudo mknod -m 666 $ROOTFS/dev/zero c 1 5 || true
for i in 0 1 2 3 4; do
  sudo mknod -m 666 $ROOTFS/dev/tty$i c 4 $i || true
done

echo "Creating init..."
sudo tee $ROOTFS/init >/dev/null <<'EOF'
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
mount -t tmpfs none /tmp
mount -t devtmpfs none /dev

exec /bin/sh
EOF
sudo chmod +x $ROOTFS/init

echo "Creating initramfs..."
cd $ROOTFS
find . | cpio -H newc -o >../iso/boot/initramfs.img
cd $GPTOS

echo "Copying kernel..."
cp $KERNEL $ISO/boot/vmlinuz

echo "Creating GRUB config..."
sudo tee $ISO/boot/grub/grub.cfg >/dev/null <<'EOF'
set default=0
set timeout=5
menuentry "GPTOS_0.0.1_prealpha" {
    linux /boot/vmlinuz init=/init
    initrd /boot/initramfs.img
}
EOF

echo "Building ISO..."
grub-mkrescue -o $GPTOS/gptos-0.0.1-x86_64.iso $ISO

read -p "Want to boot in QEMU? (y/n) " bootq
if [[ "$bootq" == "y" ]]; then
  qemu-system-x86_64 -cdrom $GPTOS/gptos-0.0.1-x86_64.iso -m 2G -boot d
fi
