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
  communicator     = "ssh"
  ssh_username     = "root"
  ssh_password     = "changeme"
  ssh_timeout      = "20m"
  shutdown_command = "echo 'changeme' | sudo -S systemctl poweroff"
  shutdown_timeout = "10m"

  # AutoYaST profile usage for automated installation
  boot_command = [
    "<enter><wait>",
    "linux text autoyast=http://{{ .HTTPIP }}:{{ .HTTPPort }}/autoinst.xml<wait>",
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

  # Serve AutoYaST profile via Packer HTTP server
  http_directory = "packer"
}

build {
  sources = ["source.qemu.opensuse"]

  # Optional: rename artifact for clarity
  post-processor "compress" {
    output = "opensuse-15.6-image.qemu.opensuse"
  }
}
