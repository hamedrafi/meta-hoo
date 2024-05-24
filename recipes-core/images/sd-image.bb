SUMMARY = "Hoobian Full image"
LICENSE = "MIT"

inherit image

PV = "${HOOBIAN_RELEASE_VERSION}"

IMAGE_FSTYPES = "wic.gz"
WKS_FILE = "sd-image-hoobian-gui.wks"

# add fat-dependencies
do_image_wic[depends] += " \
    mtools-native:do_populate_sysroot \
    dosfstools-native:do_populate_sysroot \
"

do_image[depends] += " \
                rootfs:do_image_complete \
                rootfs-gui:do_image_complete \
                hoo-bundle:do_deploy \
                hoo-gui-bundle:do_deploy \
                virtual/kernel:do_deploy \
                virtual/bootloader:do_deploy \
"

do_cleanall[depends] += " \
                rootfs:do_cleanall \
                rootfs-gui:do_cleanall \
                hoo-bundle:do_cleanall \
                hoo-gui-bundle:do_cleanall \
                virtual/kernel:do_cleanall \
                virtual/bootloader:do_cleanall \
"
