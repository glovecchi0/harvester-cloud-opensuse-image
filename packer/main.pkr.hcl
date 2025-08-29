source "qemu" "opensuse" {
  iso_url          = var.iso_url
  iso_checksum     = var.iso_checksum
  output_directory = var.output_directory
  disk_size        = var.disk_size
  format           = var.format
  accelerator      = var.accelerator
  headless         = var.headless
  http_directory   = var.http_directory
  boot_wait        = var.boot_wait
  boot_command = [
    "<esc><enter><wait>",
    "linux console=ttyS0,115200n8 console=tty0 autoyast=http://{{ .HTTPIP }}:8000/autoyast.xml autoyast_automatic=1 insecure=1<enter><wait>",
    "<enter><wait5>"
  ]
  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  ssh_wait_timeout = var.ssh_wait_timeout
  ssh_port         = var.ssh_port
  net_device       = var.net_device
  qemuargs = [
    ["-m", "${var.memory}M"],
    ["-smp", "${var.cpus}"],
    ["-netdev", "user,id=mynet,hostfwd=tcp::${var.ssh_port}-:22"],
    ["-device", "${var.net_device},netdev=mynet"],
    ["-serial", "file:serial.log"]
  ]
}

build {
  sources = ["source.qemu.opensuse"]

  provisioner "file" {
    source      = "scripts/setup.sh"
    destination = "/tmp/setup.sh"
  }

  provisioner "shell" {
    inline = [
      "#!/bin/bash",
      "echo 'Starting custom provisioning script...'",
      "chmod +x /tmp/setup.sh",
      "/tmp/setup.sh",
      "echo 'Provisioning finished.'"
    ]
  }
}
