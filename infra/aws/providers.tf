terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket  = "pyforum-terraform-state-156168428597"
    key     = "ecs/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}
