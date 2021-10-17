resource "kubernetes_config_map" "postgress" {
  metadata {
    name = "postgres-config"
  }

  data = {
    POSTGRES_DB             = "postgresdb"
    POSTGRES_USER           = "postgresadmin"
    POSTGRES_PASSWORD       = "admin123"
  }

}
