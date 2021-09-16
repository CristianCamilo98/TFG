variable "project_id" {
  description = "projecto-demo-290916"
}

variable "region" {
  description = "europe-west1"
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

#Firewall rule allowing traffic

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc.name


  allow {
    protocol = "tcp"
    ports    = ["80", "8080","30000"]
  }

}
