/*resource "kubernetes_role" "secret_creator" {
  metadata {
    name      = "secret-creator"
    namespace = "default"
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["create"]
  }
}

resource "kubernetes_role_binding" "secret_creator_binding" {
  metadata {
    name      = "secret-creator-binding"
    namespace = "default"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.secret_creator.metadata[0].name
  }

  subject {
    kind      = "User"
    name      = "${data.aws_iam_user.abdoarh_iam.user_name}"
    api_group = "rbac.authorization.k8s.io"
  }
}
*//*
resource "kubernetes_secret" "docker_secret" {
  metadata {
    name      = "dockersecret"
    namespace = "default"
  }
  data = {
    "username" = base64encode("abdoElHodaky")
    "password" = base64encode("${var.DOCKER_PAT}")
  }
  type = "kubernetes.io/dockerconfigjson"

}

*/
