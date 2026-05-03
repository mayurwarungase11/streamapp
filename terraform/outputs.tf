output "ecr_repository_url" {
  description = "ECR Repository URL - put this in Jenkinsfile"
  value       = aws_ecr_repository.streamapp.repository_url
}

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = module.eks.cluster_endpoint
}
