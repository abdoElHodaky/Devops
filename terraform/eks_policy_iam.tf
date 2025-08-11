/*resource "aws_eks_access_entry" "abdoarh__eks_entry" {
  cluster_name  = data.aws_eks_cluster.eks_cluster.name
  principal_arn = data.aws_iam_user.abdoarh_iam.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "abdoarh_AmazonEKSAdminPolicy" {
  cluster_name  = data.aws_eks_cluster.eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = aws_eks_access_entry.abdoarh__eks_entry.principal_arn

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_policy_association" "abdoarh_AmazonEKSClusterAdminPolicy" {
  cluster_name  = data.aws_eks_cluster.eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_eks_access_entry.abdoarh__eks_entry.principal_arn

  access_scope {
    type = "cluster"
  }
}
*/
