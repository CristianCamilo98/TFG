resource "google_container_cluster" "gke" {
  name     = "${var.project_id}-gke"
  location                  = var.zone
  initial_node_count        = 1
  remove_default_node_pool  = true
  default_max_pods_per_node = 32


  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.101.192.0/21"
    services_ipv4_cidr_block = "10.101.200.0/25"
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }
  }



  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  depends_on = [google_project_service.gke]
}


