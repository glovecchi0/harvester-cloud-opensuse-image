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
    "linux textmode=1 autoyast=http://{{ .HTTPIP }}:{{ .HTTPPort }}/autoyast.xml<enter><wait>",
    "<enter><wait5>"
  ]
  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  ssh_wait_timeout = var.ssh_wait_timeout
  net_device       = var.net_device
  qemuargs = [
    ["-m", "${var.memory}M"],
    ["-smp", "${var.cpus}"]
  ]
  shutdown_command = "echo '${var.ssh_password}' | sudo -S systemctl poweroff"
  shutdown_timeout = var.shutdown_timeout
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
