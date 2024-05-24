SUMMARY = "Base image for Test rpi "


IMAGE_INSTALL = "packagegroup-core-boot"

IMAGE_FSTYPES = "tar.gz ext4"

LICENSE = "CLOSED"

inherit core-image


DEFAULT_TIMEZONE = "CET"
ROOTFS_POSTPROCESS_COMMAND += "set_local_timezone;"
set_local_timezone() {
  ln -sf /usr/share/zoneinfo/CET ${IMAGE_ROOTFS}/etc/localtime
}


inherit extrausers
EXTRA_USERS_PARAMS = "usermod -P '' root;"
EXTRA_IMAGE_FEATURES += "tools-debug package-management"

DISTRO_FEATURES += "wifi"

IMAGE_INSTALL += "packagegroup-core-ssh-openssh systemd-conf"

IMAGE_INSTALL += "u-boot-fw-utils"

# install custom python packages
IMAGE_INSTALL += "python3 python3-paho-mqtt python3-pyserial python3-pip"

#install required libraries
IMAGE_INSTALL += "libconfig"

# install general utilities
IMAGE_INSTALL += "sqlite3 curl nano iproute2 net-tools picocom nmap iw "

# install kernel and device-tree
IMAGE_INSTALL += "kernel-image kernel-devicetree u-boot-fw-utils u-boot"

# Enable Wifi
IMAGE_INSTALL += "linux-firmware-rpidistro-bcm43455 kernel-module-brcmfmac hostapd wpa-supplicant"

# Enable Bluetooth
IMAGE_INSTALL += "kernel-module-hci-uart"

# enable rauc update manager
IMAGE_INSTALL += "rauc"

