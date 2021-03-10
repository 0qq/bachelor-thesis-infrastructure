# Give VPC internet access
resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, { Name = "${var.project}_GW" })
}


# Custom VPC to launch aws resources
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = merge(local.tags, { Name = "${var.project}_VPC" })
}


resource "aws_subnet" "main_public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = merge(local.tags, { Name = "${var.project}_PUBLIC_SUB" })
}


resource "aws_route_table" "internet_access" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gw.id
  }

  tags = merge(local.tags, { Name = "${var.project}_RTB" })
}


resource "aws_route_table_association" "internet_access" {
  subnet_id      = aws_subnet.main_public.id
  route_table_id = aws_route_table.internet_access.id
}
