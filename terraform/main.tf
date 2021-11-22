terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "remote" {
    organization = "samuelm333"

    workspaces {
      name = "container-factorial"
    }
  }
}
