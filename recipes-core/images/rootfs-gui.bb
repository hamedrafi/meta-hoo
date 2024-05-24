SUMMARY = "Base image for Test rpi "

IMAGE_FSTYPES = "tar.gz ext4"

LICENSE = "CLOSED"


IMAGE_INSTALL = "packagegroup-core-boot \
    packagegroup-core-x11 \
    packagegroup-xfce-base \
    kernel-modules \
"

inherit features_check
REQUIRED_DISTRO_FEATURES = "x11"

inherit core-image

SYSTEMD_DEFAULT_TARGET = "graphical.target"

DEFAULT_TIMEZONE = "CET"
ROOTFS_POSTPROCESS_COMMAND += "set_local_timezone;"
set_local_timezone() {
  ln -sf /usr/share/zoneinfo/CET ${IMAGE_ROOTFS}/etc/localtime
}


DISTRO_FEATURES += "wifi"

inherit extrausers
EXTRA_USERS_PARAMS = "usermod -P '' root;"
EXTRA_IMAGE_FEATURES += "tools-debug package-management"


IMAGE_FEATURES += "splash hwcodecs"
# CORE_IMAGE_BASE_INSTALL += "weston weston-init weston-examples gtk+3-demo clutter-1.0-examples"

IMAGE_INSTALL += "packagegroup-core-ssh-openssh systemd-conf"

# install custom python packages
IMAGE_INSTALL += "python3 python3-paho-mqtt python3-pyserial python3-pip"

# install general utilities
IMAGE_INSTALL += "libconfig sqlite3 curl nano iproute2 net-tools picocom nmap iw "

# install kernel and device-tree
IMAGE_INSTALL += "kernel-image kernel-devicetree u-boot-fw-utils u-boot"

# Enable Wifi
IMAGE_INSTALL += "linux-firmware-rpidistro-bcm43455 kernel-module-brcmfmac wpa-supplicant"

# Enable Bluetooth
IMAGE_INSTALL += "kernel-module-hci-uart"

# enable rauc update manager
IMAGE_INSTALL += "rauc"

