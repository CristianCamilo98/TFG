resource "kubernetes_service" "nginx_LB" {
  metadata {
    name = "nginx-loadbalancer"
  }
  spec {
    selector = {
      app = "nginx"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
