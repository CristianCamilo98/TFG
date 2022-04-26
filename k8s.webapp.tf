resource "kubernetes_service_account" "sa_webapp" {
  metadata {
    name = "webapp"
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name
  }
}

resource "kubernetes_service" "webapp_service" {
  metadata {
    name = "webapp"
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name
    labels = {
      app = "webapp"
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment.webapp.metadata.0.labels.app   
    }
    port {
      port        = 80
      target_port = 8080
      protocol    = "TCP"
      name        = "http"
    }
    type = "ClusterIP"
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
          env {
            name = "CALL_BACKEND"
            value = "http://simple-backend"
          }
          image = "eu.gcr.io/projecto-demo-290916/flask-app:resilencia-timeout"
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
}

