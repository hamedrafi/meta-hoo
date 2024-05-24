inherit bundle

python () {
    if not d.getVar('RAUC_BUNDLE_IMGNAME', True):
        bb.fatal("'RAUC_BUNDLE_IMGNAME' not set. Please set an image name.")
    else:
        d.setVar('BUNDLE_BASENAME',d.getVar('RAUC_BUNDLE_IMGNAME',True))
}

do_image[vardeps] += "RAUC_BUNDLE_IMGNAME"
deltask package_write_ipk
deltask package_write_deb
deltask package_write_rpm
