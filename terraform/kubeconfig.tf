data "aws_eks_cluster_auth" "eks_auth" {
  name = var.EKS_CLUSTER_NAME
  region=var.eks_region

}
resource "local_file" "kubeconfig" {
    content = templatefile("${path.module}/kubeconfig.tpl", {
    cluster_name = "${var.EKS_CLUSTER_NAME}",
    clusterca    = data.aws_eks_cluster.eks_cluster.certificate_authority[0].data,
    endpoint     = data.aws_eks_cluster.eks_cluster.endpoint,
    user_name    = data.aws_iam_user.abdoarh_iam.user_name
    token        = data.aws_eks_cluster_auth.eks_auth.token
  })
  filename = "${path.module}/kubeconfig.yaml"
}

/*resource "aws_s3_object" "kbconf" {
 key="kbconf"
 bucket=aws_s3_bucket.files_bucket.bucket
 source=local_file.kubeconfig.filename
}
*/
