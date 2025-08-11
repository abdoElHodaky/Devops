/*resource "aws_instance" "inst_a" {
 instance_type="t3.micro"
 user_data="echo inst_a"
 ami=data.aws_ami.ubuntu_ami.id
 //key_name="${data.aws_key_pair.keypr_a.key_name}"
 //depends_on=[aws_key_pair.keypr_a_resrce]

 tags= {
  Name="inst_a"
 }
}
*/
