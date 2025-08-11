/*resource "kubernetes_service" "nestcms" {
  metadata {
    name = "nestcms"
    labels = {
      app = "nestcms"
    }
  }

  spec {
    selector = {
      app = "nestcms"
    }

    port {
      port        = 80
      target_port = 3000
      protocol    = "TCP"
      node_port   = 30080
    }

    type = "NodePort"
  }
}
*/
