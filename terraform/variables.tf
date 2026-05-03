variable "aws_region" {
  description = "AWS Region"
  default     = "ap-south-1"   # Mumbai - lowest latency for India
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  default     = "streamapp-cluster"
}
