packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = ">= 1.0.0"
    }
  }
}

source "qemu" "opensuse-net" {
  iso_url          = "https://download.opensuse.org/distribution/leap/15.6/iso/openSUSE-Leap-15.6-NET-x86_64-Current.iso"
  iso_checksum     = "none"
  output_directory = "output-qemu-opensuse"
  disk_size        = 10000
  format           = "qcow2"
  accelerator      = "kvm"
  headless         = true
  http_directory   = "./http"
  boot_wait        = "5s"
  boot_command     = [
    "<esc><enter><wait>",
    "linux textmode=1 autoyast=http://{{ .HTTPIP }}:{{ .HTTPPort }}/autoyast.xml<enter><wait>",
    "<enter><wait5>"
  ]

  ssh_username     = "root"
  ssh_password     = "packer"
  ssh_wait_timeout = "30m"

  net_device       = "virtio-net"
  qemuargs = [
    ["-m", "2048M"],
  ]
}

build {
  sources = ["source.qemu.opensuse-net"]

  provisioner "shell" {
    inline = [
      "zypper -n update"
    ]
  }
}