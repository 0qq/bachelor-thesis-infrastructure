output "kubernetes_master_public_ip" {
  value = module.kubernetes.master_public_ip
}

output "jenkins_master_public_ip" {
  value = module.jenkins.master_public_ip
}
