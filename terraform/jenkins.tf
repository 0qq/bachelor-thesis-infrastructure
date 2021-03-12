resource "aws_instance" "jenkins_master" {
  ami           = data.aws_ami.latest_ubuntu.id
  key_name      = aws_key_pair.default.key_name
  instance_type = var.jenkins_master_instance_type
  subnet_id     = aws_subnet.main_public.id
  user_data     = <<-USERDATA
  #!/usr/bin/env bash
  wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
  cat <<EOF | tee /etc/apt/sources.list.d/jenkins.list
  deb https://pkg.jenkins.io/debian-stable binary/
  EOF
  apt-get update
  apt-get -y upgrade
  apt install -y openjdk-11-jre-headless jenkins
  apt install -y jenkins
  USERDATA

  vpc_security_group_ids = [
    aws_security_group.ingress_ssh.id,
    aws_security_group.egress.id,
    aws_security_group.ingress_jenkins.id
  ]

  lifecycle { create_before_destroy = true }

  tags = merge(local.tags, { Name = "Jenkins_master" })
}
