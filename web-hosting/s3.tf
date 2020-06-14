# Creating a S3 bucket for web hosting
resource "aws_s3_bucket" "unicorn" {
  bucket            = var.bucket_name
  acl               = "public-read"
  policy            = file("policy_json/aws_s3_bucket_policy.json")

  website {
    index_document  = "index.html"
    error_document  = "error.html"
  }

  tags = {
    Name  = "s3-${var.tag_name}"
  }
}

# provisioner invokes a process with a local excutable
# to upload multi files in the website directory into s3 bucket using aws cli
resource "aws_s3_bucket_object" "test" {
  bucket            = aws_s3_bucket.unicorn.id
  key               = "website"

  provisioner "local-exec" {
    command         = "aws s3 cp website/ s3://${aws_s3_bucket.unicorn.id} --recursive"
  }

}
