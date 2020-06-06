# Creating a S3 bucket for web hosting

resource "aws_s3_bucket" "unicorn" {
  bucket  = var.bucket_name
  acl     = "public-read"
  policy  = file("policy.json")

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name  = "s3-bucket-${var.tag_name}"
  }
}
