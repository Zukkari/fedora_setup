#!/usr/bin/env bash

KERNEL_VERSION=$(uname -r)
MOUNT_DIR=/media/guest
VBOX_BINARY_NAME=VBoxLinuxAdditions.run

# Exit on errors
set -e

# Install packages that we need to install guest additions and some
# other essential packages
dnf install \
    vim \
    kernel-devel-${KERNEL_VERSION} \
    kernel-headers-${KERNEL_VERSION} \
    gcc \
    make \
    elfutils-libelf \
    -y

# Install additions
mdir ${MOUNT_DIR}
mount /dev/sr0 ${MOUNT_DIR}

cd ${MOUNT_DIR}
'yes' | ./${VBOX_BINARY_NAME}

# Export JAVA_HOME

# Install Maven

# Install Docker

# Install Google Cloud SDK

