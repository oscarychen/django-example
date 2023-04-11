terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.62"
    }
  }

  backend "s3" {
    bucket         = "django-example-terraform-state"
    dynamodb_table = "django-example-terraform-lock"
    key            = "django-example.tfstate"
    encrypt        = true
    profile        = "default"
    region         = "us-west-2"
  }
}