# Configuración del proveedor de GCP
provider "google" {
  credentials = file("login.json") # this line is used to provide the path of the credentials file to use for authentication
  project     = var.project_id # this line is used to provide the id of the project where the resources will be created
  region      = var.region # this line is used to provide the region where the resources will be created
}



# resource "google_compute_project_metadata_item" "ssh-keys" {
#   key   = "ssh-keys"
#   value = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+n/ep6OtSCBnsdTbs4DZuVip5FFmnsjhd9znSiAVa44KcR2Rm7I2E2DBmEM6Ouk6DwhKlpa3mZdAwUphALzV+TCC4pBD0HvjJ0PdnWSwRJl1be7Pp3NAhpicnkAzcvIfc2zO1ruFs86mA6BupVIrXs+5GCsBMJct80pqLO4ILejnhgi7dBf0Ewn4AqA4F1sVoXL8+QTAByB8ktrK+WaYN/y1GJK554jyYTX2jA/2hoFLBSymygQVZlhjAWeYOidKQx6kxbmePUJr/pdLOpQGzBT+8I9/fSO3tV4yn7/ITyWvRheejlQmt6o0miD7ZkJ90J/l39dq6E89fqSI8U6q73ELLMMfp9EOoXCk7CcgPB8fHVTNKSlUko6FrLzhYfEWE2zcShpdS9D/x2dkMVvHocMiW/3Kg23Au+EquWRf3F1qOd6zEmDakjOTWlL/+Sec42+fk9gDEQn1nTJN/G7xEFI3ult2mpv99Pv8/H2BS2xvKJmEH0FMpleAwnM6zGe8= diego@CarlosMorales"
# }
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
#   metadata_startup_script = "sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" && sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io"
#   metadata = {
#     ssh-keys = "diego:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDELdtwm4DfpTbxtDn7CHsH1x7ZaLXffPeOjE3dkktFfhnh4dhtHu7eZoCE4nXhtOM6379zsf6UwC3l4L/M9Q+p2Oct3mUPmvRgwNt4yUIGHw33e9bldBgENKDbVK175h3cFrN7X3N0rBX6qkcR7bLOYxwwXvNJwa2oiNFwAO/LWO8JbUGQlMlVNwvJIJJGC3BP06ryy9wtlWngiecESMUK2MeNURJH9j2XRkkhHapQVm9rZqv4/j06jIfBycVY25ZzGWevg7fMSEke2v52MCQEPScvOGWU0UP3bGBNk4/3emlwlZiTWtDuhu2Hi9xJezbVTjjy35OYbcwsPmj+7OqxJXLeUis2ybpx0RiTOn0d54t92WYYxp0= diego@CarlosMorales"
#   }

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
    ports    = ["80", "443", "22"]
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