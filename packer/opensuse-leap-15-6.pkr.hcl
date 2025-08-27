# Packer template to build OpenSUSE Leap 15.6 image with QEMU
# Uses QEMU 'q35' machine type
# Generates QCOW2 image suitable for cloud import
# Installation is automated via AutoYaST profile

packer {
  required_version = "1.14.1"
  required_plugins {
    qemu = {
      version = "1.1.4"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

# VM resources
variable "memory" {
  type    = number
  default = 2048
}

variable "cpus" {
  type    = number
  default = 2
}

variable "disk_size" {
  type    = string
  default = "20G"
}

source "qemu" "opensuse" {
  # Output directory for the built image
  output_directory = "artifacts"

  # Machine settings
  accelerator      = "tcg"    # Use software emulation
  format           = "qcow2"
  headless         = true
  iso_url          = "https://download.opensuse.org/distribution/leap/15.6/iso/openSUSE-Leap-15.6-NET-x86_64-Current.iso"
  iso_checksum     = "sha256:0984b36d0f420487f2766733ff8f9d779ade81d432b08e40e852a675313750bb"

  # SSH communicator settings
  ssh_username     = "root"
  ssh_password     = "changeme"

  # AutoYaST profile usage for automated installation
  boot_command = [
    "<enter><wait>",
    "linux text autoyast=http://10.0.2.2:8000/autoinst.xml<wait>",
    "<enter>"
  ]

  # VM hardware resources
  memory         = var.memory
  cpus           = var.cpus
  disk_size      = var.disk_size
  disk_interface = "virtio"
  net_device     = "virtio-net"

  # QEMU command-line arguments
  qemuargs = [
    ["-machine", "q35,accel=tcg"]
  ]
}

build {
  sources = ["source.qemu.opensuse"]

  # Copy AutoYaST profile into the VM before boot
  provisioner "file" {
    source      = "packer/autoinst.xml"
    destination = "/tmp/autoinst.xml"
  }

  # Copy custom provisioning script into the VM
  provisioner "file" {
    source      = "scripts/setup.sh"
    destination = "/tmp/setup.sh"
  }

  # Execute provisioning script after installation
  provisioner "shell" {
    inline = [
      "#!/bin/bash",
      "echo 'Starting custom provisioning script...'",
      "chmod +x /tmp/setup.sh",
      "/tmp/setup.sh",
      "echo 'Provisioning finished.'"
    ]
  }

  # Optional: rename artifact for clarity
  post-processor "compress" {
    output = "opensuse-15.6-image.qemu.opensuse"
  }
}
