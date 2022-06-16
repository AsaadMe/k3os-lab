
variable "box_description" {
  type    = string
  default = "k3OS is a Linux distribution designed to remove as much OS maintenance as possible in a Kubernetes cluster"
}

variable "box_version" {
  type    = string
  default = "v0.21.5-k3s2r1"
}

variable "iso_checksum" {
  type    = string
  default = "a465b0c52ce415173f6ef38fda5d090580fbaae0970556a62f21c7db8eeb72b1"
}

variable "iso_url" {
  type    = string
  default = "https://github.com/rancher/k3os/releases/download/v0.21.5-k3s2r1/k3os-amd64.iso"
}

variable "iso_target_path" {
  type    = string
  default = "E:\\Program Files\\VirtualBox VMs\\k3os-amd64-0.21.iso"
}

variable "password" {
  type    = string
  default = "rancher"
}

source "virtualbox-iso" "k3os" {
  boot_command = [
    "<down>", "<enter>",
    "<wait20s>",
    "y", "<enter>",
    "http://{{ .HTTPIP }}:{{ .HTTPPort }}/config.yml", "<enter>",
    "y", "<enter>",
  ]
  boot_wait            = "5s"
  disk_size            = "8000"
  export_opts          = ["--manifest", "--vsys", "0", "--description", "${var.box_description}", "--version", "${var.box_version}"]
  format               = "ova"
  guest_os_type        = "Linux_64"
  rtc_time_base        = "UTC"
  http_directory       = "."
  iso_checksum         = "sha256:${var.iso_checksum}"
  iso_url			         = "${var.iso_url}"
  iso_target_path      = "${var.iso_target_path}"
  post_shutdown_delay  = "10s"
  shutdown_command     = "sudo poweroff"
  ssh_keypair_name     = ""
  ssh_private_key_file = "packer_rsa"
  ssh_timeout          = "1000s"
  ssh_username         = "rancher"
  guest_additions_mode = "disable"
  vboxmanage = [
   ["modifyvm", "{{.Name}}", "--memory", "1024"],
   ["modifyvm", "{{.Name}}", "--cpus", "1"]
]
}

build {
  sources = ["source.virtualbox-iso.k3os"]
  provisioner "file" {
  source = "master-images.tar"
  destination = "~/master-images.tar"
  }
  provisioner "shell" {
    pause_before = "10s"
    inline = ["sudo sed -i 's/PasswordAuthentication.*no/PasswordAuthentication yes/' /etc/ssh/sshd_config",
              "sudo ctr images import ~/master-images.tar",
              "sudo rm ~/master-images.tar"]
    execute_command = "{{.Vars}} bash '{{.Path}}'"
  }
  post-processor "vagrant" {
    output = "k3os_{{.Provider}}.box"
  }
}
