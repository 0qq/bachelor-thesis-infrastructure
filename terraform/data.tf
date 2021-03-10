data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"] # Canonical
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "template_cloudinit_config" "master_config" {
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/bootstrap_data/common_init.sh")
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/bootstrap_data/master_init.tpl", {
      master_public_ip = aws_eip.k8s_master.public_ip,
      token            = local.token
    })
  }
}


data "template_cloudinit_config" "worker_config" {
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/bootstrap_data/common_init.sh")
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/bootstrap_data/worker_init.tpl", {
      master_private_ip = aws_instance.k8s_master.private_ip,
      token             = local.token,
    })
  }
}
