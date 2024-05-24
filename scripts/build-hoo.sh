#!/bin/bash

ME=$(readlink -e "$0")
MY_DIR=$(dirname "$ME")
MY_NAME=$(whoami)
echo $MY_DIR
REPO_ROOT=$(readlink -e "$MY_DIR"/../../../)
echo $REPO_ROOT

# What recipe to build
# YOCTO_IMG="hoo"
YOCTO_IMG="sd-image"
YOCTO_MACHINE="raspberrypi4-64"

cd "$REPO_ROOT" || {
    echo "$REPO_ROOT dir does not exists"
    exit 1
}

DISTRO=$(grep --only-matching --perl-regex "(?<=DISTRO_CODENAME \=).*" sources/poky/meta-poky/conf/distro/poky.conf)
DISTRO=${DISTRO:2:-1}

MY_HOME=$HOME

YOCTO_DEPLOY_DIR=$MY_HOME/yocto-workspace/build-$DISTRO/tmp_$YOCTO_MACHINE/deploy/images/$YOCTO_MACHINE/
DEST_DEPLOY_DIR=$MY_HOME/yocto-deploy/

deploy_arifacts() {
  mkdir -p $DEST_DEPLOY_DIR
  rm -rf $DEST_DEPLOY_DIR/*
  rm $REPO_ROOT/yocto-deploy
  ln -sf $YOCTO_DEPLOY_DIR $REPO_ROOT/yocto-deploy

}

build_image() {
  echo "Building Raspberry Pi 4 image"
  FAIL=0
  mkdir -p $MY_HOME/yocto-workspace/
  BUILD_DIR=$MY_HOME/yocto-workspace/build-$DISTRO

  rm -rf $BUILD_DIR/conf/
  source sources/poky/oe-init-build-env $MY_HOME/yocto-workspace/build-$DISTRO >/dev/null
  BUILD_DIR=$(pwd)

  echo "BBLAYERS = \"\"" >>$BUILD_DIR/conf/bblayers.conf
  echo "BBLAYERS += \" ${REPO_ROOT}/sources/poky/meta \"" >>$BUILD_DIR/conf/bblayers.conf
  echo "BBLAYERS += \" ${REPO_ROOT}/sources/meta-hoobian \"" >>$BUILD_DIR/conf/bblayers.conf
  echo "BBLAYERS += \" ${REPO_ROOT}/sources/poky/meta-poky \"" >>$BUILD_DIR/conf/bblayers.conf
  echo "BBLAYERS += \" ${REPO_ROOT}/sources/poky/meta-yocto-bsp \"" >>$BUILD_DIR/conf/bblayers.conf
  echo "BBLAYERS += \" ${REPO_ROOT}/sources/meta-openembedded/meta-oe \"" >>$BUILD_DIR/conf/bblayers.conf
  echo "BBLAYERS += \" ${REPO_ROOT}/sources/meta-openembedded/meta-initramfs \"" >>$BUILD_DIR/conf/bblayers.conf
  echo "BBLAYERS += \" ${REPO_ROOT}/sources/meta-openembedded/meta-filesystems \"" >>$BUILD_DIR/conf/bblayers.conf
  echo "BBLAYERS += \" ${REPO_ROOT}/sources/meta-openembedded/meta-networking \"" >>$BUILD_DIR/conf/bblayers.conf
  echo "BBLAYERS += \" ${REPO_ROOT}/sources/meta-openembedded/meta-multimedia \"" >>$BUILD_DIR/conf/bblayers.conf
  echo "BBLAYERS += \" ${REPO_ROOT}/sources/meta-openembedded/meta-python \"" >>$BUILD_DIR/conf/bblayers.conf
  echo "BBLAYERS += \" ${REPO_ROOT}/sources/meta-openembedded/meta-gnome \"" >>$BUILD_DIR/conf/bblayers.conf
  echo "BBLAYERS += \" ${REPO_ROOT}/sources/meta-openembedded/meta-xfce \"" >>$BUILD_DIR/conf/bblayers.conf
  echo "BBLAYERS += \" ${REPO_ROOT}/sources/meta-raspberrypi \"" >>$BUILD_DIR/conf/bblayers.conf
  echo "BBLAYERS += \" ${REPO_ROOT}/sources/meta-rauc \"" >>$BUILD_DIR/conf/bblayers.conf

  echo "MACHINE = \"$YOCTO_MACHINE\"" >>./conf/local.conf
  echo "DISTRO = \"hoobian-distro\"" >>./conf/local.conf
  
  string="#TMPDIR = \"\${TOPDIR}\/tmp\""
  repstr="TMPDIR = \"\${TOPDIR}\/tmp_$YOCTO_MACHINE\""
  sed -i "s/$string/$repstr/g" ./conf/local.conf

  echo "*** Running build for $YOCTO_MACHINE ***"

  if [ $# -eq 0 ]; then
    bitbake $YOCTO_IMG || FAIL=$?
  else
    bitbake $@ || FAIL=$?
  fi
  if [ $FAIL -eq 0 ]; then
    echo "Image successfully built."
    deploy_arifacts
  else
    echo "Failed to build image - return value: $FAIL"
  fi

  return $FAIL
}

print_help() {
  echo "$0 <package> [package2 .. packageN] [BITBAKE COMMANDS]"
}

if [ -z "$REPO_ROOT" ]; then
  echo Could not figure out the repository root 1>&2
  exit 1
fi

if [ $# -eq 1 ] && [ "$1" == "--help" ]; then
  print_help
  exit 1
fi
echo "Params: " $@

build_image $@

exit $?
