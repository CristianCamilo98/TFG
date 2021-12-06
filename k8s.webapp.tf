resource "kubernetes_service_account" "sa_webapp" {
  metadata {
    name = "webapp"
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name
  }
}

resource "kubernetes_deployment" "webapp" {
  metadata {
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name
    name = "webapp"
    labels = {
      app = "webapp"
      version = "v1"
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "webapp"
        version = "v1"
      }
    }
    template {
      metadata {
        labels = {
          app = "webapp"
          version = "v1"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.sa_webapp.metadata.0.name
        container {
          env {
            name = "OPENWEATHERMAP_API_KEY"
            value = "556f63a821a1681ae3a3b9dd947c33da"
          }
          image = "eu.gcr.io/projecto-demo-290916/flask-app:2021111401"
          name  = "webapp"
          image_pull_policy = "Always"
          port {
            container_port = 8080
            name = "http"
            protocol = "TCP"
            }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
     spec.0.replicas
    ]
  }
}
