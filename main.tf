provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "praveenkubernetesbucket" {
  bucket = "my-unique-terraform-bucket-12345" # bucket name must be globally unique
}
