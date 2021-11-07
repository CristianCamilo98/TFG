resource "kubernetes_service_account" "sa_webappv2" {
  metadata {
    name = "webappv2"
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name
  }
}

resource "kubernetes_service" "webappv2_service" {
  metadata {
    name = "webappv2"
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name
    labels = {
      app = "webappv2"
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment.webappv2.metadata.0.labels.app   
    }
    port {
      port        = 80
      target_port = 5000
      protocol    = "TCP"
      name        = "http"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "webappv2" {
  metadata {
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name
    name = "webappv2"
    labels = {
      app = "webappv2"
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "webappv2"
      }
    }
    template {
      metadata {
        labels = {
          app = "webappv2"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.sa_webappv2.metadata.0.name
        container {
          env {
            name = "OPENWEATHERMAP_API_KEY"
            value = "556f63a821a1681ae3a3b9dd947c33da"
          }
           
          image = "eu.gcr.io/projecto-demo-290916/flask-app:2021110701"
          name  = "webappv2"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 5000
            name = "http"
            protocol = "TCP"
            }
        }
      }
    }
  }
}
