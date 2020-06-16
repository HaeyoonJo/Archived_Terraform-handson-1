variable "access_key_id" {}

variable "secret_access_key" {}

variable "bucket_name" {}

variable "account_id" {}

variable "dynamodb_table_name" {}

variable "aws_region" {
  default = "eu-central-1"
}

variable "tag_name" {
  description = "tf-unicorn website setting"
}
