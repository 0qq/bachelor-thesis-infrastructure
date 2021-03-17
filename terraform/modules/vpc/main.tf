locals {
  tags = merge(var.tags, { Terraform_module = "vpc" })
} 


# Custom VPC to launch aws resources
resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = merge(local.tags, { Name = "VPC" })
}


# Give VPC internet access
resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, { Name = "GW" })
}


resource "aws_route_table" "internet_access" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gw.id
  }

  tags = merge(local.tags, { Name = "RTB_IG" })
}


