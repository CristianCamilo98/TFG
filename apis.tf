resource "google_project_service" "service_account" {
  service = "container.googleapis.com"
}
