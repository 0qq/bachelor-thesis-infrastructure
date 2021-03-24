output "endpoint" {
  value = aws_eks_cluster.this.endpoint
}


output "ca_cert" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}


output "token" {
  value     = data.aws_eks_cluster_auth.this.token
  sensitive = true
}


output "node_group" {
  value = aws_eks_node_group.this
}
