variable "region" {
  default     = "sa-east-1"
  description = "Region to deploy the infrastructure"
}

variable "profile" {
  default     = "fiap-env"
  description = "Profile to deploy the infrastructure"
}

variable "app_name" {
  default     = "fiap-pedidos"
  description = "Application name"
}

variable "aws_account_id" {
  description = "AWS Account ID"
}