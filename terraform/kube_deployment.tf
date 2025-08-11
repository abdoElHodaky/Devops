/*resource "kubernetes_deployment" "nestcms" {
  metadata {
    name = "nestcms"
    labels = {
      app = "nestcms"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nestcms"
      }
    }

    template {
      metadata {
        labels = {
          app = "nestcms"
        }
      }

      spec {
        image_pull_secrets {
          name = "dockersecret" # <-- your secret name here
        }
        container {
          name  = "nestcms"
          image = "abdoelhodaky/nestcms:latest"
          port {
            container_port = 3000
          }
          resources {
            requests = {
              memory = "256Mi"
              cpu    = "250m"
            }
            limits = {
              memory = "512Mi"
              cpu    = "500m"
            }
          }
          # Add env vars here if needed
          # env {
          #   name  = "NODE_ENV"
          #   value = "production"
          # }
        }
      }
    }
  }
}
*/
