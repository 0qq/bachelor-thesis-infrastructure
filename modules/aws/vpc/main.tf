locals {
  tags            = merge(var.tags, { Terraform_module = "vpc" })
  subnet_settings = zipmap(var.subnet_azs, var.subnet_cidr_blocks)
}


# Custom VPC to launch aws resources
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = merge(local.tags, {
    "kubernetes.io/cluster/<${var.cluster_name}>" = "shared"
  })
}


# Give VPC internet access
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = local.tags
}


resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}


resource "aws_subnet" "this" {
  for_each = local.subnet_settings

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge(local.tags, {
    Name                                          = "subnet-${each.key}",
    "kubernetes.io/cluster/<${var.cluster_name}>" = "shared",
    "kubernetes.io/role/elb"                      = 1
  })
}


resource "aws_route_table_association" "this" {
  for_each = local.subnet_settings

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.this.id
}
