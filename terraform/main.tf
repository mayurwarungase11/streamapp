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

# ECR Repository - stores your Docker images
resource "aws_ecr_repository" "streamapp" {
  name                 = "streamapp"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = "StreamApp"
    ManagedBy = "Terraform"
  }
}

# Keep only last 10 images - saves cost
resource "aws_ecr_lifecycle_policy" "streamapp" {
  repository = aws_ecr_repository.streamapp.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 10 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
      action = { type = "expire" }
    }]
  })
}
