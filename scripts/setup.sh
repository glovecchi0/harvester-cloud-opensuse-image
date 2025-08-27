#!/bin/bash
set -euxo pipefail

# Installation of pre-requisite packages
sudo zypper --non-interactive addrepo https://download.opensuse.org/repositories/network/SLE_15/network.repo
sudo zypper --non-interactive --gpg-auto-import-keys refresh
sudo zypper --non-interactive install \
  parted util-linux virt-install libvirt qemu-kvm python3-websockify novnc socat nginx sshpass chrony

# Enable and start services
sudo systemctl enable --now libvirtd

# Create required directory
sudo mkdir -p /srv/www/harvester
