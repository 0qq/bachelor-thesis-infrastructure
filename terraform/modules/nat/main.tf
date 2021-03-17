locals {
  tags = merge(var.tags, { Terraform_module = "nat" })
}


resource "aws_nat_gateway" "default" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id

  tags = merge(local.tags, { Name = "default" })
}


resource "aws_eip" "nat" {
  vpc = true

  tags = merge(local.tags, { Name = "nat" })
}


resource "aws_route_table" "nat_route" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.default.id
  }

  tags = merge(local.tags, { Name = "nat_route_table" })
}


