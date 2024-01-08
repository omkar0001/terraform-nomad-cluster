terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.29.0"
    }
  }
  cloud {
    organization = "DoctorPlan"
    workspaces {
      project = "Backend"
      tags = ["doctorplan"]
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
