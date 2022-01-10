#!/usr/bin/env bash
# __     _______
# \ \   / /_   _|  Vox Tetra
#  \ \ / /  | |    https://www.github.com/VoxT1
#   \ V /   | |    https://www.twitter.com/VoxTetra1
#    \_/    |_|    vt#9827

## Some variables
EDITOR=nano # During the base install, only nano is installed.
i=0
k=0
l=0
m=0

## Welcome
echo "                   ____            _"
echo "  __   _______  __/ ___| ___ _ __ | |_ ___   ___"
echo "  \ \ / / _ \ \/ / |  _ / _ \ '_ \| __/ _ \ / _ \ "
echo "   \ V / (_) >  <| |_| |  __/ | | | || (_) | (_) |"
echo "    \_/ \___/_/\_\\____|\___|_| |_|\__\___/ \___/ "
echo
echo "###################################################################"
echo "## This script should only be run after the Stage-3 tarball      ##"
echo "## has been unpacked and the base system has been chrooted into. ##"
echo "##    You are on your own to partition and mount your drives.    ##"
echo "###################################################################"
echo
if [ "$(id -u)" != 0 ]; then
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "                        This script MUST be run as root!"
    echo "If you are not running this as root, then you are using this script improperly!"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    exit 1
fi
echo "###################################################################"
echo "##            There are nine sections to this script.            ##"
echo "##                                                               ##"
echo "## I.    Initial Sync                                            ##"
echo "## II.   Configuring Portage                                     ##"
echo "## III.  Updating the @world Set                                 ##"
echo "## IV.   Timezone/Locale Configuration                           ##"
echo "## V.    Kernel Configuration                                    ##"
echo "## VI.   Fstab Configuration                                     ##"
echo "## VII.  Networking                                              ##"
echo "## VIII. Installing Tools/Enabling Services                      ##"
echo "## IX.   Bootloader                                              ##"
echo "##                                                               ##"
echo "###################################################################"
echo
read -p 'Press Enter to begin (Ctrl+C to abort)...'

## Sync Portage
echo "Running the initial sync..."
emerge-webrsync
emerge --sync

## Select Profile
eselect profile list
read -p 'Select profile: ' profile
echo
echo "Selected profile $profile"
eselect profile set "$profile"

## Copying VoxConfig for make.conf
echo "Fetching make.conf from VoxDots..."
rm /etc/portage/make.conf
wget https://raw.githubusercontent.com/V0xl/VoxDots/main/gentoo/make.conf -P /etc/portage/

## User edits make.conf if necessary
echo "During this stage, only nano is available."
echo "Entering make.conf for tweaking in: "
echo "3"
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
$EDITOR /etc/portage/make.conf

## User confirms make.conf
echo
echo "Would you like to doublecheck your make.conf?"
while [ $i -le 2 ]
do
    read -p 'Y/N: ' mkconfirm
    if [ "$mkconfirm" == "Y" ] | [ "$mkconfirm" == "y" ]; then
        $EDITOR /etc/portage/make.conf
    elif [ "$mkconfirm" == "N" ] | [ "$mkconfirm" == "n" ]; then
        break
    else
        echo "Please select Y/N"
        ((i++))
    fi
done
echo
echo "make.conf has been configured."
sleep 3
clear

## Updating @world
echo
echo "The @world set will be updated."
echo "THIS CAN TAKE A VERY LONG TIME!"
sleep 2
time emerge --update --verbose --deep --newuse @world
echo
echo "The @world set has been updated."
read -p 'Press Enter to continue...'
clear

## Timezone
read -p 'Input your timezone (Region/City): ' timezone
echo
echo "Selected timezone $timezone will be added to /etc/timezone"
echo "$timezone" >> /etc/timezone
echo
emerge --config timezone-data
echo
echo "Timezone has been configured."
sleep 3
clear

## Locale
echo
echo "Add your locale to /etc/locale.gen"
echo "3"
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
$EDITOR /etc/locale.gen
locale-gen
echo
eselect locale list
echo
read -p 'Select your locale: ' locale
echo
eselect locale set "$locale"
echo
echo "Locale has been configured."
sleep 3
clear

