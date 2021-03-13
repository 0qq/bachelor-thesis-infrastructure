locals {
  tags = merge(var.tags, { terraform_module = "jenkins" })
}

resource "aws_instance" "master" {
  ami           = var.instance_image_id
  key_name      = var.key_name
  instance_type = var.master_instance_type
  subnet_id     = var.master_subnet_id
  user_data     = file("${path.module}/data/master_init.sh")

  vpc_security_group_ids = var.master_vpc_security_group_ids

  lifecycle { create_before_destroy = true }

  tags = merge(local.tags, { Name = "Jenkins_master" })
}
