resource "kubernetes_service_account" "simple_backend" {
  metadata {
    name = "simple-backend"
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name
  }
}


resource "kubernetes_service" "simple_backend" {
  metadata {
    name = "simple-backend"
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name

    labels = {
      app = "simple-backend"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = "8080"
    }

    selector = {
      app = "simple-backend"
    }
  }
}

resource "kubernetes_deployment" "simple_backend_1" {
  metadata {
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name
    name = "simple-backend-1"

    labels = {
      app = "simple-backend"
      version = "v1-fast"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "simple-backend"
        version = "v1-fast"
      }
    }

    template {
      metadata {
        labels = {
          version = "v1-fast"
          app = "simple-backend"
        }
      }

      spec {
        container {
          name  = "simple-backend"
          image = "nicholasjackson/fake-service:v0.17.0"

          port {
            name           = "http"
            container_port = 8080
            protocol       = "TCP"
          }

          env {
            name  = "LISTEN_ADDR"
            value = "0.0.0.0:8080"
          }

          env {
            name  = "SERVER_TYPE"
            value = "http"
          }

          env {
            name  = "NAME"
            value = "simple-backend"
          }

          env {
            name  = "MESSAGE"
            value = "Hello from simple-backend-1"
          }

          env {
            name  = "TIMING_VARIANCE"
            value = "40ms"
          }

          env {
            name  = "TIMING_50_PERCENTILE"
            value = "100ms"
          }

          env {
            name = "KUBERNETES_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          image_pull_policy = "IfNotPresent"
        }

        service_account_name = "simple-backend"
      }
    }
  }
}

resource "kubernetes_deployment" "simple_backend_2" {
  metadata {
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name
    name = "simple-backend-2"

    labels = {
      app = "simple-backend"
      version = "v2-slow"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        version = "v2-slow"
        app = "simple-backend"
      }
    }

    template {
      metadata {
        labels = {
          version = "v2-slow"
          app = "simple-backend"
        }
      }

      spec {
        container {
          name  = "simple-backend"
          image = "nicholasjackson/fake-service:v0.17.0"

          port {
            name           = "http"
            container_port = 8080
            protocol       = "TCP"
          }

          env {
            name  = "LISTEN_ADDR"
            value = "0.0.0.0:8080"
          }

          env {
            name  = "SERVER_TYPE"
            value = "http"
          }

          env {
            name  = "NAME"
            value = "simple-backend"
          }

          env {
            name  = "MESSAGE"
            value = "Hello from simple-backend-slow"
          }

          env {
            name  = "TIMING_50_PERCENTILE"
            value = "250ms"
          }

          env {
            name  = "ERROR_RATE"
            value = "0.3"
          }

          env {
            name  = "ERROR_TYPE"
            value = "http_error"
          }

          env {
            name  = "ERROR_CODE"
            value = "500"
          }

          env {
            name = "KUBERNETES_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          image_pull_policy = "IfNotPresent"
        }

        service_account_name = "simple-backend"
      }
    }
  }
}

