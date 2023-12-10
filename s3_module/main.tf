resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket
  acl    = var.acl
  tags = {
    yor_trace = "cc2165ed-e139-4686-9a24-d56797629eec"
  }
}
