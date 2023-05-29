provider "google" {
  credentials = file(var.path_key)
}

resource "google_compute_instance" "bastion" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.location
  project      = var.project

  boot_disk {
    initialize_params {
      image = var.so_image
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = var.ip_estatica  
    }
  }

  
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_path)}"
  }

  // usuario con priv de root
  provisioner "remote-exec" {
    inline = [
      "sudo useradd -m -s /bin/bash ${var.ssh_user}",  
      "sudo usermod -aG sudo ${var.ssh_user}",  
      "echo '${var.ssh_user}:${var.ssh_pass}' | sudo chpasswd", 
      "sudo sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config", 
      "sudo service ssh restart" 
    ]
  }

  tags = ["bastion"]
}
