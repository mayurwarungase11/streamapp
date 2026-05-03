# VPC for EKS
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "streamapp-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true    # Cost saving for dev/demo

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.28"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Worker nodes
  eks_managed_node_groups = {
    streamapp_nodes = {
      min_size       = 1
      max_size       = 3
      desired_size   = 2
      instance_types = ["t3.medium"]   # Cost-effective for demo
    }
  }

  tags = {
    Project   = "StreamApp"
    ManagedBy = "Terraform"
  }
}
