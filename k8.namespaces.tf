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
  depends_on = [null_resource.install_istio]
}

