variable "iso_url" {
  description = "Specifies the URL of the OpenSUSE Leap XY.Z ISO to be used for installation. Default is 'https://download.opensuse.org/distribution/leap/15.6/iso/openSUSE-Leap-15.6-NET-x86_64-Current.iso'."
  type        = string
  default     = "https://download.opensuse.org/distribution/leap/15.6/iso/openSUSE-Leap-15.6-NET-x86_64-Current.iso"
}

variable "iso_checksum" {
  description = "Specifies the SHA256 checksum of the ISO to verify its integrity. Default is '0984b36d0f420487f2766733ff8f9d779ade81d432b08e40e852a675313750bb'."
  type        = string
  default     = "0984b36d0f420487f2766733ff8f9d779ade81d432b08e40e852a675313750bb"
}

variable "output_directory" {
  description = "Specifies the directory where Packer will place the generated VM image. Default is 'artifacts'."
  type        = string
  default     = "artifacts"
}

variable "disk_size" {
  description = "Specifies the size of the virtual disk for the VM (e.g., '10G'). Default is '10G'."
  type        = string
  default     = "10G"
}

variable "format" {
  description = "Specifies the disk image format for the VM. Default is 'qcow2'."
  type        = string
  default     = "qcow2"
}

variable "accelerator" {
  description = "Specifies the QEMU accelerator to use (e.g., 'tcg' for software emulation, 'kvm' for hardware acceleration). Default is 'tcg'."
  type        = string
  default     = "tcg"
}

variable "headless" {
  description = "Specifies whether the VM should start in headless mode (no GUI). Default is 'true'."
  type        = bool
  default     = true
}

variable "http_directory" {
  description = "Specifies the directory where Packer will serve the AutoYaST profile via HTTP. Default is 'http/'."
  type        = string
  default     = "packer/http"
}

variable "boot_wait" {
  description = "Specifies how long Packer should wait after the VM starts before sending boot commands. Default is '5s'."
  type        = string
  default     = "5s"
}

variable "ssh_username" {
  description = "Specifies the SSH username to connect to the VM after installation. Default is 'root'."
  type        = string
  default     = "root"
}

variable "ssh_password" {
  description = "Specifies the SSH password for the user to connect after installation. Default is 'changeme'."
  type        = string
  default     = "changeme"
}

variable "ssh_wait_timeout" {
  description = "Specifies how long Packer should wait for SSH to become available on the VM after boot. Default is '10m'."
  type        = string
  default     = "30m"
}

variable "ssh_port" {
  description = "Specifies the host port that forwards to the VM's SSH port (22). This is required when running under Docker Desktop on macOS/Windows where host networking is not available. Default is '2222'."
  type        = number
  default     = 2222
}

variable "net_device" {
  description = "Specifies the network interface type for the VM (e.g., 'virtio-net'). Default is 'virtio-net'."
  type        = string
  default     = "virtio-net"
}

variable "memory" {
  description = "Specifies the amount of RAM (in MB) assigned to the QEMU VM. Default is '2048'."
  type        = number
  default     = 2048
}

variable "cpus" {
  description = "Specifies the number of CPU cores assigned to the QEMU VM. Default is '2'."
  type        = number
  default     = 2
}
