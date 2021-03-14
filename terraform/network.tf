# Give VPC internet access
resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, { Name = "GW" })
}


# Custom VPC to launch aws resources
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = merge(local.tags, { Name = "VPC" })
}


resource "aws_subnet" "main_public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = merge(local.tags, { Name = "PUBLIC_SUB" })
}


resource "aws_subnet" "main_private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = merge(local.tags, { Name = "PRIVATE_SUB" })
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.main_public.id

  depends_on = [aws_internet_gateway.main_gw]

  tags = merge(local.tags, { Name = "NAT" })
}


resource "aws_eip" "nat" {
  vpc = true

  tags = merge(local.tags, { Name = "NAT_IP" })
}


resource "aws_route_table" "internet_access" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gw.id
  }

  tags = merge(local.tags, { Name = "RTB_IG" })
}


resource "aws_route_table" "nat_access" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(local.tags, { Name = "${var.project}_RTB_NAT" })
}


resource "aws_route_table_association" "internet_access" {
  subnet_id      = aws_subnet.main_public.id
  route_table_id = aws_route_table.internet_access.id
}


resource "aws_route_table_association" "nat" {
  subnet_id      = aws_subnet.main_private.id
  route_table_id = aws_route_table.nat_access.id
}
