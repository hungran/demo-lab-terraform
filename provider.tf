terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# provider "aws" {
#   profile = "hungran"
#   region  = var.region
#   default_tags {
#     tags = var.default_tags
#   }
# }