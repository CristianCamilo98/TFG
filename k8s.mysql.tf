resource "kubernetes_stateful_set" "mysql" {
  metadata {
    name = "mysql"
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name 
    labels = {
      app = "mysql"
    }
  }

  spec {
    pod_management_policy  = "OrderedReady"
    replicas               = 1

    selector {
      match_labels = {
        app = "mysql"
      }
    }

    service_name = "mysql"

    update_strategy {
      type = "RollingUpdate"        
        rolling_update {
        partition = 1
      }
    }
    volume_claim_template {
      metadata {
        name = "mysql-data"
        namespace = kubernetes_namespace.istio_namespace.metadata.0.name 
      }
    
      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = "standard"
    
        resources {
          requests = {
             storage = "16Gi"
            }
          }
        }
    }
    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        
        container {
          name              = "mysql"
          image             = "eu.gcr.io/projecto-demo-290916/mysql:pro202111301"
          image_pull_policy = "Always"

          port {
            container_port = 3306
          }

          env { 
             name = "MYSQL_ROOT_PASSWORD"
             value = "securepassword"
           }
           env { 
             name = "MYSQL_DATABASE"
             value = "flask_pre_models"
           }
           env { 
             name = "MYSQL_USER"
             value = "flask_pre"
           }
           env { 
             name = "MYSQL_PASSWORD"
             value = "securepassword"
           }

          volume_mount {
            name       = "mysql-data"
            mount_path = "/var/lib/mysql"
            sub_path   = "mysql"
          }

          resources {
            limits = {
              cpu    = "250m"
              memory = "1024Mi"
            }

            requests = {
              cpu    = "250m"
              memory = "1024Mi"
            }
          }
        }
      }
    }
  }
depends_on = [kubernetes_service.mysql_service]
}

resource "kubernetes_service" "mysql_service" {
  metadata {
    name = "mysql"
    namespace = kubernetes_namespace.istio_namespace.metadata.0.name
    labels = {
      app = "mysql"
    }
  }
  spec {
    selector = {
      app = "mysql"
    }
    port {
      port        = 3306
      protocol    = "TCP"
      name        = "mysql"
    }
    cluster_ip = "None"
  }
}
