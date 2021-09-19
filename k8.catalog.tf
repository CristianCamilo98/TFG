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

resource "kubernetes_service_account" "service_account_catalog" {
  metadata {
    name = "catalog"
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name
  }
}

resource "kubernetes_service" "catalog_service" {
  metadata {
    name = "catalog"
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name
    labels = {
      app = "catalog"
      }
  }
  spec {
    selector = {
      app = kubernetes_deployment.catalog.metadata.0.labels.app   
    }
    port {
      name        = "http"
      port        = 80
      target_port = 3000
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "catalog" {
  metadata {
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name
    name = "catalog"
    labels = {
      app = "catalog"
      version = "v1"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "catalog"
        version = "v1"
      }
    }
    template {
      metadata {
        labels = {
          app = "catalog"
          version = "v1"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.service_account_catalog.metadata.0.name
        container {
          env {
            name = kubernetes_namespace.istio_namespace.metadata.0.name
            value = kubernetes_service_account.service_account_catalog.metadata.0.name
            }
          image = "eu.gcr.io/projecto-demo-290916/istioinaction/catalog"
          name  = "catalog"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 3000
            name = "http"
            protocol = "TCP"
            }
        }
      }
    }
  }
}