## Kernel
echo
echo "#######################################################################"
echo "##                     A fork appears in the road...                 ##"
echo "## Now it is time to choose how you would like to build your kernel. ##"
echo "#######################################################################"
echo
echo "Option 1:"
echo "Standard Kernel (ADVANCED)"
echo "You will configure your own custom kernel. You know what you are doing."
echo
echo "Option 2:"
echo "Distribution Kernel (INTERMEDIATE)"
echo "A preconfigured kernel will be built through Portage. Little to no configuration is necessary, but the kernel will still be compiled."
echo
echo "Option 3:"
echo "Distribution Kernel Binary (EASIEST)"
echo "A preconfigured kernel binary will be installed through Portage. No customization is necessary, but the kernel will be bloated."
echo "Suitable for beginners who want a quick install done."
echo
while [ $k -le 2 ]
do
    read -p 'Select your choice (1,2,3): ' kernel
    if [[ "$kernel" == "2" ]]; then
        echo
        echo "A distribution kernel will be built."
        time emerge -auv sys-kernel/gentoo-kernel
        emerge @module-rebuild
        break
    elif [ "$kernel" == "3" ]; then
        echo
        echo "A distribution kernel binary will be built."
        time emerge -auv sys-kernel/gentoo-kernel-bin
        emerge @module-rebuild
        break
    elif [ "$kernel" == "1" ]; then
        echo
        echo "Have fun."
        emerge -auv sys-kernel/gentoo-sources
        eselect kernel set 1
        cd /usr/src/linux/
        make menuconfig
        echo
        echo "Would you like to doublecheck your kernel config?"
        while [ $l -le 2 ]
        do
            read -p 'Y/N: ' kconfirm
            if [ "$kconfirm" == "Y" ] | [ "$kconfirm" == "y" ]; then
                make menuconfig
            elif [ "$kconfirm" == "N" ] | [ "$kconfirm" == "n" ]; then
                break else
                echo "Please select Y/N"
                ((l++))
            fi
        done
        echo
        echo "Preparing modules..."
        make modules_prepare
        echo
        read -p 'Select -j integer: ' j
        echo
        echo "Building kernel..."
        time make -j"$j" && make modules_install && make install
        cd
        break

    elif [ "$kernel" == "4" ]; then
        echo
        echo "You found the secret option. Vox's kernel config will now be used."
        emerge -auv sys-kernel/gentoo-sources
        eselect kernel set 1
        cd /usr/src/linux/
        echo
        echo "Preparing kernel for added configuration..."
        make mrproper
        echo
        echo "Downloading kernel config..."
        wget https://raw.githubusercontent.com/V0xl/VoxDots/main/gentoo/.config -P /usr/src/linux/
        echo
        echo "Applying config..."
        make olddefconfig
        echo
        echo "Preparing modules..."
        make modules_prepare
        echo
        read -p 'Select -j integer: ' j
        echo
        echo "Building kernel..."
        time make -j"$j" && make modules_install && make install
        cd
        break
    else
        echo "Select 1, 2 or 3."
        ((k++))
    fi
done
echo
echo "Kernel has been installed. Firmware will now be installed."
emerge -auv linux-firmware
clear

