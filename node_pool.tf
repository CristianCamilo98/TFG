resource "google_service_account" "tfg_account" {
  account_id   = "tfg-account"
  display_name = "Service Account"
}

resource "google_project_iam_member" "tfg_account_gcr" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.tfg_account.email}"
}



resource "google_container_node_pool" "np" {
  name       = "${google_container_cluster.gke.name}-node-pool"
  initial_node_count = 3
  cluster            = google_container_cluster.gke.name
  location           = var.zone

  autoscaling {
    min_node_count = 2
    max_node_count = 3
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    service_account = google_service_account.tfg_account.email
    preemptible  = "true"
    machine_type = "n1-standard-1"

    disk_type    = "pd-ssd"
    disk_size_gb = "50"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      location = var.zone
      machine_type = "n1-standard-1"
      cluster  = google_container_cluster.gke.name
    }

  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [google_container_cluster.gke]
}
