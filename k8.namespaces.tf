resource "kubernetes_namespace" "istio_namespace" {
  metadata {
    annotations = {
      name = "Istio-namespace"
    }

    labels = {
    istio-injection = "enabled"
    }
    name = "istioinaction"
  }
  depends_on = [google_container_node_pool.primary_nodes]
}

