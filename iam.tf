resource "google_project_iam_member" "gke_user" {
  role    = "projects/${var.project_id}/roles/${google_project_iam_custom_role.role_istio.role_id}"
  member  = "user:criscamota199890@gmail.com"
  depends_on = [
       google_project_iam_custom_role.role_istio,
	]
}

resource "google_project_iam_custom_role" "role_istio" {
  role_id     = "istio"
  title       = "Role for Istio"
  description = "Rol a usar por Istio"
  permissions = ["container.pods.list"]
}
