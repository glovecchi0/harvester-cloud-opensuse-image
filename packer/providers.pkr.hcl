packer {
  required_version = "1.14.1"
  required_plugins {
    qemu = {
      version = "1.1.4"
      source  = "github.com/hashicorp/qemu"
    }
  }
}
