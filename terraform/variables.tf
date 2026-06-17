variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "db_password" {
  description = "RDS root password"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "RDS username"
  type        = string
  default     = "traveloop"
}

variable "domain_name" {
  description = "Domain name for ingress"
  type        = string
  default     = "traveloop.example.com"
}
