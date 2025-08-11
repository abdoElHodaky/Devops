/*resource "aws_eip" "inst_eip_a" {
 instance=aws_instance.inst_a.id

 provisioner "local-exec" {
  command="echo ${self.public_dns}"
 }
}
*/
