resource "google_project_service" "gke" {
  service = "container.googleapis.com"
}
