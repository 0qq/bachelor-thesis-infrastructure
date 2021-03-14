data "template_cloudinit_config" "worker_config" {
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/data/common_init.sh")
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/data/worker_init.tpl", {
      master_private_ip = var.master_private_ip,
      token             = var.bootstrap_token,
    })
  }
}
