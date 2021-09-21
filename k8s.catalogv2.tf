resource "kubernetes_deployment" "catalogv2" {
  metadata {
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name
    name = "catalog-v2"
    labels = {
      app = "catalog"
      version = "v2"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "catalog"
        version = "v2"
      }
    }
    template {
      metadata {
        labels = {
          app = "catalog"
          version = "v2"
        }
      }

      spec {
        container {
          env {
            name = "KUBERNETES_NAMESPACE"
            value = kubernetes_namespace.istio_namespace.metadata.0.name
            }
          env {
            name = "SHOW_IMAGE"
            value = "true"
            }
          image = "eu.gcr.io/projecto-demo-290916/istioinaction/catalog"
          name  = "catalog"
          port {
            container_port = 3000
            name = "http"
            protocol = "TCP"
            }
          security_context {
            privileged = "false"
            }
        }
      }
    }
  }
}
