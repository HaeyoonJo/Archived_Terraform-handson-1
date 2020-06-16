variable "allowed_ip_addr" {}

variable "access_key_id" {}

variable "secret_access_key" {}

variable "aws_region" {
  default = "eu-central-1"
}

variable "vpc_name" {
  description = "tf_infra"
}

variable "availability_zones" {
  type        = list(string)
  description = "A comma-delimited list of availability zones for the VPC."
}

variable "cidr_numeral" {
  description = "The VPC CIDR numeral (10.0.x.0/16)"
}

variable "cidr_numeral_public" {
  default = {
    "0" = "0"
    "1" = "16"
    "2" = "32"
  }
}
