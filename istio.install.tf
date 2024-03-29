resource "null_resource" "install_istio" {
  triggers = {
    cluster_ep = google_container_cluster.gke.endpoint
  }

  provisioner "local-exec" {
    command = <<EOT
    gcloud container clusters get-credentials projecto-demo-290916-gke --zone europe-west1-b --project projecto-demo-290916
    kubectx gke_projecto-demo-290916_europe-west1-b_projecto-demo-290916-gke
    istioctl install --set profile=demo -y
    sleep 10
    EOT
  }

  depends_on = [google_container_node_pool.np]
}
