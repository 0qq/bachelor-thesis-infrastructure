locals {
  tags = merge(var.tags, { Terraform_module = "kubernetes_worker_pool" })
}


resource "aws_instance" "worker_pool" {
  ami              = var.instance_image_id
  key_name         = var.key_name
  instance_type    = var.worker_instance_type
  count            = var.worker_count
  subnet_id        = var.worker_pool_subnet_id
  user_data_base64 = data.template_cloudinit_config.worker_userdata.rendered
  # iam_instance_profile = file("${path.module}/data/iam_policy.json")

  vpc_security_group_ids = var.worker_vpc_security_group_ids

  lifecycle { create_before_destroy = true }

  tags = merge(local.tags, { Name = "Kubernetes_worker_${count.index}" })
}
