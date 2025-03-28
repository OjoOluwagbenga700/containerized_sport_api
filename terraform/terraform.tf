terraform {
  required_version = ">= 1.7.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.93.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.25.0"
    }
  }


}

# Configure the AWS Provider
provider "aws" {
  region = var.region

}