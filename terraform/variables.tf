variable "times" {
 type=number
 default=2

}

variable "eks_region" {
 type=string
 default="eu-central-1"
}

variable "GHCR_PAT" {
 type=string
}
variable "EKS_CLUSTER_NAME"{
 type=string
}
variable "DOCKER_PAT"{
 type=string 
}


/*variable "KUBERNETES_MASTER" {
 type=string
 default=data.aws_eks_cluster.attractive_duck.endpoint
}
*/
