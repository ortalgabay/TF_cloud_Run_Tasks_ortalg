terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#Random for TFC 
resource "random_id" "random" {
  keepers = {
    uuid = uuid()
  }

  byte_length = 11

}

output "random" {
  value = random_id.random.hex
}

#terragoat resources
resource "aws_s3_bucket" "data" {
  # Test
  # bucket is public
  # bucket is not encrypted
  # bucket does not have access logs
  # bucket does not have versioning
  bucket = "data"

  #tests vars
  acl = var.acl_value

  force_destroy = true
  tags = {
    Name        = "data"
    Environment = "env"
    Test        = "This is a TFC test"
    yor_trace   = "bf7a7d14-30b1-4c69-9d03-b7f18f2a794d"
  }
}

resource "aws_s3_bucket_object" "data_object" {
  bucket = aws_s3_bucket.data.id
  key    = "customer-master.xlsx"
  source = "resources/customer-master.xlsx"
  tags = {
    Name        = "customer-master"
    Environment = "env"
    yor_trace   = "c3308207-0622-4765-870a-0159ddcd3adc"
  }
}

resource "aws_s3_bucket" "financials" {
  # bucket is not encrypted
  # bucket does not have access logs
  # bucket does not have versioning
  bucket        = "financials"
  acl           = "private"
  force_destroy = true
  tags = {
    Name        = "financials"
    Environment = "financials"
    yor_trace   = "4628f1bb-44aa-4248-b614-d3ddc3835f57"
  }

}

resource "aws_s3_bucket" "operations" {

  # bucket is not encrypted
  # bucket does not have access logs
  bucket = "operations"
  acl    = "private"
  versioning {
    enabled = true
  }
  force_destroy = true
  tags = {
    Name        = "operations"
    Environment = "operations"
    yor_trace   = "ffebf5df-cb23-4915-9dbf-5ca338ed60b0"
  }

}

#test modules
module "s3_bucket" {
  source = "./s3_module"
  bucket = var.bucket
  acl    = var.acl_value
}
