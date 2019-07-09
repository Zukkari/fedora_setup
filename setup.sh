#!/usr/bin/env bash

USER=zukkari

KERNEL_VERSION=$(uname -r)
MOUNT_DIR=/media/guest
VBOX_BINARY_NAME=VBoxLinuxAdditions.run
GUEST_MOUNT_POINT=/dev/sr0

# Exit on errors
set -e

# Install packages that we need to install guest additions and some
# other essential packages
dnf install \
    dnf-plugins-core \
    maven \
    vim \
    kernel-devel-${KERNEL_VERSION} \
    kernel-headers-${KERNEL_VERSION} \
    gcc \
    make \
    elfutils-libelf-devel \
    -y

# Install additions
mkdir ${MOUNT_DIR}
mount ${GUEST_MOUNT_POINT} ${MOUNT_DIR}

cd ${MOUNT_DIR}
'yes' | ./${VBOX_BINARY_NAME}

umount ${GUEST_MOUNT_POINT}
rm -rf ${GUEST_MOUNT_POINT}

# Export JAVA_HOME
echo 'export JAVA_HOME=/usr/bin/java' >> /home/${USER}/.bashrc

# Install Docker
dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo

dnf install docker-ce docker-ce-cli containerd.io -y

systemctl enable docker
systemctl start docker

# Install Google Cloud SDK

sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM

dnf install google-cloud-sdk

# Init g-cloud
gcloud init
