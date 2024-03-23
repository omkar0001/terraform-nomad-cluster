terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.29.0"
    }
  }
  cloud {
    organization = "test"
    workspaces {
      project = "test"
      tags = ["test"]
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
