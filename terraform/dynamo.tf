/*resource "aws_dynamodb_table" "filez_table" {
  name="filez"
  hash_key="FID"
  //deletion_protection_enabled=true
  read_capacity  = 20
  write_capacity = 20
  attribute {
    name="FID"
    type="N"
  }
  attribute {
    name="path"
    type="S"
  }
  attribute {
    name="name"
    type="S"
  }

 global_secondary_index {
    name               = "NameIndex"
    hash_key           = "name"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["FID"]
  }
  global_secondary_index {
    name               = "PathIndex"
    hash_key           = "path"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["FID"]
  }

}



resource "aws_dynamodb_table_item" "file_item" {
count=var.times
table_name = aws_dynamodb_table.filez_table.name
hash_key   = aws_dynamodb_table.filez_table.hash_key
item = jsonencode(
{ "FID":{"N":tostring(count.index+1)},
   "path":{"S":"${aws_s3_object.upload[count.index].source}"},
    "name":{"S":"${aws_s3_object.upload[count.index].key}"}
 }
)



}

*/

