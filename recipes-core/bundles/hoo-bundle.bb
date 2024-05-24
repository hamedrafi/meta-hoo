inherit hoo-bundle

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

PV = "${HOOBIAN_RELEASE_VERSION}"


RAUC_BUNDLE_IMGNAME = "hoo"
RAUC_BUNDLE_SLOTS = "rootfs"
RAUC_SLOT_rootfs = "rootfs"
RAUC_SLOT_rootfs[type] = "image"
RAUC_SLOT_rootfs[fstype] = "ext4"

do_deploy:append() {
    ln -s -r ${DEPLOYDIR}/${BUNDLE_BASENAME}-${MACHINE}${BUNDLE_EXTENSION} ${DEPLOYDIR}/${BUNDLE_BASENAME}-${MACHINE}-${PV}${BUNDLE_EXTENSION}
}
