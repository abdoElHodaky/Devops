/*resource "local_file" "me" {
 count=var.times
 filename="./me-${count.index}.txt"
 content="ME are I "

}

resource "aws_s3_bucket" "files_bucket" {
 bucket="fileslz"
 force_destroy=true
// region="us-east-1"
}

resource "aws_s3_object" "upload"{
  count=var.times
  key="me.txt"
  source="${local_file.me[count.index].filename}"
  bucket=aws_s3_bucket.files_bucket.bucket
 //region="us-east-1"

}
*/
