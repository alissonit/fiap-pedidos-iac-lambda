terraform {
  backend "s3" {
    bucket  = "management-state-tf"
    key     = "lambda/terraform.tfstate"
    region  = "sa-east-1"
    profile = "fiap-env"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}