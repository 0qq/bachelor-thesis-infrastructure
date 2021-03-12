locals {
  tags = merge(var.tags, { Project = var.project })
}


resource "aws_key_pair" "default" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
  tags       = local.tags
}


# Generate bootstrap token
# https://kubernetes.io/docs/reference/access-authn-authz/bootstrap-tokens/
resource "random_string" "token_id" {
  length  = 6
  special = false
  upper   = false
}


resource "random_string" "token_secret" {
  length  = 16
  special = false
  upper   = false
}


locals {
  token = "${random_string.token_id.result}.${random_string.token_secret.result}"
}


# EIP for master node because it must know it's IPs during initialisation
resource "aws_eip" "k8s_master" {
  vpc  = true
  tags = local.tags
}


resource "aws_eip_association" "master" {
  allocation_id = aws_eip.k8s_master.id
  instance_id   = aws_instance.k8s_master.id
}


resource "aws_instance" "k8s_master" {
  ami              = data.aws_ami.latest_ubuntu.id
  key_name         = aws_key_pair.default.key_name
  instance_type    = var.k8s_master_instance_type
  subnet_id        = aws_subnet.main_public.id
  user_data_base64 = data.template_cloudinit_config.master_config.rendered

  vpc_security_group_ids = [
    aws_security_group.ingress_ssh.id,
    aws_security_group.egress.id,
    aws_security_group.ingress_k8s_api_server.id
  ]

  lifecycle { create_before_destroy = true }

  tags = merge(local.tags, { Name = "k8s_master" })
}


resource "aws_instance" "k8s_worker_pool" {
  ami              = data.aws_ami.latest_ubuntu.id
  key_name         = aws_key_pair.default.key_name
  instance_type    = var.k8s_worker_instance_type
  count            = var.k8s_worker_count
  subnet_id        = aws_subnet.main_public.id
  user_data_base64 = data.template_cloudinit_config.worker_config.rendered

  vpc_security_group_ids = [
    aws_security_group.ingress_ssh.id,
    aws_security_group.egress.id
  ]

  depends_on = [aws_instance.k8s_master]

  lifecycle { create_before_destroy = true }

  tags = merge(local.tags, { Name = "k8s_worker_${count.index}" })
}


resource "null_resource" "k8s_cluster_init" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    cluster_instance_ids = join(",", concat(
      [aws_instance.k8s_master.id],
      aws_instance.k8s_worker_pool[*].id)
    )
  }

  # Check bootstrap results
  provisioner "local-exec" {
    command = templatefile("${path.module}/bootstrap_data/k8s_bootstrap_check.tpl", {
      private_key       = var.private_key_path,
      master_public_ip  = aws_eip.k8s_master.public_ip,
      worker_public_ips = aws_instance.k8s_worker_pool[*].public_ip
    })
  }
}


# Allow Terraform to manage kubeconfig file
resource "local_file" "kubeconfig" {
  filename        = var.kubeconfig_name
  file_permission = "0644"

  # Download kubeconfig
  provisioner "local-exec" {
    command = templatefile("${path.module}/bootstrap_data/get_kubeconfig.tpl", {
      private_key      = var.private_key_path,
      master_public_ip = aws_eip.k8s_master.public_ip,
      kubeconfig_name  = self.filename
    })
  }

  # Create resource as soon as bootstrap complete
  depends_on = [null_resource.k8s_cluster_init]
}
