#!/bin/bash
# __     _______
# \ \   / /_   _|  Vox Tetra
#  \ \ / /  | |    https://www.github.com/VoxT1
#   \ V /   | |    https://www.twitter.com/VoxTetra1
#    \_/    |_|    vt#9827
#
# Mounts the necessary file systems so you don't need to copy/paste or write out every single command

echo "Mounting necessary filesystems..."

mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run

echo "Finished."
