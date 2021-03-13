data "template_cloudinit_config" "master_config" {
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/data/common_init.sh")
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/data/master_init.tpl", {
      master_public_ip = aws_eip.master.public_ip,
      token            = local.token
    })
  }
}


data "template_cloudinit_config" "worker_config" {
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/data/common_init.sh")
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/data/worker_init.tpl", {
      master_private_ip = aws_instance.master.private_ip,
      token             = local.token,
    })
  }
}
