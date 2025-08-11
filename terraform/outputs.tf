/*output "keypr_a_fingerprint" {
  value = aws_key_pair.keypr_a_resrce.fingerprint
}

output "keypr_a_name" {
  value = aws_key_pair.keypr_a_resrce.key_name
}

output "keypr_a_id" {
  value = aws_key_pair.keypr_a_resrce.id
}
output "keype_a_pa" {
 value= aws_key_pair.keypr_a_resrce.public_key
}

output "inst_a_id" {
 value=aws_instance.inst_a.id
}

output "ami_id" {
 value=data.aws_ami.ubuntu_ami.id
}
*/
output "eks_endpoint" {
  value = data.aws_eks_cluster.eks_cluster.endpoint
} 
