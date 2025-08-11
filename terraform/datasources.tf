/*data "aws_key_pair" "keypr_a" {
 key_name="keypr_a"
 include_public_key=true
// depends_on=[aws_key_pair.keypr_a_rescre]
}*/

data "aws_iam_user" "abdoarh_iam" {
  user_name = "abdoarh"
}

data "aws_ami" "ubuntu_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] 
 // depends_on=[aws_inctance.inst_a]
}

data "aws_eks_cluster" "eks_cluster" {
 name= "${var.EKS_CLUSTER_NAME}"
 region=var.eks_region
}

