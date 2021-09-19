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
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "webapp"
      }
    }
    template {
      metadata {
        labels = {
          app = "webapp"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.sa_webapp.metadata.0.name
        container {
          env {
            name = "KUBERNETES_NAMESPACE"
            value = kubernetes_namespace.istio_namespace.metadata.0.name
          }
          env {
            name = "CATALOG_SERVICE_HOST"
            value = "catalog.istioinaction"
          }
          env {
            name = "CATALOG_SERVICE_PORT"
            value = "80"
          }
          env {
            name  = "FORUM_SERVICE_HOST"
            value = "forum.istioinaction"
          }
          env {
            name = "FORUM_SERVICE_PORT"
            value = "80"
          }
           
          image = "eu.gcr.io/projecto-demo-290916/istioinaction/webapp"
          name  = "webapp"
          image_pull_policy = "IfNotPresent"
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
