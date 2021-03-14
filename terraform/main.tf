locals {
  tags = merge(var.tags, { Project = var.project })
}


provider "aws" {
  region = var.aws_region
}


module "kubernetes_master" {
  source = "./modules/kubernetes_master"

  kubeconfig_path   = var.kubeconfig_path
  instance_image_id = data.aws_ami.latest_ubuntu.id
  key_name          = aws_key_pair.default.key_name
  private_key_path  = var.private_key_path

  master_instance_type = var.k8s_master_instance_type
  master_subnet_id     = aws_subnet.main_public.id
  master_vpc_security_group_ids = [
    aws_security_group.ingress_ssh.id,
    aws_security_group.egress.id,
    aws_security_group.ingress_k8s_api_server.id
  ]

  tags = local.tags
}


module "kubernetes_worker_pool" {
  source = "./modules/kubernetes_worker_pool"

  instance_image_id = data.aws_ami.latest_ubuntu.id
  key_name          = aws_key_pair.default.key_name
  private_key_path  = var.private_key_path

  master_private_ip = module.kubernetes_master.private_ip
  bootstrap_token   = module.kubernetes_master.bootstrap_token


  worker_instance_type  = var.k8s_worker_instance_type
  worker_count          = var.k8s_worker_count
  worker_pool_subnet_id = aws_subnet.main_private.id
  worker_vpc_security_group_ids = [
    aws_security_group.ingress_ssh.id,
    aws_security_group.egress.id
  ]

  tags = local.tags
}


# module "jenkins" {
#   source            = "./modules/jenkins"
#   instance_image_id = data.aws_ami.latest_ubuntu.id
#   key_name          = aws_key_pair.default.key_name

#   master_instance_type = var.jenkins_master_instance_type
#   master_subnet_id     = aws_subnet.main_public.id

#   master_vpc_security_group_ids = [
#     aws_security_group.ingress_ssh.id,
#     aws_security_group.egress.id,
#     aws_security_group.ingress_jenkins.id
#   ]

#   tags = local.tags
# }


resource "aws_key_pair" "default" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
  tags       = local.tags
}
