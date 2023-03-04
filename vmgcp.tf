# Configuración del proveedor de GCP
provider "google" {
  credentials = file("login.json") # this line is used to provide the path of the credentials file to use for authentication
  project     = var.project_id # this line is used to provide the id of the project where the resources will be created
  region      = var.region # this line is used to provide the region where the resources will be created
}
# Definición de la instancia de VM
resource "google_compute_instance" "default" {
  name         = var.myvmname
  zone = var.zone
  machine_type = var.myvmtype

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Puedes utilizar una dirección IP estática o dinámica
      // Aquí se está utilizando una dirección IP dinámica
    }
  }
  metadata_startup_script = "sudo apt-get update && sudo apt-get install -y apache2"

  # Configuración del firewall para permitir el tráfico HTTP y HTTPS
  tags = ["http-server", "https-server"]
}

# # Recurso de null_resource para aprovisionamiento con Ansible
# resource "null_resource" "default" {
#   # Dependencia del recurso de instancia de VM para asegurar que se cree primero
#   depends_on = [maquina1.default]

#   # Configuración de aprovisionamiento de Ansible
#   provisioner "local-exec" {
#     command     = "ansible-playbook -i '${google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip},' playbook.yaml"
#     working_dir = "${path.module}/ansible"
#   }
# }



# Configuración del firewall
resource "google_compute_firewall" "default" {
  name    = var.myfirewallname
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server", "https-server"]
}


#----------------------------------------------------------------------------------------

# resource "google_compute_instance" "default" {
#   name         = "test"
#   machine_type = "e2-micro"
#   zone         = "us-central1-a"

#   tags = ["http-server", "https-server"]

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#       labels = {
#         my_label = "value"
#       }
#     }
#   }

#   // Local SSD disk
#   scratch_disk {
#     interface = "SCSI"
#   }

#   network_interface {
#     network = "default"

#     access_config {
#       // Ephemeral public IP
#     }
#   }

#   metadata = {
#     foo = "bar"
#   }

#   metadata_startup_script = "echo hi > /test.txt"

#   service_account {
#     # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
#     email  = "robertocsm1220@gmail.com"
#     scopes = ["cloud-platform"]
#   }
# }