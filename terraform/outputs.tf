output "k8s_master_public_ip" {
  value = aws_eip.k8s_master.public_ip
}
