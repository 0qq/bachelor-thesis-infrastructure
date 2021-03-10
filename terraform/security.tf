resource "aws_security_group" "ingress_ssh" {
  name        = "ingress_ssh"
  description = "Allow ingress ssh traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  tags = local.tags
}


resource "aws_security_group" "egress" {
  name        = "egress"
  description = "Allow all egress traffic"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}


resource "aws_security_group" "ingress_k8s_api_server" {
  name        = "ingress_k8s_api_server"
  description = "Allow ingress traffic to k8s api server"
  vpc_id      = aws_vpc.main.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
  }

  tags = local.tags
}
