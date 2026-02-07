# TaskManager Infrastructure - Terraform
# VULN: Configuraciones inseguras para testing de Checkov

terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  
  # VULN: Backend sin cifrado (CKV_AWS_S3_BUCKET_ENCRYPTION)
  backend "s3" {
    bucket = "taskmanager-tfstate"
    key    = "prod/terraform.tfstate"
    region = "eu-west-1"
    # VULN: Sin DynamoDB lock table
    # VULN: Sin encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "TaskManager"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "environment" {
  default = "production"
}

variable "db_password" {
  description = "Database password"
  type        = string
  # VULN: Default password en variable (CKV_AWS_79)
  default     = "SuperSecretPass123"
}
