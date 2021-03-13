locals {
  tags  = merge(var.tags, { module = "kubernetes" })
  token = "${random_string.token_id.result}.${random_string.token_secret.result}"
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


# EIP for master node because it must know it's IPs during initialisation
resource "aws_eip" "master" {
  vpc  = true
  tags = local.tags
}


resource "aws_eip_association" "master" {
  allocation_id = aws_eip.master.id
  instance_id   = aws_instance.master.id
}


resource "aws_instance" "master" {
  ami              = var.instance_image_id
  key_name         = var.key_name
  instance_type    = var.master_instance_type
  subnet_id        = var.master_subnet_id
  user_data_base64 = data.template_cloudinit_config.master_config.rendered

  vpc_security_group_ids = var.master_vpc_security_group_ids

  lifecycle { create_before_destroy = true }

  tags = merge(local.tags, { Name = "Kubernetes_master" })
}


resource "aws_instance" "worker_pool" {
  ami              = var.instance_image_id
  key_name         = var.key_name
  instance_type    = var.worker_instance_type
  count            = var.worker_count
  subnet_id        = var.worker_pool_subnet_id
  user_data_base64 = data.template_cloudinit_config.worker_config.rendered

  vpc_security_group_ids = var.worker_vpc_security_group_ids

  depends_on = [aws_instance.master]

  lifecycle { create_before_destroy = true }

  tags = merge(local.tags, { Name = "Kubernetes_worker_${count.index}" })
}


resource "null_resource" "cluster_init" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    cluster_instance_ids = join(",", concat(
      [aws_instance.master.id],
      aws_instance.worker_pool[*].id)
    )
  }

  # Check bootstrap results
  provisioner "local-exec" {
    command = templatefile("${path.module}/data/bootstrap_check.tpl", {
      private_key       = var.private_key_path,
      master_public_ip  = aws_eip.master.public_ip,
      worker_public_ips = aws_instance.worker_pool[*].public_ip
    })
  }
}


# Allow Terraform to manage kubeconfig file
resource "local_file" "kubeconfig" {
  filename        = var.kubeconfig_path
  file_permission = "0644"

  # Download kubeconfig
  provisioner "local-exec" {
    command = templatefile("${path.module}/data/get_kubeconfig.tpl", {
      private_key      = var.private_key_path,
      master_public_ip = aws_eip.master.public_ip,
      kubeconfig_name  = self.filename
    })
  }

  # Create resource as soon as bootstrap complete
  depends_on = [null_resource.cluster_init]
}