## Fstab
echo
echo "The fstab file must be configured to boot properly."
echo "Recall that this script assumes a 3-partition (boot, root, home) layout."
echo
rm /etc/fstab
read -p 'Enter your first partition label (e.g. /dev/sda1): ' LABEL1
read -p 'Enter your first partition mountpoint (e.g. /boot): ' MOUNT1
read -p 'Enter your first partition filesystem (e.g. vfat): ' FS1
echo
echo "This entry will be entered into /etc/fstab:"
echo "$LABEL1   $MOUNT1     $FS1    defaults,noatime    0 2"
echo "$LABEL1   $MOUNT1     $FS1    defaults,noatime    0 2" >> /etc/fstab
echo
read -p 'Enter your second partition label (e.g. /dev/sda2): ' LABEL2
read -p 'Enter your second partition mountpoint (e.g. /): ' MOUNT2
read -p 'Enter your second partition filesystem (e.g. ext4): ' FS2
echo
echo "This entry will be entered into /etc/fstab:"
echo "$LABEL2   $MOUNT2     $FS2    defaults,noatime    0 1"
echo "$LABEL2   $MOUNT2     $FS2    defaults,noatime    0 1" >> /etc/fstab
echo
read -p 'Enter your third partition label (e.g. /dev/sda3): ' LABEL3
read -p 'Enter your third partition mountpoint (e.g. /home): ' MOUNT3
read -p 'Enter your third partition filesystem (e.g. btrfs): ' FS3
echo
echo "This entry will be entered into /etc/fstab:"
echo "$LABEL3   $MOUNT3     $FS3    defaults,noatime    0 1"
echo "$LABEL3   $MOUNT3     $FS3    defaults,noatime    0 1" >> /etc/fstab
echo
clear
cat /etc/fstab
echo
while [ $m -le 10 ]
do
    read -p 'Would you like to doublecheck your fstab? (Y/N): ' fstconfirm
    if [ "$fstconfirm" == "Y" ] | [ "$fstconfirm" == "y" ];then
         read -p 'Enter your first partition label (e.g. /dev/sda1): ' LABEL1
         read -p 'Enter your first partition mountpoint (e.g. /boot): ' MOUNT1
         read -p 'Enter your first partition filesystem (e.g. vfat): ' FS1
         echo
         echo "This entry will be entered into /etc/fstab:"
         echo "$LABEL1   $MOUNT1     $FS1    defaults,noatime    0 2"
         echo "$LABEL1   $MOUNT1     $FS1    defaults,noatime    0 2" >> /etc/fstab
         echo
         read -p 'Enter your second partition label (e.g. /dev/sda2): ' LABEL2
         read -p 'Enter your second partition mountpoint (e.g. /): ' MOUNT2
         read -p 'Enter your second partition filesystem (e.g. ext4): ' FS2
         echo
         echo "This entry will be entered into /etc/fstab:"
         echo "$LABEL2   $MOUNT2     $FS2    defaults,noatime    0 1"
         echo "$LABEL2   $MOUNT2     $FS2    defaults,noatime    0 1" >> /etc/fstab
         echo
         read -p 'Enter your third partition label (e.g. /dev/sda3): ' LABEL3
         read -p 'Enter your third partition mountpoint (e.g. /home): ' MOUNT3
         read -p 'Enter your third partition filesystem (e.g. btrfs): ' FS3
         echo
         echo "This entry will be entered into /etc/fstab:"
         echo "$LABEL3   $MOUNT3     $FS3    defaults,noatime    0 1"
         echo "$LABEL3   $MOUNT3     $FS3    defaults,noatime    0 1" >> /etc/fstab
         echo
         clear
         cat /etc/fstab
         echo
    elif [ "$fstconfirm" == "N" ] | [ "$fstconfirm" == "n" ]; then
        break
    else
        ((m++))
    fi
done
echo "/etc/fstab has been configured."
clear

## Networking
echo "Networking will be done using dhcpcd."
echo
ip a
read -p 'Enter your network interface: ' net
echo 'config_$net="dhcp"' >> /etc/conf.d/net
echo
rm /etc/conf.d/hostname
read -p 'Enter a name for your system: ' hostname
echo 'hostname="$hostname"' >> /etc/conf.d/hostname
echo "127.0.1.1 $hostname" >> /etc/hosts
cd /etc/init.d/
ln -s net.lo net."$net"
rc-update add net."$net" default
echo
echo "Networking has been configured."
sleep 3
clear

## Tools and Services
echo "A variety of tools must be installed and their services enabled."
echo
echo "sys-auth/pambase -passwdqc" >> /etc/portage/package.use/pambase
echo "app-admin/doas persist" >> /etc/portage/package.use/doas
echo "app-admin/doas ~amd64" >> /etc/portage/package.accept_keywords
echo "Installing tools..."
emerge -auv pambase doas sysklogd mlocate dhcpcd btrfs-progs xfsprogs dosfstools
echo
echo "Enabling services..."
rc-update add sysklogd default
rc-update add sshd default
rc-update add dhcpcd default
rc-update add dbus default
rc-update add elogind boot
echo
read -sp 'Set your root password: ' rootpass
echo
passwd
"$rootpass"
echo
read -p 'Enter a username: ' usernm
useradd -m -g users -G wheel,audio,video "$usernm"
echo
read -sp 'Enter your user password: ' userpass
echo
passwd "$usernm"
"$userpass"
echo
echo "permit $usernm as root" >> /etc/doas.conf
echo "permit persist $usernm" >> /etc/doas.conf
echo
echo "Tools and services have been configured."
sleep 3
clear

## Bootloader
echo "Now we must install the bootloader."
echo
echo "Installing GRUB and related tools..."
emerge -auv grub efibootmgr os-prober mtools
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
grub-mkconfig -o /boot/grub/grub.cfg
echo
echo "GRUB has been installed and configured."
sleep 3
echo
echo "Your system should be bootable and functional :)"
echo
echo "Script will close in 5 seconds..."
sleep 5
