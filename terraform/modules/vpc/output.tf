output "vpc_id" {
  value = aws_vpc.main.id
}


output "gw_route_table_id" {
  value = aws_route_table.internet_access.id
}
