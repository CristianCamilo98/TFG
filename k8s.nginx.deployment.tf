resource "kubernetes_deployment" "nginx_deployment" {
  metadata {
    name      = "nginx-deployment"
    namespace = "default"
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "eu.gcr.io/projecto-demo-290916/nginx"
          name  = "nginx"

          resources {
            limits = {
              cpu    = "1"
              memory = "1Gi"
            }
            requests = {
              cpu    = "250m"
              memory = "125Mi"
            }
          }
          port {
            name           = "nginx-entry"
            container_port = 80
            protocol       = "TCP"
          } 
        }
      }
    }
  }
}

