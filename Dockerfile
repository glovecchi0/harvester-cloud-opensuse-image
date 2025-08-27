# Dockerfile for building OpenSUSE Leap 15.6 images with Packer + QEMU
FROM ubuntu:24.04

# Set environment variables
ENV PACKER_VERSION=1.14.1
ENV PACKER_LOG=1
ENV PACKER_LOG_PATH=./packer.log

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    unzip \
    qemu-kvm \
    qemu-system-x86 \
    libvirt-daemon-system \
    libvirt-clients \
    virtinst \
    sshpass \
    sudo \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Packer official binary
RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
    && unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin \
    && rm packer_${PACKER_VERSION}_linux_amd64.zip

# Install Packer QEMU plugin
RUN packer plugin install github.com/hashicorp/qemu

# Set default working directory
WORKDIR /workspace
