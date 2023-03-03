# Configuración del proveedor de GCP
provider "google" {
  project = "tu-proyecto-de-gcp"
  region  = "us-central1"
  zone    = "us-central1-a"
}

# Definición de la instancia de VM
resource "google_compute_instance" "mi_instancia_vm" {
  name         = "nombre-de-tu-vm"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Puedes utilizar una dirección IP estática o dinámica
      // Aquí se está utilizando una dirección IP dinámica
    }
  }

  # Configuración del firewall para permitir el tráfico HTTP y HTTPS
  tags = ["http-server", "https-server"]
}

# Configuración del firewall
resource "google_compute_firewall" "mi_firewall" {
  name    = "nombre-de-tu-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server", "https-server"]
}
