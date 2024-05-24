SUMMARY = "Empty image"

# set IMAGE_FILES to add images from deploy folder, and remember to update IMAGE_DEPENDS as well
# set IMAGE_INSTALL to install standard packages like a ordinary rootfs

inherit core-image

IMAGE_LINGUAS = " "
IMAGE_INSTALL = " "
IMAGE_FILES = ""
IMAGE_DEPENDS = ""
IMAGE_FEATURES = ""
IMAGE_PREPROCESS_COMMAND = "image_cleanup; image_files;"
ROOTFS_BOOTSTRAP_INSTALL = ""
LDCONFIGDEPEND = ""
do_image[depends] += "${@' '.join([var + ':do_build' for var in (d.getVar('IMAGE_DEPENDS', True)).split()])}"
do_cleanall[depends] += "${@' '.join([var + ':do_cleanall' for var in (d.getVar('IMAGE_DEPENDS', True)).split()])}"


# # Avoid failure due to missing fstab
populate_packages_updatealternatives () {
    :
}

image_cleanup () {
    # Remove update alternatives
    g=${IMAGE_ROOTFS}/${libdir}/opkg/alternatives/*
    test -e $g && rm $g

    # Remove empty folders
    find ${IMAGE_ROOTFS}/* -type d -empty -delete
}

image_files () {
    for f in ${IMAGE_FILES}; do
        install ${DEPLOY_DIR_IMAGE}/${f} ${IMAGE_ROOTFS}/
    done
}
